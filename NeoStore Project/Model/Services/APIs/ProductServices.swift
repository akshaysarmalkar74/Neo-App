//
//  ProductServices.swift
//  NeoStore Project
//
//  Created by Neosoft on 20/02/22.
//

import Foundation

class ProductService {
    
    // Get Products
    static func getProducts(categoryId: String, page: Int, completionHandler: @escaping(APIResponse<ProductListResponse>) -> Void) {
        let params: AnyDict = ["product_category_id": categoryId, "page": page]
        
        // Perform Request
        APIManager.sharedInstance.performRequest(serviceType: .getProducts(parameters: params)) { response in
            switch response {
            case .success(value: let value):
                // Decode the data
                do {
                    if let extractedData = value as? Data {
                        let productListRes = try JSONDecoder().decode(ProductListResponse.self, from: extractedData)
                        completionHandler(.success(value: productListRes))
                    } else {
                        print("Some Error while converting to data")
                    }
                } catch {
                    print("Error - \(error.localizedDescription)")
                }
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
    
    // Get Product Details
    static func getProductDetail(productId: String, completionHandler: @escaping(APIResponse<ProductDetailResponse>) -> Void) {
        let params: AnyDict = ["product_id": productId]
        
        // Perform Request
        APIManager.sharedInstance.performRequest(serviceType: .getProductDetails(parameters: params)) { response in
            switch response {
            case .success(value: let value):
                // Decode the data
                do {
                    if let extractedData = value as? Data {
                        let productDetailRes = try JSONDecoder().decode(ProductDetailResponse.self, from: extractedData)
                        completionHandler(.success(value: productDetailRes))
                    } else {
                        print("Some Error while converting to data")
                    }
                } catch {
                    print("Error - \(error.localizedDescription)")
                }
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
    
    // Set Product Rating
    static func setProductRating(productId: String, rating: Int, completionHandler: @escaping(APIResponse<SetProductRatingResponse>) -> Void) {
        
        // Params
        let params: AnyDict = ["product_id": productId, "rating": rating]
        
        // Perform Request
        APIManager.sharedInstance.performRequest(serviceType: .setProductRating(parameters: params)) { response in
            switch response {
            case .success(value: let value):
                // Decode the data
                do {
                    if let extractedData = value as? Data {
                        let productDetailRes = try JSONDecoder().decode(SetProductRatingResponse.self, from: extractedData)
                        completionHandler(.success(value: productDetailRes))
                    } else {
                        print("Some Error while converting to data")
                    }
                } catch {
                    print("Error - \(error.localizedDescription)")
                }
            case .failure(error: let error):
                print(error.localizedDescription)
                completionHandler(.failure(error: error))
            }
        }
    }
}
