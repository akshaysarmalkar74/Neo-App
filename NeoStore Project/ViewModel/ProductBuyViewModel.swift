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
    var productBuyDetailStatus: ReactiveListener<ProductBuyApiResponse> {get set}
    
    func buyProduct(productId: String, quantity: Int)
}

class ProductBuyViewModel: ProductBuyViewType {
    var productBuyDetailStatus: ReactiveListener<ProductBuyApiResponse> = ReactiveListener(.none)
    
    func buyProduct(productId: String, quantity: Int) {
        CartService.addToCart(productId: productId, quantity: quantity) { res in
            switch res {
            case .success(value: let value):
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
                        if let statusCode = mainData["status"] as? Int {
                            let userMsg = mainData["user_msg"] as? String
                            if statusCode == 200 {
                                self.productBuyDetailStatus.value = .success(msg: userMsg)
                            } else {
                                self.productBuyDetailStatus.value = .failure(err: userMsg)
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
