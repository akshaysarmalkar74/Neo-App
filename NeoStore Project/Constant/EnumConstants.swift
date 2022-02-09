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
}
