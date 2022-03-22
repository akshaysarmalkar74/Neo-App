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
    var address: String {get set}
    var landMark: String {get set}
    var city: String {get set}
    var zipCode: String {get set}
    var state: String {get set}
    var country: String {get set}
    var saveAddressStatus: ReactiveListener<SaveAddressStatus> {get set}
    
    func addNewAddress()
    func saveTextFromTextField(text: String?, tag: Int)
}

class NewAddressViewModel: NewAddressViewType {
    var address: String = ""
    var landMark: String = ""
    var city: String = ""
    var zipCode: String = ""
    var state: String = ""
    var country: String = ""
    
    var saveAddressStatus: ReactiveListener<SaveAddressStatus> = ReactiveListener(.none)
    
    func addNewAddress() {
        
        // Get Validation Results
        let validationResult = validateAddressFields()
        
        switch validationResult {
        case .success:
            break
        case .failure(msg: let msg):
            self.saveAddressStatus.value = .failure(msg: msg.rawValue)
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            let curAddress = "\(address), Near \(landMark), \(city), \(state), \(country), Pincode - \(zipCode)"
            UserDefaults.standard.addNewAddress(address: curAddress)
            self.saveAddressStatus.value = .success
        } else {
            self.saveAddressStatus.value = .failure(msg: "No Internet, please try again!")
        }
    }
    
    // Extract Text from Text Fields
    func saveTextFromTextField(text: String?, tag: Int) {
        switch tag {
        case 1:
            address = text ?? ""
        case 2:
            landMark = text ?? ""
        case 3:
            city = text ?? ""
        case 4:
            state = text ?? ""
        case 5:
            zipCode = text ?? ""
        case 6:
            country = text ?? ""
        default:
            break
        }
    }
    
    // Valide Fields
    func validateAddressFields() -> ValidationResult {
        if address.isEmpty {
            return .failure(msg: .noAddress)
        }
        
        if landMark.isEmpty {
            return .failure(msg: .noLandmark)
        }
        
        if city.isEmpty {
            return .failure(msg: .noCity)
        }
        
        if state.isEmpty {
            return .failure(msg: .noState)
        }
        
        if zipCode.isEmpty {
            return .failure(msg: .noZipCode)
        }
        
        if country.isEmpty {
            return .failure(msg: .noCountry)
        }
        
        return .success
    }
    
}
