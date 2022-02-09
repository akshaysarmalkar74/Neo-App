//
//  RegisterScreenViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 07/02/22.
//

import Foundation

enum RegisterApiStatus {
    case success
    case failure(msg: String?)
    case none
}

protocol RegisterScreenViewType {
    var userRegisterStatus: ReactiveListener<RegisterApiStatus> {get set}
    
    func doRegister(firstName: String, lastName: String, email: String, password: String, confirmPassword: String, gender: String, phoneNumber: Int)
}

class RegisterScreenViewModel: RegisterScreenViewType {
    
    var userRegisterStatus: ReactiveListener<RegisterApiStatus> = ReactiveListener(.none)
    
    init() {}
    
    // MARK:- Methods
    func doRegister(firstName: String, lastName: String, email: String, password: String, confirmPassword: String, gender: String, phoneNumber: Int) {
        UserService.userRegister(firstName: firstName, lastName: lastName, email: email, password: password, confirmPassword: confirmPassword, gender: gender, phoneNumber: phoneNumber) { response in
            switch response {
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
                                self.userRegisterStatus.value = .success
                            } else {
                                // Show Error to User
                                let userMsg = mainData["user_msg"] as? String
                                self.userRegisterStatus.value = .failure(msg: userMsg)
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
    }
}
