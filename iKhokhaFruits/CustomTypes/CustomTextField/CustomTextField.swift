//
//  CustomTextField.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation
import UIKit

class APAnimatablePlaceholderTextField: APBindingTextField, ContentValidator, HapticFeedback, Shake {
    
    @IBInspectable var placeHolderTextForAnimation: String? {
        didSet {
            placeholder = ""
            DispatchQueue.main.async {
                self.prepAnimatablePlaceholder()
            }
        }
    }
    
    @IBInspectable private var placeHolderTextForAnimationColor: UIColor? {
        didSet {
            if let placeholder = animatablePlaceholderLabel {
                placeholder.textColor = placeHolderTextForAnimationColor
            }
        }
    }
    
    @IBInspectable private var showsALine: Bool = false {
        didSet {
            if showsALine {
                showALine()
            }
        }
    }
    
    @IBInspectable private var showsValidationError: Bool = false {
        didSet {
            if showsValidationError {
                showTheValidationError()
            }
        }
    }
    
    @IBInspectable private var showsRevealButton: Bool = false {
        didSet {
            if showsRevealButton {
                showTheRevealButton()
            }
        }
    }
    
    @IBInspectable private var exitWhenReturnTapped: Bool = false {
        didSet {
            if exitWhenReturnTapped {
                self.addTarget(self, action: #selector(returnKeyPressed), for: .editingDidEndOnExit)
            }
        }
    }
    
    var rulesToBeValidated: [BrokenRule]?
    
    fileprivate var lineBelowTheTextField: UIView?
    
    private var validateChange :(APError) -> () = { _ in }
    private var isErrorStateEnabled: Bool = false
    private var validationErrorLabel: UILabel?
    private var animatablePlaceholderLabel: UILabel?
    
    @objc func returnKeyPressed(_ textField :UITextField) {
        self.endEditing(true)
    }
    
    override func bind(callback: @escaping (String) -> ()) {
        super.bind(callback: callback)
    }
    
     func setText(text: String?) {
        self.text = text
        DispatchQueue.main.async {
            self.textFieldDidChange(self)
        }
    }
    
    func bindForFailure(callback: @escaping (APError) -> ()) {
        self.validateChange = callback
    }
    
    func doneButtonAction() {
        self.endEditing(true)
    }
    
    func isValid() -> Bool {
        if let rules = rulesToBeValidated {
            let rulesBroken = BrokenRule.check(for: rules, with: self.text ?? "")
            if rulesBroken.count > 0 {
                isErrorStateEnabled = true
                prepareForErrorState()
                generateFeedback()
//                shake()
                var error = APError()
                error.localizedDescription = rulesBroken[0].rawValue
                validationErrorLabel?.text = rulesBroken[0].rawValue
                self.validateChange(error)
                return false
            }
        }
        resetAppearance()
        return true
    }
    
    private func prepAnimatablePlaceholder() {
        if animatablePlaceholderLabel == nil {
            animatablePlaceholderLabel = UILabel(frame: CGRect(x: 5, y: 0, width: self.bounds.width, height: self.bounds.height))
            animatablePlaceholderLabel?.font = self.font
            animatablePlaceholderLabel?.textColor = placeHolderTextForAnimationColor ?? self.textColor?.withAlphaComponent(0.75)
            self.addSubview(animatablePlaceholderLabel!)
        }
        animatablePlaceholderLabel?.text = placeHolderTextForAnimation
    }
    
    override func textFieldDidChange(_ textField: UITextField) {
        super.textFieldDidChange(textField)
        toggleAnimateLabelPosition()
        if isErrorStateEnabled {
            resetAppearance()
        }
    }
    
    
    private func toggleAnimateLabelPosition() {
        if let count = self.text?.count, count > 0 {
            animatePlaceholderToTop()
        } else {
            restorePlaceholderPosition()
        }
    }
    
    private func animatePlaceholderToTop() {
        if let yPos = animatablePlaceholderLabel?.frame.origin.y, yPos >= 0 {
            UIView.animate(withDuration: 0.3) {
                self.animatablePlaceholderLabel?.frame =
                CGRect(x: 0, y: -self.bounds.height, width: self.bounds.width, height: self.bounds.height)
            }
        }
    }
    
    private func restorePlaceholderPosition() {
        if let yPos = animatablePlaceholderLabel?.frame.origin.y, yPos < 0 {
            UIView.animate(withDuration: 0.3) {
                self.animatablePlaceholderLabel?.frame = CGRect(x: 5, y: 0, width: self.bounds.width, height: self.bounds.height)
            }
        }
    }
    
    private func prepareForErrorState() {
        lineBelowTheTextField?.backgroundColor = .red
        animatablePlaceholderLabel?.textColor = .red
    }
    
    private func resetAppearance() {
        lineBelowTheTextField?.backgroundColor = placeHolderTextForAnimationColor ?? self.textColor?.withAlphaComponent(0.75)
        animatablePlaceholderLabel?.textColor = placeHolderTextForAnimationColor ?? self.textColor?.withAlphaComponent(0.75)
        validationErrorLabel?.text = ""
    }
}

private extension APAnimatablePlaceholderTextField {
    func showALine() {
        lineBelowTheTextField = UIView(frame: .zero)
        self.addSubview(lineBelowTheTextField!)
        lineBelowTheTextField?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: lineBelowTheTextField!, attribute: NSLayoutConstraint.Attribute.leftMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leftMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lineBelowTheTextField!, attribute: NSLayoutConstraint.Attribute.rightMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.rightMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lineBelowTheTextField!, attribute: NSLayoutConstraint.Attribute.bottomMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lineBelowTheTextField!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute  , multiplier: 1, constant: 1).isActive = true
        lineBelowTheTextField?.backgroundColor = placeHolderTextForAnimationColor ?? self.textColor?.withAlphaComponent(0.75)
    }
}

private extension APAnimatablePlaceholderTextField {
    func showTheRevealButton() {
        let revealButton = APBindingButton(frame: CGRect(x: 0, y: 0, width: 42, height: 19))
        revealButton.setTitle("SHOW", for: .normal)
        revealButton.setTitle("HIDE", for: .selected)
        revealButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 10)
        revealButton.setTitleColor(.gray, for: .normal)
        revealButton.setTitleColor(.gray, for: .selected)
        self.rightView = revealButton
        self.rightViewMode = .always
        revealButton.bind {
            revealButton.isSelected = !revealButton.isSelected
            revealButton.isSelected ? (self.isSecureTextEntry = false) : (self.isSecureTextEntry = true)
        }
    }
}

private extension APAnimatablePlaceholderTextField {
    func showTheValidationError() {
        validationErrorLabel = UILabel(frame: .zero)
        self.addSubview(validationErrorLabel!)
        validationErrorLabel?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: validationErrorLabel!, attribute: NSLayoutConstraint.Attribute.leftMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leftMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: validationErrorLabel!, attribute: NSLayoutConstraint.Attribute.rightMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.rightMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: validationErrorLabel!, attribute: NSLayoutConstraint.Attribute.topMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: validationErrorLabel!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute  , multiplier: 1, constant: 20).isActive = true
        validationErrorLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        validationErrorLabel?.textColor = .red
    }
}

private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}
