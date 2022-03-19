//
//  ProductRateViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 01/03/22.
//

import Foundation

enum ProductRateApiResponse {
    case success(msg: String?)
    case failure(err: String?)
    case none
}

protocol ProductRateViewType {
    var productId: Int! {get set}
    var productImgStrUrl: String! {get set}
    var productName: String! {get set}
    var rating: Int {get set}
    var productRateDetailStatus: ReactiveListener<ProductRateApiResponse> {get set}
    
    func rateProduct()
    func getProductName() -> String
    func getProductImgStr() -> String
    func getRating() -> Int
}

class ProductRateViewModel: ProductRateViewType {
    var productId: Int!
    var productImgStrUrl: String!
    var productName: String!
    var rating: Int = 3
    
    init(productId: Int, productImgStrUrl: String, productName: String) {
        self.productId = productId
        self.productImgStrUrl = productImgStrUrl
        self.productName = productName
    }
    
    var productRateDetailStatus: ReactiveListener<ProductRateApiResponse> = ReactiveListener(.none)
    
    func rateProduct() {
        ProductService.setProductRating(productId: String(productId), rating: rating) { res in
            switch res {
            case .success(value: let value):
                // Check for success status
                if let statusCode = value.status, statusCode == 200 {
                    self.productRateDetailStatus.value = .success(msg: value.userMsg)
                } else {
                    self.productRateDetailStatus.value = .failure(err: value.userMsg)
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getProductName() -> String {
        return productName
    }
    
    func getProductImgStr() -> String {
        return productImgStrUrl
    }
    
    func getRating() -> Int {
        return self.rating
    }
    
}
