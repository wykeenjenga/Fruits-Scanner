//
//  AGDynamicType.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/27/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation

class Dynamic<T> {
    
    var value: T? {
        didSet {
            bind?(value)
        }
    }
    
    var bind: ((T?)->())?
    
    init(_ _value: T) {
        value = _value
    }
    
    func unbind() {
        bind = nil
    }
}
