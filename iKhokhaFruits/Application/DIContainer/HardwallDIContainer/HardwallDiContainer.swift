//
//  HardwallDiContainer.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation


final class APHardwallDIContainer {
    
    struct Dependencies {
        //let apiDataTransferService: DataTransfer
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHardWallViewController() -> APHardWallViewController {
        return APHardWallViewController.create(with: viewModel())
    }
    
    private func viewModel() -> APHardWallViewModel{
        return DefaultAPHardWallViewModel()
    }
    
}
