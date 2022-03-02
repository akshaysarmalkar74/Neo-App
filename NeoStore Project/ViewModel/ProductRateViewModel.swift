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
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
                        print(mainData)
                        if let statusCode = mainData["status"] as? Int {
                            let userMsg = mainData["user_msg"] as? String
                            if statusCode == 200 {
                                self.productRateDetailStatus.value = .success(msg: userMsg)
                            } else {
                                self.productRateDetailStatus.value = .failure(err: userMsg)
                            }
                        }
                    } catch let err {
                        print(err.localizedDescription)
                    }
                } else {
                    print("Some Another Error")
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
