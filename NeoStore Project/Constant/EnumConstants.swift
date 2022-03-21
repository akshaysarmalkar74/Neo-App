//
//  EnumConstants.swift
//  NeoStore Project
//
//  Created by Neosoft on 01/02/22.
//

import Foundation

enum APIResponse<T> {
    case success(value: T)
    case failure(error: Error)
}

enum UserDefaultsKeys : String {
    case isLoggedIn
    case userToken
    case user
    case isProfileUpdated
    case address
}

enum SideMenuControllerNames {
    case MyCart
    case Tables
    case Sofas
    case Chair
    case Cupboard
    case MyAccount
    case StoreLocator
    case MyOrders
    case Logout
}

enum ProductCategoryId: String {
    case Tables = "1"
    case Chair = "2"
    case Sofas = "3"
    case Cupboards = "4"
}

enum ValidationMessages: String {
    case noEmail = "Please enter email"
    case invalidEmail = "Please enter a valid email"
    case noPasswordLogin = "Please enter password"
    case noCurrentPassword = "Please enter current password"
    case noNewPassword = "Please enter new password"
    case shortNewPassword = "Password should be more than 6 characters"
    case invalidConfirmPassword = "Passwords does not match"
}


enum ValidationResult {
    case success
    case failure(msg: ValidationMessages)
}
