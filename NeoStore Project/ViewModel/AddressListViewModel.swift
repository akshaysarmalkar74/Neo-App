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
                // Check for success status
                if let statusCode = value.status, statusCode == 200 {
                    self.placeOrderStatus.value = .success(msg: value.userMsg)
                } else {
                    self.placeOrderStatus.value = .failure(msg: value.userMsg)
                }
            
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
}
