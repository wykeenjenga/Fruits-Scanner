//
//  CartDiContainer.swift
//  iKhokhaFruits
//
//  Created by Wykee on 04/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

final class APCartDIContainer {
    
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeCartViewController() -> APCartViewController {
        return APCartViewController.create(with: viewModel())
    }
    
    private func viewModel() -> APCartViewModel{
        return DefaultAPCartViewModel()
    }
    
}
