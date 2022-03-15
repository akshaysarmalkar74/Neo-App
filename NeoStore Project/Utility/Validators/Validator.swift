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
        
        if str.count == 0 {
           return ("Email cannot be blank", false)
        } else {
            let result = emailPred.evaluate(with: str)
            if result {
                return (nil, true)
            }
            return ("Please enter valid email", false)
        }
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
        if str.count == 0 {
            return ("Please enter first name", false)
        } else {
            let result = str.containsOnlyLettersAndWhitespace()
            
            if !result {
                return ("No Digits allowed in first name", false)
            } else {
                return (nil, true)
            }
        }
    }
    
    // Validate Last Name
    static func lastName(str: String) -> (message: String?, result: Bool) {
        if str.count == 0 {
            return ("Please enter last name", false)
        } else {
            let result = str.containsOnlyLettersAndWhitespace()
            
            if !result {
                return ("No Digits allowed in last name", false)
            } else {
                return (nil, true)
            }
        }
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
    
    // Validate Quantity
    static func validateQuantity(val: String) -> (message: String?, result: Bool) {
        if let quantity = Int(val) {
            if quantity <= 0 || quantity > 7 {
                return ("Please enter quantity between 1 to 7", false)
            }
            return (message: nil, result: true)
        }
        return ("Please enter valid quantity", false)
    }
    
    // Validate Address
    static func address(str: String) -> (message: String?, result: Bool) {
        if str.count > 0 {
            return (nil, true)
        }
        return ("Please enter address", false)
    }
    
    // Validate LandMark
    static func landMark(str: String) -> (message: String?, result: Bool) {
        if str.count > 0 {
            return (nil, true)
        }
        return ("Please enter landMark", false)
    }
    
    // Validate PinCode
    static func pincode(str: String) -> (message: String?, result: Bool) {
        if str.count > 0, let _ = Int(str) {
            return (nil, true)
        }
        return ("Please enter valid pincode", false)
    }
    
    // Validate State
    static func state(str: String) -> (message: String?, result: Bool) {
        if str.count > 0 {
            return (nil, true)
        }
        return ("Please enter state", false)
    }
    
    // Validate City
    static func city(str: String) -> (message: String?, result: Bool) {
        if str.count > 0 {
            return (nil, true)
        }
        return ("Please enter city", false)
    }
    
    // Validate Last Name
    static func country(str: String) -> (message: String?, result: Bool) {
        if str.count > 0 {
            return (nil, true)
        }
        return ("Please enter country", false)
    }
}
