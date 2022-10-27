//
//  APError.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/27/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

struct APError : Error {
    var localizedTitle: String?
    var localizedDescription: String?
}
