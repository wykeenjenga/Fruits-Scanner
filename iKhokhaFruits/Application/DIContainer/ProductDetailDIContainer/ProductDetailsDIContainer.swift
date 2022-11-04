//
//  ProductDetailsDIContainer.swift
//  iKhokhaFruits
//
//  Created by Wykee on 04/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

final class APProductDetailsDIContainer {
    
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makePDetailViewController() -> APProductDetailViewController {
        return APProductDetailViewController.create()
    }
    
}
