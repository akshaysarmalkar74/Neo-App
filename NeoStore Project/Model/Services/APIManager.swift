//
//  APIManager.swift
//  NeoStore Project
//
//  Created by Neosoft on 01/02/22.
//

import Foundation

class APIManager {
    static let sharedInstance = APIManager()
    
    func performRequest(serviceType: APIServices, completionHandler: @escaping (APIResponse<Any>) -> Void) {
        let session = URLSession.shared
        
        // Create URL, Method
        let url = URL(string: serviceType.path)!
        var request = URLRequest(url: url)
        request.httpMethod = serviceType.method
        // Fetch Parameters if any
        if let params = serviceType.parameters {
            if serviceType.method == "POST" {
                var requestBodyComponents = URLComponents()
                requestBodyComponents.queryItems = params.map({ (key, val) in
                    URLQueryItem(name: key, value: String(describing: val))
                })
                request.httpBody = requestBodyComponents.query?.data(using: .utf8)
                
            } else {
                var urlComponents = URLComponents(string: serviceType.path)
                urlComponents?.queryItems = params.map({ (key, val) in
                    URLQueryItem(name: key, value: String(describing: val))
                })
                request.url = urlComponents?.url
            }
        }
        
        request.allHTTPHeaderFields = serviceType.headers
        
        // Create Datatask
        
        let task = session.dataTask(with: request) { data, response, err in
            
            // Check error & data
            
            guard err == nil else {
                completionHandler(.failure(error: err!))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(error: err!))
                return
            }
            
            do {
                if (try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] != nil) {
                    completionHandler(.success(value: data))
                }
            } catch let err {
                completionHandler(.failure(error: err))
            }
        }
        task.resume()
    }
}
