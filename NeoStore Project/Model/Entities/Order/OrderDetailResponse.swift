//
//  OrderDetailResponse.swift
//  NeoStore Project
//
//  Created by Neosoft on 13/03/22.
//

import Foundation

// MARK: - Welcome
struct OrderDetailResponse: Codable {
    let status: Int?
    let data: OrderDetailData?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data, message
        case userMsg = "user_msg"
    }
}

// MARK: - DataClass
struct OrderDetailData: Codable {
    let id: Int?
    let cost: Double?
    let created: String?
    let orderDetails: [SpecificOrderDetail]?

    enum CodingKeys: String, CodingKey {
        case id, cost, created
        case orderDetails = "order_details"
    }
}

// MARK: - OrderDetail
struct SpecificOrderDetail: Codable {
    let id, orderID, productID, quantity: Int?
    let total: Int?
    let prodName, prodCatName: String?
    let prodImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case productID = "product_id"
        case quantity, total
        case prodName = "prod_name"
        case prodCatName = "prod_cat_name"
        case prodImage = "prod_image"
    }
}
