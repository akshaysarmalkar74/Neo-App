//
//  AddressListViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 07/03/22.
//

import Foundation

enum PlaceOrderApiResult {
    case success(msg: String?)
    case failure(msg: String?)
    case none
}

protocol AddressListViewType {
    var placeOrderStatus: ReactiveListener<PlaceOrderApiResult> {get set}
    func placeOrder(address: String)
}

class AddressListViewModel: AddressListViewType {
    var placeOrderStatus: ReactiveListener<PlaceOrderApiResult> = ReactiveListener(.none)
    
    // Place Order
    func placeOrder(address: String) {
        OrderService.placeOrder(address: address) { res in
            switch res {
            case .success(value: let value):
                if let curData = value as? Data {
                    do {
                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String : Any]
                        if let statusCode = mainData["status"] as? Int {
                            let userMsg = mainData["user_msg"] as? String
                            if statusCode == 200 {
                                // Show Success Alert
                                self.placeOrderStatus.value = .success(msg: userMsg)
                            } else {
                                // Show Error to User
                                self.placeOrderStatus.value = .failure(msg: userMsg)
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
