//
//  OrderService.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import Foundation

class OrderService {
    
    // Fetch All Orders
    static func fetchOrders(completionHandler: @escaping(APIResponse<OrderListResponse>) -> Void) {
        
        // Get New Headers (Access Token)
        let accessToken = UserDefaults.standard.getUserToken() ?? ""
        
        APIManager.sharedInstance.performRequest(serviceType: .getOrders(headers: ["access_token": accessToken])) { response in
            switch response {
            case .success(value: let value):
                // Decode the data
                do {
                    if let extractedData = value as? Data {
                        let orderRes = try JSONDecoder().decode(OrderListResponse.self, from: extractedData)
                        completionHandler(.success(value: orderRes))
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
    
    // Get Specific Order
    
    static func fetchOrderWith(id: Int, completionHandler: @escaping(APIResponse<OrderDetailResponse>) -> Void) {
        
        // Params
        let params: [String: Any] = ["order_id": id]
        
        // Get New Headers (Access Token)
        let accessToken = UserDefaults.standard.getUserToken() ?? ""
        
        APIManager.sharedInstance.performRequest(serviceType: .getOrderDetail(parameters: params, headers: ["access_token": accessToken])) { response in
            switch response {
            case .success(value: let value):
                // Decode the data
                do {
                    if let extractedData = value as? Data {
                        let orderRes = try JSONDecoder().decode(OrderDetailResponse.self, from: extractedData)
                        completionHandler(.success(value: orderRes))
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
    
    // Place order
    static func placeOrder(address: String, completionHandler: @escaping(APIResponse<PlaceOrderResponse>) -> Void) {
        
        // Params
        let params: [String: Any] = ["address": address]
        
        // Headers
        let accessToken = UserDefaults.standard.getUserToken() ?? ""
        
        APIManager.sharedInstance.performRequest(serviceType: .placeOrder(parameters: params, headers: ["access_token": accessToken])) { response in
            switch response {
            case .success(value: let value):
                // Decode the data
                do {
                    if let extractedData = value as? Data {
                        let placeOrderRes = try JSONDecoder().decode(PlaceOrderResponse.self, from: extractedData)
                        completionHandler(.success(value: placeOrderRes))
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
