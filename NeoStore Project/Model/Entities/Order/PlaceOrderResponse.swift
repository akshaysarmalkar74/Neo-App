//
//  PlaceOrderResponse.swift
//  NeoStore Project
//
//  Created by Neosoft on 13/03/22.
//

import Foundation

struct PlaceOrderResponse: Codable {
    let status: Int?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, message
        case userMsg = "user_msg"
    }
}
