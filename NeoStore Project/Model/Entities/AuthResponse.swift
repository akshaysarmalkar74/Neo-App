//
//  AuthResponse.swift
//  NeoStore Project
//
//  Created by Neosoft on 07/02/22.
//

import Foundation

struct AuthResponse: Decodable {
    let status: Int
    let data: UserData
    let message: String
    let userMsg: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
        case userMsg = "user_msg"
    }
}

struct UserData: Decodable {
    let id: Int
    let roleId: Int
    let firstName: String
    let lastName: String
    let email: String
    let username: String
    let gender: String
    let phoneNo: Int
    let isActive: Bool
//    let created: Date
//    let modified: Date
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case roleId = "role_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case username = "username"
        case gender = "gender"
        case phoneNo = "phone_no"
        case isActive = "is_active"
//        case created = "created"
//        case modified = "modified"
        case accessToken = "access_token"
    }
}
