//
//  FetchAccountResponse.swift
//  NeoStore Project
//
//  Created by Neosoft on 14/03/22.
//

import Foundation

// MARK: - Welcome
struct FetchAccountResponse: Codable {
    let status: Int?
    let data: DataClass?

    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let userData: UserData?
    let productCategories: [ProductCategory]?
    let totalCarts, totalOrders: Int?

    enum CodingKeys: String, CodingKey {
        case userData = "user_data"
        case productCategories = "product_categories"
        case totalCarts = "total_carts"
        case totalOrders = "total_orders"
    }
}

// MARK: - ProductCategory
struct ProductCategory: Codable {
    let id: Int?
    let name: String?
    let iconImage: String?
    let created, modified: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case iconImage = "icon_image"
        case created, modified
    }
}

