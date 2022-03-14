//
//  ProductDetailViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 28/02/22.
//

import Foundation

enum ProductDetailApiResponse {
    case success(product: ProductDetail?)
    case failure(err: String?)
    case none
}

protocol ProductDetailViewType {
    var fetchProductDetailStatus: ReactiveListener<ProductDetailApiResponse> {get set}
    
    func fetchProductDetails(productId: String)
}

class ProductDetailViewModel: ProductDetailViewType {
    var fetchProductDetailStatus: ReactiveListener<ProductDetailApiResponse> = ReactiveListener(.none)
    
    func fetchProductDetails(productId: String) {
        ProductService.getProductDetail(productId: productId) { res in
            switch res {
            case .success(value: let value):
//                if let curData = value as? Data {
//                    do {
//                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
//                        if let statusCode = mainData["status"] as? Int {
//                            if statusCode == 200 {
//                                let productData = mainData["data"] as? [String: Any] ?? [String: Any]()
//                                self.fetchProductDetailStatus.value = .success(product: productData)
//                            } else {
//                                // Show Error to User
//                                let userMsg = mainData["user_msg"] as? String
//                                self.fetchProductDetailStatus.value = .failure(err: userMsg)
//                            }
//                        }
//                    } catch let err {
//                        print(err.localizedDescription)
//                    }
//                } else {
//                    print("Some Another Error")
//                }
            
                // Check for success status
                if let statusCode = value.status, statusCode == 200 {
                    self.fetchProductDetailStatus.value = .success(product: value.data)
                } else {
                    self.fetchProductDetailStatus.value = .failure(err: value.userMsg)
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
