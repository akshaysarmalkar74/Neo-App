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
    var passwordResetStatus: ReactiveListener<ResetApiStatus> {get set}
    
    func reset(password: String, confirmPassword: String, oldPassword: String)
}

class ResetPasswordScreenViewModel: ResetPasswordScreenViewType {
    var passwordResetStatus: ReactiveListener<ResetApiStatus> = ReactiveListener(.none)
    
    func reset(password: String, confirmPassword: String, oldPassword: String) {
        let passwordResult = Validator.loginPassword(str: oldPassword)
        let newPasswordResult = Validator.registerPassword(str: password)
        let confirmPassResult = Validator.confirmPassword(password: password, confirmPass: confirmPassword)
        
        
        if passwordResult.result && newPasswordResult.result && confirmPassResult.result {
            // Make Request
            UserService.resetPassword(password: password, confirmPassword: confirmPassword, oldPassword: oldPassword) { res in
                switch res {
                case .success(value: let value):
                    if let curData = value as? Data {
                        do {
                            let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
                            
                            if let statusCode = mainData["status"] as? Int {
                                let userMsg = mainData["user_msg"] as? String
                                if statusCode == 200 {
                                    self.passwordResetStatus.value = .success(success: userMsg)
                                } else {
                                    // Show Error to User
                                    self.passwordResetStatus.value = .failure(msg: userMsg)
                                }
                            }
                        } catch let err {
                            print(err.localizedDescription)
                        }
                    } else {
                        print("Some Another Error")
                    }
                case .failure(error: let error):
                    print(error.localizedDescription)
                }
            }
        } else if !passwordResult.result {
            self.passwordResetStatus.value = .failure(msg: passwordResult.message)
        } else if !newPasswordResult.result {
            self.passwordResetStatus.value = .failure(msg: newPasswordResult.message)
        } else {
            self.passwordResetStatus.value = .failure(msg: confirmPassResult.message)
        }
    }
    
    
}
