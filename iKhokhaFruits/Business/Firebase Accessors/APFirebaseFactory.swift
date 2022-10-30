//
//  APFirebaseFactory.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/29/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth
import FirebaseStorage

struct APFirebaseFactory {
    
    //MARK: Collections
    private static let firestoreUser = "User"
    private static let firestoreUserFriends = "Friends"

    //MARK: Accessor Properties
    private static let _firAuth = Auth.auth()
    private static let _firestore = Firestore.firestore()
    private static let _storage = Storage.storage()
    
    //MARK: Accessors
    static func auth() -> Auth {
        return _firAuth
    }
    
    static func db() -> Firestore {
        return _firestore
    }
    
    static func storage() -> Storage {
        return _storage
    }
    
    static func storageRef() -> StorageReference {
        return _storage.reference()
    }
    
}
