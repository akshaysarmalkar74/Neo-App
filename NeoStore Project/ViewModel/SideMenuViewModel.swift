//
//  SideMenuViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 18/03/22.
//

import Foundation

protocol SideMenuViewType {
    var tableViewShouldReload: ReactiveListener<Bool> {get set}
    var totalNumOfCarts: Int? {get set}
    var itemNames: [String] {get}
    var itemImages: [String] {get}
    var user: UserData! {get set}
    
    func getUser()
    func fetchAccount()
    func getTotalNumOfCarts() -> Int?
    func getTotalNumOfItems() -> Int
}

class SideMenuViewModel: SideMenuViewType {
    let itemNames = ["My Cart", "Tables", "Sofas", "Chair", "Cupboards", "My Account", "Store Locator", "My Orders", "Logout"]
    let itemImages = ["shoppingcart_icon", "tables_icon", "sofa_icon", "chair", "cupboard_icon", "username_icon", "storelocator_icon", "myorders_icon", "logout_icon"]
    var user: UserData!
    var tableViewShouldReload: ReactiveListener<Bool> = ReactiveListener(false)
    var totalNumOfCarts: Int?
    
    func getUser() {
        user = UserDefaults.standard.getUserInstance()
    }
    
    func fetchAccount() {
        UserService.getUserDetails { res in
            switch res {
            case .success(value: let value):
                if let totalCarts = value.data?.totalCarts, totalCarts != 0 {
                    self.totalNumOfCarts = totalCarts
                    self.tableViewShouldReload.value = true
                }
            case .failure(error: _):
                self.tableViewShouldReload.value = false
            }
        }
    }
    
    func getTotalNumOfCarts() -> Int? {
        return totalNumOfCarts
    }
    
    func getTotalNumOfItems() -> Int {
        return itemNames.count
    }
}
