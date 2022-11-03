//
//  APProtocols.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/30/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation
import Mapper

protocol BindsWithType {
    associatedtype T
    func bind(callback :@escaping (T) -> ())
}

protocol Binds {
    func bind(callback :@escaping () -> ())
}
protocol AddCountryCodeDelegate{
    func setCode(code: String)
}
protocol IndicatesActivity {
    func showActivityIndicator()
    func hideActivityIndicator()
    var activityIndictor: UIActivityIndicatorView? { get set }
}

protocol ContentValidator {
    func bindForFailure(callback :@escaping (APError) -> ())
}

public protocol APMappable: Mappable, Reflectable {
}

protocol ServerSyncable {
    func syncRemotely(completion: ((Bool, Error?) -> Void)?)
}

protocol HapticFeedback {
    func generateFeedback()
}

extension HapticFeedback where Self: UIControl {
    func generateFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

protocol Shake {
     func shake()
}

extension Shake where Self: UIView {
    
    func shake() {
        self.layer.removeAnimation(forKey: "shake")
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = 10
        animation.duration = 0.1/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: -2.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: 2.0, y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
}


protocol AddKeyboardSuppressingAccessory {
    func addKeyboardSuppressingAccessory()
}


public protocol Reflectable {
    var nonNilChildren: Dictionary<String,Any> { get }
}

extension Reflectable {
    
    var nonNilChildren: [String: Any] {
        
        let keys = Mirror(reflecting: self).children.compactMap { $0.label }
        let values = Mirror(reflecting: self).children.compactMap { unwrap($0.value) as AnyObject }
        
        var dict = Dictionary(uniqueKeysWithValues: zip(keys, values))
        
        let keysToRemove = dict.keys.filter{ dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        return dict
    }
    
    func unwrap<T>(_ any: T) -> Any {
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .optional, let first = mirror.children.first else {
            return any
        }
        return unwrap(first.value)
    }
}
