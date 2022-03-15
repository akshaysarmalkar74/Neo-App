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
    case success(user: UserData)
    case failure(msg: String?)
    case none
}

protocol MyAccountViewType {
    var updateUserStatus: ReactiveListener<UpdateAccountApiResult> {get set}
    var userDetailsStatus: ReactiveListener<UserDetailsApiResult> {get set}
    
    func updateUser(firstName: String, lastName: String, email: String, birthDate: String, phoneNo: String, profilePic: String)
    func getUser()
}

class MyAccountScreenViewModel: MyAccountViewType {
    var userDetailsStatus: ReactiveListener<UserDetailsApiResult> = ReactiveListener(.none)
    var updateUserStatus: ReactiveListener<UpdateAccountApiResult> = ReactiveListener(.none)
    
    // Update User
    func updateUser(firstName: String, lastName: String, email: String, birthDate: String, phoneNo: String, profilePic: String) {
        // Get Validations Results
        let firstNameResult = Validator.firstName(str: firstName)
        let lastNameResult = Validator.lastName(str: lastName)
        let emailResult = Validator.email(str: email)
        let phoneResult = Validator.phoneNumber(str: phoneNo)
        
        if firstNameResult.result && lastNameResult.result && emailResult.result && phoneResult.result {
            let actualPhoneNum: Int = Int(phoneNo)!
                
            UserService.updateUser(firstName: firstName, lastName: lastName ,email: email, phoneNo: actualPhoneNum, birthDate: birthDate, profilePic: profilePic) { res in
                switch res {
                case .success(value: let value):
    //                if let curData = value as? Data {
    //                    do {
    //                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
    //                        print(mainData)
    //                        if let statusCode = mainData["status"] as? Int {
    //                            if statusCode == 200 {
    //                                self.updateUserStatus.value = .success
    //                            } else {
    //                                // Show Error to User
    //                                let userMsg = mainData["user_msg"] as? String
    //                                self.updateUserStatus.value = .failure(msg: userMsg)
    //                            }
    //                        }
    //                    } catch let err {
    //                        print(err.localizedDescription)
    //                    }
    //                } else {
    //                    print("Some Another Error")
    //                }
                
                    if let statusCode = value.status, statusCode == 200 {
                        self.updateUserStatus.value = .success
                    } else {
                        self.updateUserStatus.value = .failure(msg: value.userMsg)
                    }
                case .failure(error: let error):
                    print(error.localizedDescription)
                }
            }
        } else if !firstNameResult.result {
            self.updateUserStatus.value = .failure(msg: firstNameResult.message)
        } else if !lastNameResult.result {
            self.updateUserStatus.value = .failure(msg: lastNameResult.message)
        } else if !emailResult.result {
            self.updateUserStatus.value = .failure(msg: emailResult.message)
        } else {
            self.updateUserStatus.value = .failure(msg: phoneResult.message)
        }
        
        
    }
    
    // Get Current User
    func getUser() {
        UserService.getUserDetails { res in
            switch res {
            case .success(value: let value):
//                if let curData = value as? Data {
//                    do {
//                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
//
//                        if let statusCode = mainData["status"] as? Int {
//                            if statusCode == 200 {
//                                print("Got User from API")
//                                let tempData = mainData["data"] as? [String: Any] ?? [String: Any]()
//                                let user = tempData["user_data"] as? [String: Any] ?? [String: Any]()
//
//                                // Update User Defaults
//                                UserDefaults.standard.saveUser(value: user)
//
//                                // Pass user to VC
//                                self.userDetailsStatus.value = .success(user: user)
//                            } else {
//                                // Show Error to User
//                                let userMsg = mainData["user_msg"] as? String
//                                self.updateUserStatus.value = .failure(msg: userMsg)
//                            }
//                        }
//                    } catch let err {
//                        print(err.localizedDescription)
//                    }
//                }
                if let statusCode = value.status, statusCode == 200 {
                    if let userData = value.data?.userData {
                        // Save User to Defaults
                        UserDefaults.standard.saveUserInstance(user: userData)
                        // Pass User to Vc
                        self.userDetailsStatus.value = .success(user: userData)
                    }
                } else {
                    self.userDetailsStatus.value = .failure(msg: value.userMsg)
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
}
