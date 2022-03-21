//
//  StringExtension.swift
//  NeoStore Project
//
//  Created by Neosoft on 14/03/22.
//

import Foundation

extension String {
    func containsOnlyLettersAndWhitespace() -> Bool {
        let allowed = CharacterSet.letters.union(.whitespaces)
        return unicodeScalars.allSatisfy(allowed.contains)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailPred.evaluate(with: self)
        return result
    }
    
    func isValidPhone() -> Bool {
        return self.count == 10
    }
}
