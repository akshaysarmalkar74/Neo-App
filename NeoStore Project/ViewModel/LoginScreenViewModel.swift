//
//  LoginScreenViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 03/02/22.
//

import Foundation

enum ForgotApiStatus {
    case success(msg: String?)
    case failure(msg: String?)
    case none
}

enum LoginStatus {
    case success
    case failure(msg: String?)
    case none
}

protocol LoginScreenViewType {
    var username: String {get set}
    var password: String {get set}
    var email: String {get set}
    var userLoginStatus: ReactiveListener<LoginStatus> {get set}
    var userForgotStatus: ReactiveListener<ForgotApiStatus> {get set}
    
    func doLogin()
    func forgotPassword()
    func saveTextFromTextField(text: String?, tag: Int)
}

class LoginScreenViewModel: LoginScreenViewType {
    var username: String = ""
    var password: String = ""
    var email: String = ""
    
    var userLoginStatus: ReactiveListener<LoginStatus> = ReactiveListener(.none)
    var userForgotStatus: ReactiveListener<ForgotApiStatus> = ReactiveListener(.none)
    
    init() {}
    
    // MARK:- Methods
    func doLogin() {
        // Get Validation Result
        let validationResult = validateLoginFields()
        
        switch validationResult {
        case .success:
            break
        case .failure(msg: let msg):
            self.userLoginStatus.value = .failure(msg: msg.rawValue)
            return
        }
        
        // Check Reachibility
        if Reachability.isConnectedToNetwork() {
            UserService.userLogin(username: username, password: password) { res in
                switch res {
                case .success(value: let value):
                    // Check for success status
                    if let statusCode = value.status, statusCode == 200 {
                        if let userData = value.data {
                            // Save User to Defaults
                            UserDefaults.standard.saveUserInstance(user: userData)
                            UserDefaults.standard.setLoggedIn(value: true)
                            UserDefaults.standard.setUserToken(value: userData.accessToken ?? "")
                            self.userLoginStatus.value = .success
                        }
                    } else {
                        self.userLoginStatus.value = .failure(msg: value.userMsg)
                    }
                case .failure(error: let error):
                    self.userLoginStatus.value = .failure(msg: "Email or password is wrong!")
                }
            }
        }else{
            self.userLoginStatus.value = .failure(msg: "No Internet, please try again!")
        }
    }
    
    func forgotPassword() {
        
        // Get Validation Result
        let validationResult = validateForgotPasswordFields()
        
        switch validationResult {
        case .success:
            break
        case .failure(msg: let msg):
            self.userForgotStatus.value = .failure(msg: msg.rawValue)
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            UserService.userForgotPassword(email: email) { res in
                switch res {
                case .success(value: let value):
                    // Check for success status
                    if let statusCode = value.status, statusCode == 200 {
                        self.userForgotStatus.value = .success(msg: value.userMsg)
                    } else {
                        self.userForgotStatus.value = .failure(msg: value.userMsg)
                    }
                    
                case .failure(error: let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            self.userForgotStatus.value = .failure(msg: "No Internet, please try again!")
        }
    }
    
    // Extract Text from Text Fields
    func saveTextFromTextField(text: String?, tag: Int) {
        switch tag {
        case 1:
            username = text ?? ""
        case 2:
            password = text ?? ""
        case 3:
            email = text ?? ""
        default:
            break
        }
    }
    
    // Validate Login Func
    func validateLoginFields() -> ValidationResult {
        // Validate Username / Email
        if username.isEmpty {
            return .failure(msg: .noEmail)
        }
        
        if !username.isValidEmail() {
            return .failure(msg: .invalidEmail)
        }
        
        if password.isEmpty {
            return .failure(msg: .noPasswordLogin)
        }
        
        return .success
    }
    
    // Validate Forgot Password
    func validateForgotPasswordFields() -> ValidationResult {
        // Validate Email
        if email.isEmpty {
            return .failure(msg: .noEmail)
        }
        
        if !email.isValidEmail() {
            return .failure(msg: .invalidEmail)
        }
        
        return .success
    }
}
