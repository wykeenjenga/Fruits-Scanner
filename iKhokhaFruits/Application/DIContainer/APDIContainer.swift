//
//  APDIContainer.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/28/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

final class APDIContainer {
    // MARK: - Network
    ///Network to be init
}

extension APDIContainer {
    // MARK: DIContainers of scenes
    
    /// Creates Hardwall DIContainer.
    func makeHardWallDIContainer() -> APHardwallDIContainer {
        let dependencies = APHardwallDIContainer.Dependencies()
        return APHardwallDIContainer(dependencies: dependencies)
    }
    
    ///Create homeView DIContainer
    func makeHomeDIContainer() -> APHomeDIContainer {
        let dependencies = APHomeDIContainer.Dependencies()
        return APHomeDIContainer(dependencies: dependencies)
    }
    
    ///Create Cart DIContainer
    func makeCartDIContainer() -> APCartDIContainer {
        let dependencies = APCartDIContainer.Dependencies()
        return APCartDIContainer(dependencies: dependencies)
    }
    
    ///Create PRODUCT DETAILS DIContainer
    func makePDetailsDIContainer() -> APProductDetailsDIContainer {
        let dependencies = APProductDetailsDIContainer.Dependencies()
        return APProductDetailsDIContainer(dependencies: dependencies)
    }
}
