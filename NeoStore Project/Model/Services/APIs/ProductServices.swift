//
//  ProductServices.swift
//  NeoStore Project
//
//  Created by Neosoft on 20/02/22.
//

import Foundation

class ProductService {
    // Get Products
    
    static func getProducts(categoryId: String, page: Int, completionHandler: @escaping(APIResponse<Any>) -> Void) {
        let params: AnyDict = ["product_category_id": categoryId, "page": page]
        
        // Perform Request
        APIManager.sharedInstance.performRequest(serviceType: .getProducts(parameters: params)) { response in
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
