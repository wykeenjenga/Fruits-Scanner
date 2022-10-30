//
//  APExtension+UITableViewCell.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/30/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//


import Foundation
import UIKit
import CoreData

extension UITableViewCell {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension NSManagedObject {
    public static var identifier: String {
        return String(describing: self)
    }
}
