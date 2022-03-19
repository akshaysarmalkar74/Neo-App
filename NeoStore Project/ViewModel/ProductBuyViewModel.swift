//
//  ProductBuyViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 01/03/22.
//

import Foundation

enum ProductBuyApiResponse {
    case success(msg: String?)
    case failure(err: String?)
    case none
}

protocol ProductBuyViewType {
    var productId: Int! {get set}
    var productImgStrUrl: String! {get set}
    var productName: String! {get set}
    var productBuyDetailStatus: ReactiveListener<ProductBuyApiResponse> {get set}
    
    func getProductName() -> String
    func getProductImgStr() -> String
    func buyProduct(quantity: Int)
}

class ProductBuyViewModel: ProductBuyViewType {
    var productId: Int!
    var productImgStrUrl: String!
    var productName: String!
    
    var productBuyDetailStatus: ReactiveListener<ProductBuyApiResponse> = ReactiveListener(.none)
    
    init(productId: Int, productImgStrUrl: String, productName: String) {
        self.productId = productId
        self.productImgStrUrl = productImgStrUrl
        self.productName = productName
    }
    
    func buyProduct(quantity: Int) {
        CartService.addToCart(productId: String(productId), quantity: quantity) { res in
            switch res {
            case .success(value: let value):
            // Check for success status
            if let statusCode = value.status, statusCode == 200 {
                self.productBuyDetailStatus.value = .success(msg: value.userMsg)
            } else {
                self.productBuyDetailStatus.value = .failure(err: value.userMsg)
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
    
}
