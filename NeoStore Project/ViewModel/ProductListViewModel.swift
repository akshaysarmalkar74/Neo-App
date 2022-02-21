//
//  ProductListViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 20/02/22.
//

import Foundation

enum FetchProductsApiResult {
    case success(data: [[String: Any]])
    case failure(msg: String?)
    case none
}

protocol ProductListViewType {
    var fetchProductsStatus: ReactiveListener<FetchProductsApiResult> {get set}
    
    func fetchProducts(categoryId: String, page: Int)
}

class ProductListViewModel: ProductListViewType {
    var fetchProductsStatus: ReactiveListener<FetchProductsApiResult> = ReactiveListener(.none)
    
    func fetchProducts(categoryId: String, page: Int = 1) {
        ProductService.getProducts(categoryId: categoryId, page: page) { res in
            switch res {
            case .success(value: let value):
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
//                        print(mainData)
                        if let statusCode = mainData["status"] as? Int {
                            if statusCode == 200 {
                                let tempData = mainData["data"] as? [[String: Any]] ?? [[String: Any]()]
                                self.fetchProductsStatus.value = .success(data: tempData)
                            } else {
                                // Show Error to User
                                let userMsg = mainData["user_msg"] as? String
                                self.fetchProductsStatus.value = .failure(msg: userMsg)
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
