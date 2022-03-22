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
    var categoryId: String! {get}
    var page: Int {get set}
    var isPaginating: Bool {get set}
    var shouldPaginate: Bool {get set}
    
    func fetchProducts()
    func getNumOfRows() -> Int
    func getItemAndIndexPath(index: Int) -> SpecificProduct
    func getShouldPaginate() -> Bool
    func getIsPaginating() -> Bool
}

class ProductListViewModel: ProductListViewType {
    var page: Int = 1
    var isPaginating: Bool = false
    var shouldPaginate: Bool = false
    
    var products = [SpecificProduct]()
    var categoryId: String!
    
    init(categoryId: String) {
        self.categoryId = categoryId
    }
    
    var tableViewShouldReload: ReactiveListener<Bool> = ReactiveListener(false)
    var fetchProductsStatus: ReactiveListener<FetchProductsApiResult> = ReactiveListener(.none)
    
    func fetchProducts() {
        if Reachability.isConnectedToNetwork() {
            ProductService.getProducts(categoryId: categoryId, page: page) { res in
                switch res {
                case .success(value: let value):
                    // Check for success status
                    if let statusCode = value.status, statusCode == 200 {
                        if let allProducts = value.data {
                            // Update should Paginate
                            if allProducts.count % 10 == 0 {
                                self.shouldPaginate = true
                            } else {
                                self.shouldPaginate = false
                            }
                            self.isPaginating = false
                            
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
        } else {
            self.fetchProductsStatus.value = .failure(msg: "No Internet, please try again!")
        }
    }
    
    func getNumOfRows() -> Int {
        return products.count
    }
    
    func getItemAndIndexPath(index: Int) -> SpecificProduct {
        return products[index]
    }
    
    func getShouldPaginate() -> Bool {
        return shouldPaginate
    }
    
    func getIsPaginating() -> Bool {
        return isPaginating
    }
}
