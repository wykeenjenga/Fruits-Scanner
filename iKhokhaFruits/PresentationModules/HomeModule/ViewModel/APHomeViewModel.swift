//
//  APHomeViewModel.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

///https://firebasestorage.googleapis.com/v0/b/the-busy-shop.appspot.com/o/apple.jpg?alt=media

import Foundation
import Firebase
import Alamofire
import AVFoundation

enum APHomeViewModelRoute {
    case initial
    case back
    case error
    case activity(loading: Bool)
}

protocol APHomeViewModelInput {
    func getProductDetails(barCode: String)
}

protocol APHomeViewModelOutput {
    var productsData: Dynamic<[APProductsModel]> { get set }
    var route: Dynamic<APHomeViewModelRoute> { get set }
    var cartCount: Dynamic<Int> {get set}
    var scannedBarcodes: Dynamic<[String]> {get set}
}

protocol APHomeViewModel: APHomeViewModelInput, APHomeViewModelOutput {
    
}

final class DefaultAPHomeViewModel: APHomeViewModel {
    
    var productsData: Dynamic<[APProductsModel]> = Dynamic([APProductsModel]())
    var route: Dynamic<APHomeViewModelRoute> = Dynamic(.initial)
    var cartCount: Dynamic<Int> = Dynamic(0)
    var scannedBarcodes: Dynamic<[String]> = Dynamic([])
    
    init() {
        
    }
}

extension APHomeViewModel{
    
    func getProductDetails(barCode: String) {
        self.route.value = .activity(loading: true)
        APAPIGateway.door().getProductDetail(barCode: barCode) { product, error in
            self.route.value = .activity(loading: false)
            if product != nil{
                self.productsData.value?.append(product)
            }else{
                ///shoe error message
            }
        }
        
    }

}
