//
//  UserDefaultsExtension.swift
//  NeoStore Project
//
//  Created by Neosoft on 08/02/22.
//

import Foundation

extension UserDefaults{

    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }

    // MARK:- Retrieve Login Status
    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }

    //MARK: Save User Data
    func setUserToken(value: String){
        set(value, forKey: UserDefaultsKeys.userToken.rawValue)
    }

    //MARK: Retrieve User Data
    func getUserToken() -> String? {
        return string(forKey: UserDefaultsKeys.userToken.rawValue)
    }
    
    //MARK: Save Entire User Data
//    func saveUser(value: [String : Any]) {
//        do {
//            // Encode and Save the data
//            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
//            set(encodedData, forKey: UserDefaultsKeys.user.rawValue)
//        } catch let err {
//            print("Error - \(err.localizedDescription)")
//        }
//    }
    
    //MARK: Get Entire User
//    func getUser() -> [String: Any] {
//        do {
//            // Get Data and decode it
//            let decoded  = object(forKey: UserDefaultsKeys.user.rawValue) as! Data
//            let decodedUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [String: Any] ?? [String: Any]()
//            return decodedUser
//        } catch let err {
//            print(err.localizedDescription)
//            return [String: Any]()
//        }
//    }
    
    //MARK:- Set Profile Update
    func setUpdatedProfile(value: Bool){
        set(value, forKey: UserDefaultsKeys.isProfileUpdated.rawValue)
    }
    
    //MARK:- Get Profile Updated Status
    func isProfileUpdated()-> Bool {
        return bool(forKey: UserDefaultsKeys.isProfileUpdated.rawValue)
    }
    
    // MARK:- Add New Address
    func addNewAddress(address: String) {
        var allAddress = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.address.rawValue) ?? [String]()
        allAddress.append(address)
        UserDefaults.standard.set(allAddress, forKey: UserDefaultsKeys.address.rawValue)
    }
    
    // MARK:- Get All Address
    func getAllAddress() -> [String] {
        let allAddress = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.address.rawValue) ?? [String]()
        return allAddress
    }
    
    // MARK:- Save User Instance
    func saveUserInstance(user: UserData) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaultsKeys.user.rawValue)
        }
    }
    
    // MARK: Get User Instance
    func getUserInstance() -> UserData? {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: UserDefaultsKeys.user.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: savedPerson) {
                return loadedPerson
            } else {
                return nil
            }
        }
        return nil
    }
}