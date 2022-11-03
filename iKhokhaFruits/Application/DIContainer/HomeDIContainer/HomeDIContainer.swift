//
//  HomeDIContainer.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

final class APHomeDIContainer {
    
    struct Dependencies {
        //let apiDataTransferService: DataTransfer
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHomeViewController() -> APHomeViewController {
        return APHomeViewController.create(with: viewModel())
    }
    
    private func viewModel() -> APHomeViewModel{
        return DefaultAPHomeViewModel()
    }
    
}
