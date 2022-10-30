//
//  APAPIEndPoints.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/30/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

struct APAPIEndPoints {
    struct Requests {
        static func getProductsEndPoint() -> URL {
            return URL(string: APAppConfigurations.apiProductsURL)!
        }
        
        static func getProductsImagesEndPoint() -> URL {
            return URL(string: APAppConfigurations.apiProductsImagesURL)!
        }
    }
}
