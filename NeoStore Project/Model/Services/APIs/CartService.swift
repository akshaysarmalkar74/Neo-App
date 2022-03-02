//
//  CartService.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import Foundation

class CartService {
    
    // Fetch Cart Function
    static func fetchCart(completionHandler: @escaping(APIResponse<Any>) -> Void) {
        
        // Get New Headers (Access Token)
        let accessToken = UserDefaults.standard.getUserToken() ?? ""
        
        APIManager.sharedInstance.performRequest(serviceType: .getCart(headers: ["access_token": accessToken])) { response in
            switch response {
            case .success(value: let value):
                completionHandler(.success(value: value))
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
    
    // Add To Cart
    static func addToCart(productId: String, quantity: Int, completionHandler: @escaping(APIResponse<Any>) -> Void) {
        
        // Get New Headers (Access Token)
        let accessToken = UserDefaults.standard.getUserToken() ?? ""
        
        // Construct Params
        let params: AnyDict = ["product_id": productId, "quantity": quantity]
        
        APIManager.sharedInstance.performRequest(serviceType: .addToCart(parameters: params, headers: ["access_token": accessToken])) { response in
            switch response {
            case .success(value: let value):
                completionHandler(.success(value: value))
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
}
