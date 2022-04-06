//
//  ForgotScreenViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 09/02/22.
//

import Foundation

//enum ForgotApiStatus {
//    case success(msg: String?)
//    case failure(msg: String?)
//    case none
//}

protocol ForgotScreenViewType {
    var userForgotStatus: ReactiveListener<ForgotApiStatus> {get set}
    
    func forgotPassword(email: String)
}

class ForgotScreenViewModel: ForgotScreenViewType {
    
    var userForgotStatus: ReactiveListener<ForgotApiStatus> = ReactiveListener(.none)
    
    init() {}
    
    // MARK:- Methods
    func forgotPassword(email: String) {
    }
}
