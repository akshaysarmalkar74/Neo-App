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
}
