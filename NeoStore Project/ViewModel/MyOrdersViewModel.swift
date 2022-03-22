//
//  MyOrdersViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import Foundation

enum FetchOrdersApiResult {
    case failure(msg: String?)
    case none
}

protocol MyOrdersViewType {
    var tableViewShouldReload: ReactiveListener<Bool> {get set}
    var fetchOrdersStatus: ReactiveListener<FetchOrdersApiResult> {get set}
    var orders: [OrderModel] {get set}
    
    func fetchOrders()
    func getNumOfRow() -> Int
    func getItemAtIndec(idx: Int) -> OrderModel
}

class MyOrdersViewModel: MyOrdersViewType {
    var orders = [OrderModel]()
    
    var fetchOrdersStatus: ReactiveListener<FetchOrdersApiResult> = ReactiveListener(.none)
    var tableViewShouldReload: ReactiveListener<Bool> = ReactiveListener(false)
    
    func fetchOrders() {
        if Reachability.isConnectedToNetwork() {
            OrderService.fetchOrders { res in
                switch res {
                case .success(value: let value):
                    // Check for success status
                    if let statusCode = value.status, statusCode == 200 {
                        if let allOrders = value.data {
                            self.orders.append(contentsOf: allOrders)
                            self.tableViewShouldReload.value = true
                        }
                    } else {
                        self.fetchOrdersStatus.value = .failure(msg: value.userMsg)
                    }
                case .failure(error: let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            self.fetchOrdersStatus.value = .failure(msg: "No Internet, please try again!")
        }
    }
    
    func getNumOfRow() -> Int {
        return orders.count
    }
    
    func getItemAtIndec(idx: Int) -> OrderModel {
        return orders[idx]
    }
}
