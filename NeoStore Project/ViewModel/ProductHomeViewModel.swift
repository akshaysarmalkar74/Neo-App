//
//  ProductHomeViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 08/03/22.
//

import Foundation

enum FetchAccountDetail {
    case success
    case failure
    case none
}

protocol ProductHomeViewType {
    var fetchAccountDetailStatus: ReactiveListener<FetchAccountDetail> {get set}
    var totalCartProducts: Int {get set}
    
//    func fetchAccountDetails()
    func getTotalCartProduct() -> Int
}

class ProductHomeViewModel: ProductHomeViewType {
    
    var totalCartProducts: Int = 0
    
    var fetchAccountDetailStatus: ReactiveListener<FetchAccountDetail> = ReactiveListener(.none)
    
//    func fetchAccountDetails() {
//        UserService.getUserDetails { res in
//            switch res {
//            case .success(value: let value):
//                if let curData = value as? Data {
//                    do {
//                        let mainData = try JSONSerialization.jsonObject(with: curData, options: .mutableContainers) as! [String: Any]
//
//                        if let statusCode = mainData["status"] as? Int {
//                            if statusCode == 200 {
//                                let tempData = mainData["data"] as? [String: Any] ?? [String: Any]()
//                                let user = tempData["user_data"] as? [String: Any] ?? [String: Any]()
//
//                                // Update User Defaults
//                                UserDefaults.standard.saveUser(value: user)
//
//                                // Update Cart Number
//                                self.totalCartProducts = tempData["total_carts"] as? Int ?? 0
//                                self.fetchAccountDetailStatus.value = .success
//                            } else {
//                                self.fetchAccountDetailStatus.value = .failure
//                            }
//                        }
//                    } catch let err {
//                        print(err.localizedDescription)
//                    }
//                }
//            case .failure(error: let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func getTotalCartProduct() -> Int {
        return totalCartProducts
    }

    
}
