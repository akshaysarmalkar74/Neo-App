//
//  Validator.swift
//  NeoStore Project
//
//  Created by Neosoft on 03/02/22.
//

import Foundation
import UIKit

class Validator {
    
    // Validate Email
    static func email(str: String) -> (message: String?, result: Bool) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailPred.evaluate(with: str)
        
        if result {
            return (nil, true)
        }
        return ("Please enter Valid Email", false)
    }
    
    // Login Validate Password
    static func loginPassword(str: String) -> (message: String?, result: Bool) {
        if str.count > 0 {
            return (nil, true)
        }
        return ("Please enter password", false)
    }
    
    // Register Validate Password
    static func registerPassword(str: String) -> (message: String?, result: Bool) {
        if str.count == 0 {
            return ("Please enter password", false)
        } else if str.count < 6 {
            return ("Password should be more than 6 characters", false)
        } else {
            return (nil, true)
        }
    }
    
    // Validate First Name
    static func firstName(str: String) -> (message: String?, result: Bool) {
        if str.count > 0 {
            return (nil, true)
        }
        return ("Please enter first name", false)
    }
    
    // Validate Last Name
    static func lastName(str: String) -> (message: String?, result: Bool) {
        if str.count > 0 {
            return (nil, true)
        }
        return ("Please enter last name", false)
    }
    
    // Validate Phone Number
    static func phoneNumber(str: String) -> (message: String?, result: Bool) {
        if str.count == 10 {
            return (nil, true)
        }
        return ("Phone should be 10 numbers exactly", false)
    }
    
    // Validate Confirm Password
    static func confirmPassword(password: String, confirmPass: String) -> (message: String?, result: Bool) {
        if password == confirmPass {
            return (nil, true)
        }
        return ("Passwords do not match", false)
    }
    
    // Validate Terms Button
    static func termsChecked(btn: UIButton) -> (message: String?, result: Bool) {
        if btn.isSelected {
            return (nil, true)
        }
        return ("Please agree to Terms & Conditions", false)
    }
}
