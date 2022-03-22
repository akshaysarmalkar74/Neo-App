//
//  ProductDetailViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 28/02/22.
//

import Foundation

enum ProductDetailApiResponse {
    case success
    case failure(err: String?)
    case none
}

protocol ProductDetailViewType {
    var fetchProductDetailStatus: ReactiveListener<ProductDetailApiResponse> {get set}
    var productId: String! {get}
    var curProduct: ProductDetail? {get}
    
    func fetchProductDetails()
    func getProduct() -> ProductDetail?
}

class ProductDetailViewModel: ProductDetailViewType {
    var productId: String!
    var curProduct: ProductDetail?
    
    init(productId: String) {
        self.productId = productId
    }
    
    var fetchProductDetailStatus: ReactiveListener<ProductDetailApiResponse> = ReactiveListener(.none)
    
    func fetchProductDetails() {
        if Reachability.isConnectedToNetwork() {
            ProductService.getProductDetail(productId: productId) { res in
                switch res {
                case .success(value: let value):
                    // Check for success status
                    if let statusCode = value.status, statusCode == 200 {
                        self.curProduct = value.data
                        self.fetchProductDetailStatus.value = .success
                    } else {
                        self.fetchProductDetailStatus.value = .failure(err: value.userMsg)
                    }
                case .failure(error: let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            self.fetchProductDetailStatus.value = .failure(err: "No Internet, please try again!")
        }
    }
    
    func getProduct() -> ProductDetail? {
        return curProduct
    }
    
}
