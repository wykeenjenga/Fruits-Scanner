//
//  APHardWallViewModel.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

enum APHardWallViewModelRoute {
    case initial
    case back
    case error
    case activity(loading: Bool)
}

protocol APHardWallViewModelInput {
    func performLogin(with completion: @escaping (Result<Bool,WrappedError>)->())
}

protocol APHardWallViewModelOutput {
    var route: Dynamic<APHardWallViewModelRoute> { get set }
    var emailText: Dynamic<String> {get set}
    var passwordText: Dynamic<String> {get set}
}

protocol APHardWallViewModel: APHardWallViewModelInput, APHardWallViewModelOutput {
    
}

final class DefaultAPHardWallViewModel: APHardWallViewModel {
    
    var emailText: Dynamic<String> = Dynamic<String>("")
    var passwordText: Dynamic<String> = Dynamic<String>("")
    var route: Dynamic<APHardWallViewModelRoute> = Dynamic(.initial)
    
    init() {
        
    }
}

extension APHardWallViewModel{
    
    func performLogin(with completion: @escaping (Result<Bool,WrappedError>)->()) {
        let apiDoor = APAPIGateway.door()
        apiDoor.signInUser(with: emailText.value ?? "", password: passwordText.value ?? "") { result in
            completion(result)
        }
    }
    
}


