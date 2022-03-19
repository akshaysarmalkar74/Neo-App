//
//  ForgotScreenViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 09/02/22.
//

import Foundation

//enum ForgotApiStatus {
//    case success(msg: String?)
//    case failure(msg: String?)
//    case none
//}

protocol ForgotScreenViewType {
    var userForgotStatus: ReactiveListener<ForgotApiStatus> {get set}
    
    func forgotPassword(email: String)
}

class ForgotScreenViewModel: ForgotScreenViewType {
    
    var userForgotStatus: ReactiveListener<ForgotApiStatus> = ReactiveListener(.none)
    
    init() {}
    
    // MARK:- Methods
    func forgotPassword(email: String) {
        
        let emailResult = Validator.email(str: email)
        
//        if emailResult.result {
//            UserService.userForgotPassword(email: email) { res in
//                switch res {
//                case .success(value: let value):
//                    if let curData = value as? Data {
//                        do {
//                            let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
//
//                            if let statusCode = mainData["status"] as? Int {
//                                let userMsg = mainData["user_msg"] as? String
//                                if statusCode == 200 {
//                                    self.userForgotStatus.value = .success(msg: userMsg)
//                                } else {
//                                    // Show Error to User
//                                    self.userForgotStatus.value = .failure(msg: userMsg)
//                                }
//                            }
//                        } catch let err {
//                            print(err.localizedDescription)
//                        }
//                    } else {
//                        print("Some Another Error")
//                    }
//                case .failure(error: let error):
//                    print(error.localizedDescription)
//                }
//            }
//        } else {
//            self.userForgotStatus.value = .failure(msg: emailResult.message)
//        }
    }
}
