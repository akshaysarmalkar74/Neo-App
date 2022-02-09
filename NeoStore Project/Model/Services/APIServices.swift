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
    case changePassword(parameters: AnyDict)
    case updatePassword(parameters: AnyDict)
    case getUser
    
    // MARK:- Product Methods
    case getProducts(parameters: AnyDict)
    case getProductDetails(parameters: AnyDict)
    case setProductRating(parameters: AnyDict)
    
    // MARK:- Cart Methods
    case addToCart(parameters: AnyDict)
    case editCart(parameters: AnyDict)
    case deleteCart(parameters: AnyDict)
    case getCart
    
    // MARK:- Order Methods
    case placeOrder(parameters: AnyDict)
    case getOrders
    case getOrderDetail(parameters: AnyDict)
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
        case .updatePassword:
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
        var headersDict = StringDict()
        headersDict[contentKey] = contentValue
        return headersDict
    }
    
    // Params
    
    var parameters: AnyDict? {
        switch self {
        case .userLogin(parameters: let parameters),
             .userRegister(parameters: let parameters),
             .forgotPassword(parameters: let parameters),
             .changePassword(parameters: let parameters),
             .updatePassword(parameters: let parameters),
             .getProducts(parameters: let parameters),
             .getProductDetails(parameters: let parameters),
             .setProductRating(parameters: let parameters),
             .addToCart(parameters: let parameters),
             .editCart(parameters: let parameters),
             .deleteCart(parameters: let parameters),
             .placeOrder(parameters: let parameters),
             .getOrderDetail(parameters: let parameters):
             
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
