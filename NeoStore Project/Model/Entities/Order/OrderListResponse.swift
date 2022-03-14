//
//  OrderListModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 13/03/22.
//

import Foundation


struct OrderListResponse: Codable {
    let status: Int?
    let data: [OrderModel]?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data, message
        case userMsg = "user_msg"
    }
}

// MARK: - Order
struct OrderModel: Codable {
    let id: Int?
    let cost: Double?
    let created: String?
}
