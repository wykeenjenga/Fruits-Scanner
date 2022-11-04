//
//  APAPIGateway.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/29/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation
import Firebase

class APAPIGateway {
    
    private static let _door = APAPIGateway.init()
    private var firebase: APFirebase!
    
    @discardableResult class func door() -> APAPIGateway {
        return self._door
    }
    
    private init() {
        firebase = APFirebase()
        configureFirebase()
    }
    
    var currentToken: String? {
        get {
            return firebase.currentToken
        }
    }
    
    private func configureFirebase() {
        firebase.configure()
    }
    
    func signInUser(with email: String, password: String, completion: @escaping (Result<Bool,WrappedError>)->()) {

        firebase.signIn(with: email, password: password) { result in
            switch result {
            case .success(_):
                completion(result)
            case .failure(_):
                completion(result)
            }
        }
    }
    
    func signUpUser(with email: String, password: String, completion: @escaping (Result<Bool,WrappedError>)->()) {
        firebase.signUp(with: email, password: password) { (result) in
            completion(result)
        }
    }
    
    func getProductDetail(barCode: String, completion: @escaping (APProductsModel, Error?) -> Void){
        firebase.getProductDetail(barCode: barCode, completion: completion)
    }
}
