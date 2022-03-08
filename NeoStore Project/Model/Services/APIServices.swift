//
//  APIServices.swift
//  NeoStore Project
//
//  Created by Neosoft on 01/02/22.
//

import Foundation

typealias AnyDict = [String: Any]
typealias StringDict = [String: String]

let DEV_ROOT_POINT = "http://staging.php-dev.in:8844/trainingapp/api"
let PROD_ROOT_POINT = "https://someApi.com"

// Default Headers

let contentKey = "Content-Type"
let contentValue = "application/x-www-form-urlencoded"

enum NetworkingEnviroment: String {
    case developement
    case production
}

// Set Enviroment

var networkingEnviroment: NetworkingEnviroment {
    return .developement
}

// Set Base URL

var baseURL: String {
    switch networkingEnviroment {
    case .developement:
        return DEV_ROOT_POINT
    case .production:
        return PROD_ROOT_POINT
    }
}

// API Service

enum APIServices {
    public struct SubDomain {
        static let usersDomain = "/users"
        static let productsDomain = "/products"
    }
    
    // MARK:- User Methods
    case userLogin(parameters: AnyDict)
    case userRegister(parameters: AnyDict)
    case forgotPassword(parameters: AnyDict)
    case changePassword(parameters: AnyDict, headers: StringDict)
    case updateUserProfile(parameters: AnyDict, headers: StringDict)
    case getUser(headers: StringDict)
    
    // MARK:- Product Methods
    case getProducts(parameters: AnyDict)
    case getProductDetails(parameters: AnyDict)
    case setProductRating(parameters: AnyDict)
    
    // MARK:- Cart Methods
    case addToCart(parameters: AnyDict, headers: StringDict)
    case editCart(parameters: AnyDict, headers: StringDict)
    case deleteCart(parameters: AnyDict, headers: StringDict)
    case getCart(headers: StringDict)
    
    // MARK:- Order Methods
    case placeOrder(parameters: AnyDict, headers: StringDict)
    case getOrders(headers: StringDict)
    case getOrderDetail(parameters: AnyDict, headers: StringDict)
}

extension APIServices {
    var path: String {
        let userDomain: String = SubDomain.usersDomain
        let productDomian: String = SubDomain.productsDomain
        
        var servicePath = ""
        
        switch self {
        case .userLogin:
            servicePath = userDomain + "/login"
        case .userRegister:
            servicePath = userDomain + "/register"
        case .forgotPassword:
            servicePath = userDomain + "/forgot"
        case .changePassword:
            servicePath = userDomain + "/change"
        case .updateUserProfile:
            servicePath = userDomain + "/update"
        case .getUser:
            servicePath = userDomain + "/getUserData"
        case .getProducts:
            servicePath = productDomian + "/getList"
        case .getProductDetails:
            servicePath = productDomian + "/getDetail"
        case .setProductRating:
            servicePath = productDomian + "/setRating"
        case .addToCart:
            servicePath = "/addToCart"
        case .editCart:
            servicePath = "/editCart"
        case .deleteCart:
            servicePath = "/deleteCart"
        case .getCart:
            servicePath = "/cart"
        case .placeOrder:
            servicePath = "/order"
        case .getOrders:
            servicePath = "/orderList"
        case .getOrderDetail:
            servicePath = "/orderDetail"
        }
        
        return baseURL + servicePath
    }
    
    // Headers
    
    var headers: StringDict? {
        switch self {
        case .changePassword(parameters: _, headers: var headers),
             .updateUserProfile(parameters: _, headers: var headers),
             .getUser(headers: var headers),
             .getCart(headers: var headers),
             .getOrders(headers: var headers),
             .getOrderDetail(parameters: _, headers: var headers),
             .addToCart(parameters: _, headers: var headers),
             .deleteCart(parameters: _, headers: var headers),
             .editCart(parameters: _, headers: var headers),
             .placeOrder(parameters: _, headers: var headers):
            headers[contentKey] = contentValue
            return headers
        default:
            var headersDict = StringDict()
            headersDict[contentKey] = contentValue
            return headersDict
        }
    }
    
    // Params
    
    var parameters: AnyDict? {
        switch self {
        case .userLogin(parameters: let parameters),
             .userRegister(parameters: let parameters),
             .forgotPassword(parameters: let parameters),
             .changePassword(parameters: let parameters, headers: _),
             .updateUserProfile(parameters: let parameters, headers: _),
             .getProducts(parameters: let parameters),
             .getProductDetails(parameters: let parameters),
             .setProductRating(parameters: let parameters),
             .addToCart(parameters: let parameters, headers: _),
             .editCart(parameters: let parameters, headers: _),
             .deleteCart(parameters: let parameters, headers: _),
             .placeOrder(parameters: let parameters, headers: _),
             .getOrderDetail(parameters: let parameters, headers: _):
             
            return parameters
            
        default:
            return nil
        }
    }
    
    
    // Method
    
    var method: String {
        switch self {
        case .getUser,
             .getProducts,
             .getProductDetails,
             .getCart,
             .getOrders,
             .getOrderDetail:
            return "GET"
        
        default:
            return "POST"
        }
    }
}
