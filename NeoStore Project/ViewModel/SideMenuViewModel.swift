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
    
    func fetchAccount()
    func getTotalNumOfCarts() -> Int?
}

class SideMenuViewModel: SideMenuViewType {
    var tableViewShouldReload: ReactiveListener<Bool> = ReactiveListener(false)
    var totalNumOfCarts: Int?
    
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
}
