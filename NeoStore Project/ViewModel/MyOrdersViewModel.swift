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
        OrderService.fetchOrders { res in
            switch res {
            case .success(value: let value):
//                if let curData = value as? Data {
//                    do {
//                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
//                        if let statusCode = mainData["status"] as? Int {
//                            if statusCode == 200 {
//                                let tempData = mainData["data"] as? [[String: Any]] ?? [[String: Any]()]
//                                if tempData.count != 0 {
//                                    self.orders.append(contentsOf: tempData)
//                                    self.tableViewShouldReload.value = true
//                                }
//                            } else {
//                                // Show Error to User
//                                let userMsg = mainData["user_msg"] as? String
//                                self.fetchOrdersStatus.value = .failure(msg: userMsg)
//                            }
//                        }
//                    } catch let err {
//                        print(err.localizedDescription)
//                    }
//                } else {
//                    print("Some Another Error")
//                }
            
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
    }
    
    func getNumOfRow() -> Int {
        return orders.count
    }
    
    func getItemAtIndec(idx: Int) -> OrderModel {
        return orders[idx]
    }
}
