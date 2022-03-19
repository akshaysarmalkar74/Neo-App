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
    var productRateDetailStatus: ReactiveListener<ProductRateApiResponse> {get set}
    
    func rateProduct(productId: String, rating: Int)
}

class ProductRateViewModel: ProductRateViewType {
    var productRateDetailStatus: ReactiveListener<ProductRateApiResponse> = ReactiveListener(.none)
    
    func rateProduct(productId: String, rating: Int) {
        ProductService.setProductRating(productId: productId, rating: rating) { res in
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
    
    
}
