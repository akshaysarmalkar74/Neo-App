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
    static func userRegister(firstName: String, lastName: String, email: String, password: String, confirmPassword: String ,gender: String, phoneNumber: Int, completionHandler: @escaping(APIResponse<RegisterResponse>) -> Void) {
        
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
                // Decode the data
                do {
                    if let extractedData = value as? Data {
                        let registerRes = try JSONDecoder().decode(RegisterResponse.self, from: extractedData)
                        completionHandler(.success(value: registerRes))
                    } else {
                        print("Some Error while converting to data")
                    }
                } catch {
                    print("Error - \(error.localizedDescription)")
                }
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
    
    // Forgot Password
    static func userForgotPassword(email: String, completionHandler: @escaping(APIResponse<Any>) -> Void) {
        let params: AnyDict = ["email": email]
        
        // Perform Request
        APIManager.sharedInstance.performRequest(serviceType: .forgotPassword(parameters: params)) { response in
            switch response {
            case .success(value: let value):
                completionHandler(.success(value: value))
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
    
    // Reset Password
    static func resetPassword(password: String, confirmPassword: String, oldPassword: String, completionHandler: @escaping(APIResponse<Any>) -> Void) {
        let params: AnyDict = [
            "password": password,
            "confirm_password": confirmPassword,
            "old_password": oldPassword
        ]
        

        // Get New Headers (Access Token)
        let accessToken = UserDefaults.standard.getUserToken() ?? ""
        
        APIManager.sharedInstance.performRequest(serviceType: .changePassword(parameters: params, headers: ["access_token": accessToken])) { response in
            switch response {
            case .success(value: let value):
                completionHandler(.success(value: value))
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
    
    // Update Profile
    static func updateUser(firstName: String, lastName: String, email: String, phoneNo: Int, birthDate: String, profilePic: String , completionHandler: @escaping(APIResponse<Any>) -> Void) {
        let params: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "phone_no": phoneNo,
            "dob": birthDate,
            "profile_pic": profilePic
        ]
        
        
        // Get New Headers (Access Token)
        let accessToken = UserDefaults.standard.getUserToken() ?? ""
        
        APIManager.sharedInstance.performRequest(serviceType: .updateUserProfile(parameters: params, headers: ["access_token": accessToken])) { response in
            switch response {
            case .success(value: let value):
                completionHandler(.success(value: value))
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
    
    // Fetch User Details
    static func getUserDetails(completionHandler: @escaping(APIResponse<Any>) -> Void) {
        // Get New Headers (Access Token)
        let accessToken = UserDefaults.standard.getUserToken() ?? ""
        
        APIManager.sharedInstance.performRequest(serviceType: .getUser(headers: ["access_token": accessToken])) { response in
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
