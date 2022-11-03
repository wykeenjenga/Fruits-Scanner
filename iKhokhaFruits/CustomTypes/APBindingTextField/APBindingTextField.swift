//
//  APBindingTextField.swift
//  iKhokhaFruits
//
//  Created by Wykee on 28/10/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//


import Foundation
import UIKit

class APBindingTextField : UITextField, BindsWithType {
    
    typealias T = String//Associated type value. Can be removed too. -AV
    private var textChanged :(String) -> () = { _ in }

    func bind(callback :@escaping (String) -> ()) {
        self.textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField :UITextField) {
        self.textChanged(textField.text!)
    }
}

