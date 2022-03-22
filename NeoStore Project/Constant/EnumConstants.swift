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
    case noFirstName = "Please enter first name"
    case invalidFirstName = "No Characters/Digits allowed in first name"
    case noLastName = "Please enter last name"
    case invalidLastName = "No Characters/Digits allowed in last name"
    case noPhone = "Please enter phone number"
    case invalidPhone = "Phone number should be 10 digits exactly"
    case noBirthDate = "Please select birth date"
    case invalidQty = "Please enter valid quantity"
    case termsNotChecked = "Please accept the terms"
    case noAddress = "Please enter address"
    case noLandmark = "Please enter landmark"
    case noCity = "Please enter city"
    case noState = "Please enter state"
    case noZipCode = "Please enter zipcode"
    case noCountry = "Please enter country"
}


enum ValidationResult {
    case success
    case failure(msg: ValidationMessages)
}
