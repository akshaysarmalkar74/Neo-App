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
    var userLoginStatus: ReactiveListener<LoginStatus> {get set}
    var userForgotStatus: ReactiveListener<ForgotApiStatus> {get set}
    
    func doLogin(username: String, password: String)
    func forgotPassword(email: String)
}

class LoginScreenViewModel: LoginScreenViewType {
    
    var userLoginStatus: ReactiveListener<LoginStatus> = ReactiveListener(.none)
    var userForgotStatus: ReactiveListener<ForgotApiStatus> = ReactiveListener(.none)
    
    init() {}
    
    // MARK:- Methods
    func doLogin(username: String, password: String) {
        let emailTuple = Validator.email(str: username)
        let passwordTuple  = Validator.loginPassword(str: password)
        
        if emailTuple.result && passwordTuple.result {
            UserService.userLogin(username: username, password: password) { res in
                switch res {
                case .success(value: let value):
                    if let curData = value as? Data {
                        do {
                            let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
                            
                            if let statusCode = mainData["status"] as? Int {
                                if statusCode == 200 {
                                    // Save user data to User Defaults
                                    let userData = mainData["data"] as! [String: Any]
                                    UserDefaults.standard.saveUser(value: userData)
                                    UserDefaults.standard.setLoggedIn(value: true)
                                    UserDefaults.standard.setUserToken(value: userData["access_token"] as! String)
                                    self.userLoginStatus.value = .success
                                } else {
                                    // Show Error to User
                                    let userMsg = mainData["user_msg"] as? String
                                    self.userLoginStatus.value = .failure(msg: userMsg)
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
        } else if !emailTuple.result {
            // Show Alert for Email
            self.userLoginStatus.value = .failure(msg: emailTuple.message)
        } else {
            // Show Alert for password
            self.userLoginStatus.value = .failure(msg: passwordTuple.message)
        }
    }
    
    func forgotPassword(email: String) {
        
        let emailResult = Validator.email(str: email)
        
        if emailResult.result {
            UserService.userForgotPassword(email: email) { res in
                switch res {
                case .success(value: let value):
                    if let curData = value as? Data {
                        do {
                            let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
                            
                            if let statusCode = mainData["status"] as? Int {
                                let userMsg = mainData["user_msg"] as? String
                                if statusCode == 200 {
                                    self.userForgotStatus.value = .success(msg: userMsg)
                                } else {
                                    // Show Error to User
                                    self.userForgotStatus.value = .failure(msg: userMsg)
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
        } else {
            self.userForgotStatus.value = .failure(msg: emailResult.message)
        }
    }
}
