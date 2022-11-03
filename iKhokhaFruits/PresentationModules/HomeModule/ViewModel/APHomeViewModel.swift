//
//  APHomeViewModel.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

enum APHomeViewModelRoute {
    case initial
    case back
    case error
    case activity(loading: Bool)
}

protocol APHomeViewModelInput {
    func triggerGetAllProducts()
}

protocol APHomeViewModelOutput {
    //var eventsData: Dynamic<AGLiveEventsModelData> { get set }
    var route: Dynamic<APHomeViewModelRoute> { get set }
}

protocol APHomeViewModel: APHomeViewModelInput, APHomeViewModelOutput {
    
}

final class DefaultAPHomeViewModel: APHomeViewModel {
    
//    var eventsData: Dynamic<AGLiveEventsModelData> = Dynamic(AGLiveEventsModelData())
    var route: Dynamic<APHomeViewModelRoute> = Dynamic(.initial)
    
    init() {
        
    }
}

extension APHomeViewModel{
    
    func triggerGetAllProducts() {
//        route.value = .activity(loading: true)
//        AGAPIGateway.door().getLiveEvents { (events, error) in
//            if error != nil{
//                self.route.value = .error
//            }else{
//                var liveEvents = AGLiveEventsModelData()
//                liveEvents.liveEvents = events
//                self.eventsData.value = liveEvents
//
//                self.route.value = .activity(loading: false)
//            }
//        }
    }
}
