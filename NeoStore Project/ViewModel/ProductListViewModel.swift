//
//  ProductListViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 20/02/22.
//

import Foundation

enum FetchProductsApiResult {
    case success
    case failure(msg: String?)
    case none
}

protocol ProductListViewType {
    var fetchProductsStatus: ReactiveListener<FetchProductsApiResult> {get set}
    var tableViewShouldReload: ReactiveListener<Bool> {get set}
    var products: [SpecificProduct] {get set}
    
    func fetchProducts(categoryId: String, page: Int)
    func getNumOfRows() -> Int
    func getItemAndIndexPath(index: Int) -> SpecificProduct
}

class ProductListViewModel: ProductListViewType {
    var products = [SpecificProduct]()
    
    var tableViewShouldReload: ReactiveListener<Bool> = ReactiveListener(false)
    var fetchProductsStatus: ReactiveListener<FetchProductsApiResult> = ReactiveListener(.none)
    
    func fetchProducts(categoryId: String, page: Int = 1) {
        ProductService.getProducts(categoryId: categoryId, page: page) { res in
            switch res {
            case .success(value: let value):
//                if let curData = value as? Data {
//                    do {
//                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
//                        if let statusCode = mainData["status"] as? Int {
//                            if statusCode == 200 {
//                                let tempData = mainData["data"] as? [[String: Any]] ?? [[String: Any]()]
//                                self.products.append(contentsOf: tempData)
//                                self.fetchProductsStatus.value = .success
//                                self.tableViewShouldReload.value = true
//                            } else {
//                                // Show Error to User
//                                let userMsg = mainData["user_msg"] as? String
//                                self.fetchProductsStatus.value = .failure(msg: userMsg)
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
                    if let allProducts = value.data {
                        self.products.append(contentsOf: allProducts)
                        self.fetchProductsStatus.value = .success
                        self.tableViewShouldReload.value = true
                    }
                } else {
                    self.fetchProductsStatus.value = .failure(msg: value.userMsg)
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getNumOfRows() -> Int {
        return products.count
    }
    
    func getItemAndIndexPath(index: Int) -> SpecificProduct {
        return products[index]
    }
}
