//
//  APProductsModel.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation
import Mapper

struct APProductsModel: Codable {
    enum CodingKeys: String, CodingKey {
        case image = "image"
        case price = "price"
        case description = "description"
    }
    
    var image: String?
    var price: String?
    var description: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        price = try container.decodeIfPresent(String.self, forKey: .price)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}

extension APProductsModel: APMappable {
    init(map: Mapper) {
        price = map.optionalFrom("price")
        image = map.optionalFrom("image")
        description = map.optionalFrom("description")
    }
}

struct APProductsModelData: Codable {
    enum CodingKeys: String, CodingKey {
        case products
    }
    
    var products: [APProductsModel]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        products = try container.decodeIfPresent([APProductsModel].self, forKey: .products)
    }
    
    init() {
        products = []
    }
    
}

extension APProductsModelData: APMappable {
    init(map: Mapper) {
        products = map.optionalFrom("products")
    }
}

