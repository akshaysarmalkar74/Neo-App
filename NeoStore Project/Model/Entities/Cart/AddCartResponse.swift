//
//  AddCartResponse.swift
//  NeoStore Project
//
//  Created by Neosoft on 14/03/22.
//

import Foundation

struct AddCartResponse: Codable {
    let status: Int?
    let data: Bool?
    let totalCarts: Int?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data
        case totalCarts = "total_carts"
        case message
        case userMsg = "user_msg"
    }
}
