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
    var orderItems: [[String: Any]] {get set}
    var total: Int? {get set}
    
    var orderDetailStatus: ReactiveListener<OrderDetailStatus> {get set}
    var tableViewShouldReload: ReactiveListener<Bool> {get set}
    
    func getOrderWith(id: Int)
    func getNumOfRows() -> Int
    func getItemAndIndexPath(index: Int) -> [String: Any]
    func getTotalPrice() -> Int
}

class OrderDetailViewModel: OrderDetailViewType {
    var total: Int?
    var orderItems = [[String : Any]]()
    
    var orderDetailStatus: ReactiveListener<OrderDetailStatus> = ReactiveListener(.none)
    var tableViewShouldReload: ReactiveListener<Bool> = ReactiveListener(false)
    
    func getOrderWith(id: Int) {
        OrderService.fetchOrderWith(id: id) { res in
            switch res {
            case .success(value: let value):
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
                        if let statusCode = mainData["status"] as? Int {
                            if statusCode == 200 {
                                let tempData = mainData["data"] as? [String: Any] ?? [String: Any]()
                                let productsData = tempData["order_details"] as? [[String: Any]] ?? [[String: Any]]()
                                
                                self.total = tempData["total"] as? Int
                                self.orderItems.append(contentsOf: productsData)
                                self.tableViewShouldReload.value = true
                            } else {
                                // Show Error to User
                                let userMsg = mainData["user_msg"] as? String
                                self.orderDetailStatus.value = .failure(msg: userMsg)
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
        return orderItems.count
    }
    
    func getItemAndIndexPath(index: Int) -> [String : Any] {
        return orderItems[index]
    }
    
    func getTotalPrice() -> Int {
        return total ?? 0
    }
}