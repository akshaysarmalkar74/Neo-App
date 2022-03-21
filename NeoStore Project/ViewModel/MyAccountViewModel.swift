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
    case success
    case failure(msg: String?)
    case none
}

protocol MyAccountViewType {
    var firstName: String {get set}
    var lastName: String {get set}
    var email: String {get set}
    var phoneNum: String {get set}
    var birthDate: String {get set}
    var user: UserData! {get set}
    var currentProfileImgUrl: String {get set}
    
    var updateUserStatus: ReactiveListener<UpdateAccountApiResult> {get set}
    var userDetailsStatus: ReactiveListener<UserDetailsApiResult> {get set}
    
    func updateUser()
    func getUser()
    func getUserFromDefaults()
    func retriveCurrentUser() -> UserData
    func getCurrentProfileImgUrl()
    func saveTextFromTextField(text: String?, tag: Int)
}

class MyAccountScreenViewModel: MyAccountViewType {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNum: String = ""
    var birthDate: String = ""
    var currentProfileImgUrl: String = ""
    var user: UserData! {
        didSet {
            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
            email = user.email ?? ""
            phoneNum = user.phoneNo ?? ""
            birthDate = user.dob ?? ""
        }
    }
    
    var userDetailsStatus: ReactiveListener<UserDetailsApiResult> = ReactiveListener(.none)
    var updateUserStatus: ReactiveListener<UpdateAccountApiResult> = ReactiveListener(.none)
    
    // Update User
    func updateUser() {
        // Get Validation Result
        let validationResult = validateMyAccountFields()
        
        switch validationResult {
        case .success:
            break
        case .failure(msg: let msg):
            self.updateUserStatus.value = .failure(msg: msg.rawValue)
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            let actualPhoneNum: Int = Int(phoneNum)!
                
            UserService.updateUser(firstName: firstName, lastName: lastName ,email: email, phoneNo: actualPhoneNum, birthDate: birthDate, profilePic: "") { res in
                switch res {
                case .success(value: let value):
                    if let statusCode = value.status, statusCode == 200 {
                        self.updateUserStatus.value = .success
                    } else {
                        self.updateUserStatus.value = .failure(msg: value.userMsg)
                    }
                case .failure(error: let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            self.updateUserStatus.value = .failure(msg: "No Internet, please try again!")
        }

    }
    
    // Get Current User
    func getUser() {
        UserService.getUserDetails { res in
            switch res {
            case .success(value: let value):
                if let statusCode = value.status, statusCode == 200 {
                    if let userData = value.data?.userData {
                        // Save User to Defaults
                        UserDefaults.standard.saveUserInstance(user: userData)
                        // Update user in view mode
                        self.user = userData
                        self.userDetailsStatus.value = .success
                    }
                } else {
//                    self.userDetailsStatus.value = .failure(msg: value.userMsg)
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Get User from User Defaults
    func getUserFromDefaults() {
        self.user = UserDefaults.standard.getUserInstance()
    }
    
    // Send stored User
    func retriveCurrentUser() -> UserData {
        return user
    }
    
    // Get Current Profile Image
    func getCurrentProfileImgUrl() {
        currentProfileImgUrl =  user.profilePic ?? "profileDemo"
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
            phoneNum = text ?? ""
        case 5:
            birthDate = text ?? ""
        default:
            break
        }
    }
    
    // Validate Fields
    func validateMyAccountFields() -> ValidationResult {
        
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

        if phoneNum.isEmpty {
            return .failure(msg: .noPhone)
        }
        
        if !phoneNum.isValidPhone() {
            return .failure(msg: .invalidPhone)
        }
        
        if birthDate.isEmpty {
            return .failure(msg: .noBirthDate)
        }
        
        return .success
    }
}
