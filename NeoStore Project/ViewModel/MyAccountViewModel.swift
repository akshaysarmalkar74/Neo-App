//
//  MyAccountViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 14/02/22.
//

import Foundation

enum UpdateAccountApiResult {
    case success
    case failure(msg: String?)
    case none
}

enum UserDetailsApiResult {
    case success(user: [String: Any])
    case failure(msg: String?)
    case none
}

protocol MyAccountViewType {
    var updateUserStatus: ReactiveListener<UpdateAccountApiResult> {get set}
    var userDetailsStatus: ReactiveListener<UserDetailsApiResult> {get set}
    
    func updateUser(firstName: String, lastName: String, email: String, birthDate: String, phoneNo: Int, profilePic: String)
    func getUser()
}

class MyAccountScreenViewModel: MyAccountViewType {
    var userDetailsStatus: ReactiveListener<UserDetailsApiResult> = ReactiveListener(.none)
    var updateUserStatus: ReactiveListener<UpdateAccountApiResult> = ReactiveListener(.none)
    
    // Update User
    func updateUser(firstName: String, lastName: String, email: String, birthDate: String, phoneNo: Int, profilePic: String) {
        UserService.updateUser(firstName: firstName, lastName: lastName ,email: email, phoneNo: phoneNo, birthDate: birthDate, profilePic: profilePic) { res in
            switch res {
            case .success(value: let value):
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
                        print(mainData)
                        if let statusCode = mainData["status"] as? Int {
                            if statusCode == 200 {
                                self.updateUserStatus.value = .success
                            } else {
                                // Show Error to User
                                let userMsg = mainData["user_msg"] as? String
                                self.updateUserStatus.value = .failure(msg: userMsg)
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
    
    // Get Current User
    func getUser() {
        UserService.getUserDetails { res in
            switch res {
            case .success(value: let value):
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
                        
                        if let statusCode = mainData["status"] as? Int {
                            if statusCode == 200 {
                                print("Got User from API")
                                let tempData = mainData["data"] as? [String: Any] ?? [String: Any]()
                                let user = tempData["user_data"] as? [String: Any] ?? [String: Any]()
                                
                                // Update User Defaults
                                UserDefaults.standard.saveUser(value: user)
                                
                                // Pass user to VC
                                self.userDetailsStatus.value = .success(user: user)
                            } else {
                                // Show Error to User
                                let userMsg = mainData["user_msg"] as? String
                                self.updateUserStatus.value = .failure(msg: userMsg)
                            }
                        }
                    } catch let err {
                        print(err.localizedDescription)
                    }
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
}
