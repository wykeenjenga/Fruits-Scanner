//
//  APFirebase.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/29/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import FirebaseAuth
import FirebaseFirestore

typealias FIRUser = Firebase.User
var fRCount = 0

struct WrappedError: Error {
    var error: Error?
}

class APFirebase {
    
    private var verificationID: String?
    var currentToken: String?
    
    func configure() {
        FirebaseApp.configure()
    }
    
    func signUp(with email: String, password: String, completion: @escaping (Result<Bool,WrappedError>)->()) {
        APFirebaseFactory.auth().createUser(withEmail: email, password: password) { (result, error) in
            if result != nil {
                completion(.success(true))
            } else {
                completion(.failure(WrappedError(error: error)))
            }
        }
    }
    
    func signIn(with email: String, password: String, completion: @escaping (Result<Bool,WrappedError>)->()) {
        APFirebaseFactory.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(.failure(WrappedError(error: error)))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func getProductDetail(barCode: String, completion: @escaping (APProductsModel, Error?) -> Void){
        let url = APAPIEndPoints.Requests.getProductsEndPoint()

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error == nil{
                do {
                    if let data = data {
                        if let json = String(data: data, encoding: .utf8) {
                            let result = try JSONDecoder().decode([String: APProductsModel].self, from: data)
                            DispatchQueue.main.async {
                                for (key, value) in result {
                                    if key == barCode{
                                        print("DATA IS>>>>>",key, value)
                                        completion(value, nil)
                                    }
                                }
                            }
                            }
                    }
                } catch {
                    print(error)
                }
            }else {
                print(error ?? "fucking error occured")
                return
            }
        }
        task.resume()
    }
    
}
