//
//  CartListViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import Foundation

enum FetchCartApiResult {
    case failure(msg: String?)
    case none
}


protocol CartListViewType {
    var tableViewShouldReload: ReactiveListener<Bool> {get set}
    var fetchCartStatus: ReactiveListener<FetchCartApiResult> {get set}
    
    var cartItems: [[String: Any]] {get set}
    var total: Int {get set}
    
    // Methods
    func fetchCart()
    func getNumOfRows() -> Int
    func getItemAndIndexPath(index: Int) -> [String: Any]
    func getTotalPrice() -> Int
    func deleteCart(productId: String)
    func editCart(productId: String, quantity: Int)
}

class CartListViewModel: CartListViewType {
    var total: Int = 0
    
    var cartItems = [[String : Any]]()
    
    var tableViewShouldReload: ReactiveListener<Bool> = ReactiveListener(false)
    var fetchCartStatus: ReactiveListener<FetchCartApiResult> = ReactiveListener(.none)
    
    func fetchCart() {
        CartService.fetchCart { res in
            switch res {
            case .success(value: let value):
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
                        if let statusCode = mainData["status"] as? Int {
                            if statusCode == 200, let tempData = mainData["data"] as? [[String: Any]] {
                                self.cartItems = tempData
                                if let cartTotal = mainData["total"] as? Int {
                                    self.total = cartTotal
                                }
                                self.tableViewShouldReload.value = true
                            } else {
                                // Show Error to User
                                print("There")
                                let userMsg = mainData["user_msg"] as? String
                                self.fetchCartStatus.value = .failure(msg: userMsg)
                            }
                        }
                    } catch let err {
                        print(err.localizedDescription)
                    }
                } else {
                    print("Some Another Error")
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }

    func getNumOfRows() -> Int {
        return cartItems.count
    }
    
    func getItemAndIndexPath(index: Int) -> [String : Any] {
        return cartItems[index]
    }

    
    func getTotalPrice() -> Int {
        return total
    }
    
    // MARK - Delete Cart Item
    func deleteCart(productId: String) {
        CartService.deleteCart(productId: productId) { res in
            switch res {
            case .success(value: let value):
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
                        if let statusCode = mainData["status"] as? Int {
                            if statusCode == 200 {
                                // Get Updated Cart
                                self.fetchCart()
                            } else {
                                // Show Error to User
                                let userMsg = mainData["user_msg"] as? String
                                self.fetchCartStatus.value = .failure(msg: userMsg)
                            }
                        }
                    } catch let err {
                        print(err.localizedDescription)
                    }
                } else {
                    print("Some Another Error")
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Edit Cart
    func editCart(productId: String, quantity: Int) {
        CartService.editCart(productId: productId, quantity: quantity) { res in
            switch res {
            case .success(value: let value):
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
                        if let statusCode = mainData["status"] as? Int {
                            if statusCode == 200 {
                                // Get Updated Cart
                                self.fetchCart()
                            } else {
                                // Show Error to User
                                let userMsg = mainData["user_msg"] as? String
                                self.fetchCartStatus.value = .failure(msg: userMsg)
                            }
                        }
                    } catch let err {
                        print(err.localizedDescription)
                    }
                } else {
                    print("Some Another Error")
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
}
