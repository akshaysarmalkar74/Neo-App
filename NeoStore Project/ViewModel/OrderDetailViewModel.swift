//
//  OrderDetailViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 22/02/22.
//

import Foundation

enum OrderDetailStatus {
    case failure(msg: String?)
    case none
}

protocol OrderDetailViewType {
    var orderItems: [SpecificOrderDetail] {get set}
    var total: Double? {get set}
    var orderId: Int! {get set}
    
    var orderDetailStatus: ReactiveListener<OrderDetailStatus> {get set}
    var tableViewShouldReload: ReactiveListener<Bool> {get set}
    
    func getOrderWith()
    func getNumOfRows() -> Int
    func getItemAndIndexPath(index: Int) -> SpecificOrderDetail
    func getTotalPrice() -> Double
    func getPageTitle() -> String
}

class OrderDetailViewModel: OrderDetailViewType {
    var orderId: Int!
    var total: Double?
    var orderItems = [SpecificOrderDetail]()
    
    var orderDetailStatus: ReactiveListener<OrderDetailStatus> = ReactiveListener(.none)
    var tableViewShouldReload: ReactiveListener<Bool> = ReactiveListener(false)
    
    init(orderId: Int) {
        self.orderId = orderId
    }
    
    func getOrderWith() {
        OrderService.fetchOrderWith(id: orderId) { res in
            switch res {
            case .success(value: let value):
//                if let curData = value as? Data {
//                    do {
//                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
//                        if let statusCode = mainData["status"] as? Int {
//                            if statusCode == 200 {
//                                let tempData = mainData["data"] as? [String: Any] ?? [String: Any]()
//                                let productsData = tempData["order_details"] as? [[String: Any]] ?? [[String: Any]]()
//
//                                self.total = tempData["cost"] as? Int
//                                self.orderItems.append(contentsOf: productsData)
//                                self.tableViewShouldReload.value = true
//                            } else {
//                                // Show Error to User
//                                let userMsg = mainData["user_msg"] as? String
//                                self.orderDetailStatus.value = .failure(msg: userMsg)
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
                    if let order = value.data {
                        self.total = order.cost
                        self.orderItems.append(contentsOf: order.orderDetails ?? [SpecificOrderDetail]())
                        self.tableViewShouldReload.value = true
                    }
                } else {
                    self.orderDetailStatus.value = .failure(msg: value.userMsg)
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getNumOfRows() -> Int {
        return orderItems.count
    }
    
    func getItemAndIndexPath(index: Int) -> SpecificOrderDetail {
        return orderItems[index]
    }
    
    func getTotalPrice() -> Double {
        return total ?? 0
    }
    
    func getPageTitle() -> String {
        return String(orderId)
    }
}
