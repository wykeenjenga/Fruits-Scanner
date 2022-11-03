//
//  APBRokenRules.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

enum BrokenRule: String {
    case passwordLength = "Oh snap, atleast 6 characters needed!"
    case emailLength = "Oops, you'll need to enter your email!"
    case emailMalformed = "That does not look like a valid email!"
    case wrongPassword = "The password that you've entered does not match with the one we have!"
    case wrongPasswordMaxLimit = "You may wish to reset your password, using the link below!"
    
    static func check(for rules:[BrokenRule], with string: String) -> [BrokenRule] {
        var brokenRules:[BrokenRule] = []
        for rule in rules {
            switch rule {
            case .passwordLength:
                if string.count < 6 {
                    brokenRules.append(.passwordLength)
                }
                break
            case .emailLength:
                if string.count < 1 {
                    brokenRules.append(.emailLength)
                }
                break
            case .emailMalformed:
                if isValidEmail(testStr: string) == false {
                    brokenRules.append(.emailMalformed)
                }
                break
            case .wrongPassword:
                break
            case .wrongPasswordMaxLimit:
                break
            }
        }
        return brokenRules
    }
    
    static private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

protocol BrokenRuleEnforcer {
    var brokenRules :[BrokenRule] { get set }
    var isValid :Bool { mutating get }
}
