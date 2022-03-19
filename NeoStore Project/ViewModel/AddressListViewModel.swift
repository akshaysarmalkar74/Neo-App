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
    var allAddress: [String] {get set}
    var user: UserData? {get}
    var currentSelectedIdx: Int {get set}
    var placeOrderStatus: ReactiveListener<PlaceOrderApiResult> {get set}
    
    func placeOrder(address: String)
    func getTotalNumOfAddress() -> Int
    func getCurUser() -> UserData?
    func getCurSelectedIdx() -> Int
    func getAllAddress() -> [String]
    func getAddressAtRow(idx: Int) -> String
    func fetchAddress()
}

class AddressListViewModel: AddressListViewType {

    var allAddress = [String]()
    let user = UserDefaults.standard.getUserInstance()
    var currentSelectedIdx = 0
    var placeOrderStatus: ReactiveListener<PlaceOrderApiResult> = ReactiveListener(.none)
    
    init() { }
    
    // Fetch Address
    func fetchAddress() {
        allAddress = UserDefaults.standard.getAllAddress()
    }
    
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
    
    func getTotalNumOfAddress() -> Int {
        return allAddress.count
    }
    
    func getCurUser() -> UserData? {
        return user
    }
    
    func getCurSelectedIdx() -> Int {
        return currentSelectedIdx
    }
    
    func getAllAddress() -> [String] {
        return allAddress
    }
    
    func getAddressAtRow(idx: Int) -> String {
        return allAddress[idx]
    }
}
