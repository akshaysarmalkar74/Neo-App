//
//  RegisterResponse.swift
//  NeoStore Project
//
//  Created by Neosoft on 13/03/22.
//

import Foundation

struct RegisterResponse: Codable {
    let status: Int?
    let data: RegisterData?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data, message
        case userMsg = "user_msg"
    }
}

// MARK: - DataClass
struct RegisterData: Codable {
    let id, roleID: Int?
    let firstName, lastName, email, username: String?
    let profilePic, countryID, gender: String?
    let phoneNo: Int?
    let dob: String?
    let isActive: Bool?
    let created, modified: Date?
    let accessToken: String?

    enum CodingKeys: String, CodingKey {
        case id
        case roleID = "role_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email, username
        case profilePic = "profile_pic"
        case countryID = "country_id"
        case gender
        case phoneNo = "phone_no"
        case dob
        case isActive = "is_active"
        case created, modified
        case accessToken = "access_token"
    }
}
