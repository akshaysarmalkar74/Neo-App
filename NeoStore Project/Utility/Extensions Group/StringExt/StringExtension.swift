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
}
