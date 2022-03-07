//
//  NewAddressViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 06/03/22.
//

import Foundation

protocol NewAddressViewType {
    func addNewAddress(address: String)
}

class NewAddressViewModel: NewAddressViewType {
    func addNewAddress(address: String) {
        print("Hello")
    }
    
    
}
