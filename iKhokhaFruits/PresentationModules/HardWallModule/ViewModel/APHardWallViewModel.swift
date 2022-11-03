//
//  APHardWallViewModel.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

protocol APHardWallViewModelOutput{
    
}

struct APHardWallViewModel: BrokenRuleEnforcer, APHardWallViewModelOutput {
    
    var brokenRules: [BrokenRule]
    
    var emailText: Dynamic<String> = Dynamic<String>("")
    var passwordText: Dynamic<String> = Dynamic<String>("")
    
    
    func performLogin(with completion: @escaping (Result<Bool,WrappedError>)->()) {
        let apiDoor = APAPIGateway.door()
        apiDoor.signInUser(with: emailText.value ?? "", password: passwordText.value ?? "") { result in
            completion(result)
        }
    }
    
    func performSignUp(with completion: @escaping (Result<Bool,WrappedError>)->()) {
        let apiDoor = APAPIGateway.door()
    }

    
    func performResetPassword(with completion: @escaping (Bool,Error?)->()) {
    }
    
    var isValid :Bool {
          mutating get {
              return self.brokenRules.count == 0 ? true : false
          }
      }

}
