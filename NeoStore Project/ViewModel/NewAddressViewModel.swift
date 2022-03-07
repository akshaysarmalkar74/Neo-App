//
//  NewAddressViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 06/03/22.
//

import Foundation

enum SaveAddressStatus {
    case success
    case failure(msg: String?)
    case none
}

protocol NewAddressViewType {
    var saveAddressStatus: ReactiveListener<SaveAddressStatus> {get set}
    
    func addNewAddress(address: String, landmark: String, city: String, zipCode: String, state: String, country: String)
}

class NewAddressViewModel: NewAddressViewType {
    var saveAddressStatus: ReactiveListener<SaveAddressStatus> = ReactiveListener(.none)
    
    func addNewAddress(address: String, landmark: String, city: String, zipCode: String, state: String, country: String) {
        let addressResult = Validator.address(str: address)
        let landMarkResult = Validator.landMark(str: landmark)
        let cityResult = Validator.city(str: city)
        let zipCodeResult = Validator.pincode(str: zipCode)
        let stateResult = Validator.state(str: state)
        let countryResult = Validator.country(str: country)
        
        // Check for result
        if addressResult.result && landMarkResult.result && cityResult.result && zipCodeResult.result && stateResult.result && countryResult.result {
            // Save the address
            let curAddress = "\(address), Near \(landmark), \(city), \(state), \(country), Pincode - \(zipCode)"
            UserDefaults.standard.addNewAddress(address: curAddress)
            self.saveAddressStatus.value = .success
        } else if !addressResult.result {
            self.saveAddressStatus.value = .failure(msg: addressResult.message)
        } else if !landMarkResult.result {
            self.saveAddressStatus.value = .failure(msg: landMarkResult.message)
        } else if !cityResult.result {
            self.saveAddressStatus.value = .failure(msg: cityResult.message)
        } else if !zipCodeResult.result {
            self.saveAddressStatus.value = .failure(msg: zipCodeResult.message)
        } else if !stateResult.result {
            self.saveAddressStatus.value = .failure(msg: stateResult.message)
        } else {
            self.saveAddressStatus.value = .failure(msg: countryResult.message)
        }
    }
    
    
}
