//
//  ChangePasswordResponse.swift
//  NeoStore Project
//
//  Created by Neosoft on 14/03/22.
//

import Foundation

struct UpdateResponse: Codable {
    let status: Int?
    let data: [Bool]?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data, message
        case userMsg = "user_msg"
    }
}
