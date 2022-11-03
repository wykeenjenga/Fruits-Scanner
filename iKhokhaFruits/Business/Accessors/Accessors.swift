//
//  Accessors.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/30/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation
import UIKit

struct Accessors {
    
    enum Storyboard: String {
        
        case main = "Main"
        
        func instantiate(with identifier: String) -> AnyObject {
            let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: identifier)
        }
    }
    
    struct AppDelegate {
        static let delegate: APAppDelegate = UIApplication.shared.delegate as! APAppDelegate
    }
}
