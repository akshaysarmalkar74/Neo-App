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
    
    var quantity: [Int] {get}
    var selectedRow: Int {get set}
    var cartItems: [CartListData] {get set}
    var total: Int {get set}
    
    // Methods
    func fetchCart()
    func getNumOfRows() -> Int
    func getItemAndIndexPath(index: Int) -> CartListData
    func getTotalPrice() -> Int
    func deleteCart(productId: String)
    func editCart(productId: String, quantity: Int)
    func numOfQuantityItems() -> Int
    func itemAtIndexInQuantity(idx: Int) -> Int
    func getSelectedRow() -> Int
}

class CartListViewModel: CartListViewType {
    
    var total: Int = 0
    let quantity = [1,2,3,4,5,6,7]
    var selectedRow = 0
    var cartItems = [CartListData]()
    
    var tableViewShouldReload: ReactiveListener<Bool> = ReactiveListener(false)
    var fetchCartStatus: ReactiveListener<FetchCartApiResult> = ReactiveListener(.none)
    
    func fetchCart() {
        if Reachability.isConnectedToNetwork() {
            CartService.fetchCart { res in
                switch res {
                case .success(value: let value):
                    if let statusCode = value.status, statusCode == 200 {
                        if let cartItems = value.data {
                            self.cartItems = cartItems
                            self.total = value.total ?? 0
                            self.tableViewShouldReload.value = true
                        } else {
                            self.fetchCartStatus.value = .failure(msg: value.userMsg)
                        }
                    } else {
                        self.fetchCartStatus.value = .failure(msg: value.userMsg)
                    }
                      
                case .failure(error: let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            self.fetchCartStatus.value = .failure(msg: "No Internet, please try again!")
        }
    }

    func getNumOfRows() -> Int {
        return cartItems.count
    }
    
    func getItemAndIndexPath(index: Int) -> CartListData {
        return cartItems[index]
    }

    
    func getTotalPrice() -> Int {
        return total
    }
    
    func numOfQuantityItems() -> Int {
        return quantity.count
    }
    
    func itemAtIndexInQuantity(idx: Int) -> Int {
        return quantity[idx]
    }
    
    func getSelectedRow() -> Int {
        return selectedRow
    }
    
    // MARK - Delete Cart Item
    func deleteCart(productId: String) {
        CartService.deleteCart(productId: productId) { res in
            switch res {
            case .success(value: let value):
            
                if let statusCode = value.status, statusCode == 200 {
                    // Get Updated Cart
                    self.fetchCart()
                } else {
                    self.fetchCartStatus.value = .failure(msg: value.userMsg)
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
                if let statusCode = value.status, statusCode == 200 {
                    // Get Updated Cart
                    self.fetchCart()
                } else {
                    self.fetchCartStatus.value = .failure(msg: value.userMsg)
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
}
