//
//  LoginScreenViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 03/02/22.
//

import Foundation

enum LoginStatus {
    case success
    case failure(msg: String?)
    case none
}

protocol LoginScreenViewType {
    var userLoginStatus: ReactiveListener<LoginStatus> {get set}
    
    func doLogin(username: String, password: String)
}

class LoginScreenViewModel: LoginScreenViewType {
    
    var userLoginStatus: ReactiveListener<LoginStatus> = ReactiveListener(.none)
    
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
}