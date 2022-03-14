//
//  SetProductRatingResponse.swift
//  NeoStore Project
//
//  Created by Neosoft on 14/03/22.
//

import Foundation

struct SetProductRatingResponse: Codable {
    let status: Int?
    let data: SetProductDetail?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data, message
        case userMsg = "user_msg"
    }
}

// MARK: - DataClass
struct SetProductDetail: Codable {
    let id, productCategoryID: Int?
    let name, producer, dataDescription: String?
    let cost, viewCount: Int?
    let rating: Double?
    let created, modified: String?
    let productImages: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productCategoryID = "product_category_id"
        case name, producer
        case dataDescription = "description"
        case cost, rating
        case viewCount = "view_count"
        case created, modified
        case productImages = "product_images"
    }
}
