//
//  RegisterScreenViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 07/02/22.
//

import Foundation
import UIKit

enum RegisterApiStatus {
    case success
    case failure(msg: String?)
    case none
}

protocol RegisterScreenViewType {
    var firstName: String {get set}
    var lastName: String {get set}
    var email: String {get set}
    var password: String {get set}
    var confirmPassword: String {get set}
    var phoneNum: String {get set}
    var gender: String {get set}
    var isTermsChecked: Bool {get set}
    
    var userRegisterStatus: ReactiveListener<RegisterApiStatus> {get set}
    
    func doRegister()
    func saveTextFromTextField(text: String?, tag: Int)
    func setGenderValue(value: String)
    func setTermsChecked(value: Bool)
}

class RegisterScreenViewModel: RegisterScreenViewType {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var phoneNum: String = ""
    var gender: String = ""
    var isTermsChecked: Bool = false
    
    var userRegisterStatus: ReactiveListener<RegisterApiStatus> = ReactiveListener(.none)
    
    init() {}
    
    // MARK:- Methods
    func doRegister() {
        
        // Validate Fields
        let validationResult = validateRegisterFields()
        
        switch validationResult {
        case .success:
            break
        case .failure(msg: let msg):
            self.userRegisterStatus.value = .failure(msg: msg.rawValue)
            return
        }
                
        if Reachability.isConnectedToNetwork() {
            let actualPhoneNum: Int = Int(phoneNum)!
            
            UserService.userRegister(firstName: firstName, lastName: lastName, email: email, password: password, confirmPassword: confirmPassword, gender: gender, phoneNumber: actualPhoneNum) { response in
                switch response {
                case .success(value: let value):
                    // Check for success status
                    if let statusCode = value.status, statusCode == 200 {
                        if let userData = value.data {
                            // Save User to Defaults
                            UserDefaults.standard.saveUserInstance(user: userData)
                            UserDefaults.standard.setLoggedIn(value: true)
                            UserDefaults.standard.setUserToken(value: userData.accessToken ?? "")
                            self.userRegisterStatus.value = .success
                        }
                    } else {
                        self.userRegisterStatus.value = .failure(msg: value.userMsg)
                    }
                case .failure(error: let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            self.userRegisterStatus.value = .failure(msg: "No Internet, please try again!")
        }
    }
    
    func setGenderValue(value: String) {
        self.gender = value
    }
    
    func setTermsChecked(value: Bool) {
        isTermsChecked = value
    }
    
    // Extract Text from Text Fields
    func saveTextFromTextField(text: String?, tag: Int) {
        switch tag {
        case 1:
            firstName = text ?? ""
        case 2:
            lastName = text ?? ""
        case 3:
            email = text ?? ""
        case 4:
            password = text ?? ""
        case 5:
            confirmPassword = text ?? ""
        case 6:
            phoneNum = text ?? ""
        default:
            break
        }
    }
    
    // Validate Fields
    func validateRegisterFields() -> ValidationResult {
        
        if firstName.isEmpty {
            return .failure(msg: .noFirstName)
        }
        
        if !firstName.containsOnlyLettersAndWhitespace() {
            return .failure(msg: .invalidFirstName)
        }
        
        if lastName.isEmpty {
            return .failure(msg: .noLastName)
        }
        
        if !lastName.containsOnlyLettersAndWhitespace() {
            return .failure(msg: .invalidLastName)
        }
        
        if email.isEmpty {
            return .failure(msg: .noEmail)
        }
        
        if !email.isValidEmail() {
            return .failure(msg: .invalidEmail)
        }
        
        if password.isEmpty {
            return .failure(msg: .noNewPassword)
        }
        
        if password.count < 6 {
            return .failure(msg: .shortNewPassword)
        }
        
        if confirmPassword != password {
            return .failure(msg: .invalidConfirmPassword)
        }

        if phoneNum.isEmpty {
            return .failure(msg: .noPhone)
        }
        
        if !phoneNum.isValidPhone() {
            return .failure(msg: .invalidPhone)
        }
        
        if !isTermsChecked {
            return .failure(msg: .termsNotChecked)
        }
        
        return .success
    }
}
