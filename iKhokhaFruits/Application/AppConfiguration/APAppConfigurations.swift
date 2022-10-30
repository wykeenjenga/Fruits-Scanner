//
//  APAppConfigurations.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/30/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation


struct APAppConfigurations {
    static var apiProductsURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "APIProductsUrl") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    static var apiProductsImagesURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "APIProductsImageUrl") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
