//
//  ResetPasswordScreenViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 10/02/22.
//

import Foundation

enum ResetApiStatus {
    case success(success: String?)
    case failure(msg: String?)
    case none
}

protocol ResetPasswordScreenViewType {
    var newPassword: String {get set}
    var confirmPassword: String {get set}
    var currentPassword: String {get set}
    var passwordResetStatus: ReactiveListener<ResetApiStatus> {get set}
    
    func reset()
    func saveTextFromTextField(text: String?, tag: Int)
}

class ResetPasswordScreenViewModel: ResetPasswordScreenViewType {
    var newPassword: String = ""
    var confirmPassword: String = ""
    var currentPassword: String = ""
    
    var passwordResetStatus: ReactiveListener<ResetApiStatus> = ReactiveListener(.none)
    
    init() {}
    
    func reset() {
        
        // Get Validation Result
        let validationResult = validateResetFields()
        
        switch validationResult {
        case .success:
            break
        case .failure(msg: let msg):
            self.passwordResetStatus.value = .failure(msg: msg.rawValue)
        }
        
        if Reachability.isConnectedToNetwork() {
            UserService.resetPassword(password: newPassword, confirmPassword: confirmPassword, oldPassword: currentPassword) { res in
                switch res {
                case .success(value: let value):
                    // Check for success status
                    if let statusCode = value.status, statusCode == 200 {
                        self.passwordResetStatus.value = .success(success: value.userMsg)
                    } else {
                        self.passwordResetStatus.value = .failure(msg: value.userMsg)
                    }
                
                case .failure(error: let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            self.passwordResetStatus.value = .failure(msg: "No Internet, please try again!")
        }
    }
    
    // Extract Text from Text Fields
    func saveTextFromTextField(text: String?, tag: Int) {
        switch tag {
        case 1:
            currentPassword = text ?? ""
        case 2:
            newPassword = text ?? ""
        case 3:
            confirmPassword = text ?? ""
        default:
            break
        }
    }
    
    // Validate Reset Fields
    func validateResetFields() -> ValidationResult {
        if currentPassword.isEmpty {
            return .failure(msg: .noCurrentPassword)
        }
        
        if newPassword.isEmpty {
            return .failure(msg: .noNewPassword)
        }
        
        if newPassword.count < 6 {
            return .failure(msg: .shortNewPassword)
        }
        
        if confirmPassword != newPassword {
            return .failure(msg: .invalidConfirmPassword)
        }
        
        return .success
    }
    
}
