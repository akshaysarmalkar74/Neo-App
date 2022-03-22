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
        if Reachability.isConnectedToNetwork() {
            OrderService.fetchOrderWith(id: orderId) { res in
                switch res {
                case .success(value: let value):
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
        } else {
            self.orderDetailStatus.value = .failure(msg: "No Internet, please try again!")
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
