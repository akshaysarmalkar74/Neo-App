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
    var quantity: Int {get set}
    var productBuyDetailStatus: ReactiveListener<ProductBuyApiResponse> {get set}
    
    func getProductName() -> String
    func getProductImgStr() -> String
    func buyProduct()
    func saveTextFromTextField(text: String?, tag: Int)
}

class ProductBuyViewModel: ProductBuyViewType {
    var productId: Int!
    var productImgStrUrl: String!
    var productName: String!
    var quantity: Int = 0
    
    var productBuyDetailStatus: ReactiveListener<ProductBuyApiResponse> = ReactiveListener(.none)
    
    init(productId: Int, productImgStrUrl: String, productName: String) {
        self.productId = productId
        self.productImgStrUrl = productImgStrUrl
        self.productName = productName
    }
    
    func buyProduct() {
        
        // Get Validations
        let validationResult = validateBuyFields()
        
        switch validationResult {
        case .success:
            break
        case .failure(msg: let msg):
            self.productBuyDetailStatus.value = .failure(err: msg.rawValue)
            return
        }
        
        if Reachability.isConnectedToNetwork() {
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
        } else {
            self.productBuyDetailStatus.value = .failure(err: "No Internet, please try again!")
        }
    }
    
    func getProductName() -> String {
        return productName
    }
    
    func getProductImgStr() -> String {
        return productImgStrUrl
    }
    
    // Extract Text from Text Fields
    func saveTextFromTextField(text: String?, tag: Int) {
        if tag == 1, let actutalQty = Int(text ?? "") {
            quantity = actutalQty
        }
    }
    
    // Validate Fields
    func validateBuyFields() -> ValidationResult {
        let validQty = 1...7
        if validQty.contains(quantity) {
            return .success
        } else {
            return .failure(msg: .invalidQty)
        }
    }
    
}
