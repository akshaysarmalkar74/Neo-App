//
//  CartListResponseModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 14/03/22.
//

import Foundation

// MARK: - Welcome
struct CartListResponseModel: Codable {
    let status: Int?
    let data: [CartListData]?
    let count, total: Int?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data, count, total, message
        case userMsg = "user_msg"
    }
}

// MARK: - Datum
struct CartListData: Codable {
    let id, productID, quantity: Int?
    let product: Product?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case quantity, product
    }
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let name: String?
    let cost: Int?
    let productCategory: String?
    let productImages: String?
    let subTotal: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, cost
        case productCategory = "product_category"
        case productImages = "product_images"
        case subTotal = "sub_total"
    }
}
