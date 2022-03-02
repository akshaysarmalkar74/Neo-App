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
