//
//  APDIContainer.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/30/22.
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
}
