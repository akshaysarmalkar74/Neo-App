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
    func saveUser(value: [String : Any]) {
        do {
            // Encode and Save the data
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            set(encodedData, forKey: UserDefaultsKeys.user.rawValue)
        } catch let err {
            print("Error - \(err.localizedDescription)")
        }
    }
    
    //MARK: Get Entire User
    func getUser() -> [String: Any] {
        do {
            // Get Data and decode it
            let decoded  = object(forKey: UserDefaultsKeys.user.rawValue) as! Data
            let decodedUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [String: Any] ?? [String: Any]()
            return decodedUser
        } catch let err {
            print(err.localizedDescription)
            return [String: Any]()
        }
    }
}
