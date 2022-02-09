//
//  UserService.swift
//  NeoStore Project
//
//  Created by Neosoft on 03/02/22.
//

import Foundation

class UserService {
    
    // Login
    static func userLogin(username: String, password: String, completionHandler: @escaping(APIResponse<Any>) -> Void) {
        
        let params = ["email": username, "password": password]
        
        // Perform Request
        APIManager.sharedInstance.performRequest(serviceType: .userLogin(parameters: params)) { response in
            switch response {
            case .success(value: let value):
                completionHandler(.success(value: value))
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
    
    // Register
    static func userRegister(firstName: String, lastName: String, email: String, password: String, confirmPassword: String ,gender: String, phoneNumber: Int, completionHandler: @escaping(APIResponse<Any>) -> Void) {
        
        let params: AnyDict = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password,
            "confirm_password": confirmPassword,
            "gender": gender,
            "phone_no": phoneNumber
        ]
        
        // Perform Request
        APIManager.sharedInstance.performRequest(serviceType: .userRegister(parameters: params)) { response in
            switch response {
            case .success(value: let value):
                completionHandler(.success(value: value))
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
}
