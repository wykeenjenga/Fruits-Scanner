//
//  APButton.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/27/22.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit

class APBindingButton: UIButton{
    
    private var buttonTappedCallback:() -> () = { }

    func bind(callback: @escaping () -> ()) {
        buttonTappedCallback = callback
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        buttonTappedCallback()
    }

    var badgeValue : String! = "" {
            didSet {
                self.layoutSubviews()
            }
        }

        override init(frame :CGRect)  {
            // Initialize the UIView
            super.init(frame : frame)
            
            self.awakeFromNib()
        }
        
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            self.awakeFromNib()
        }
        
        
        override func awakeFromNib()
        {
            self.drawBadgeLayer()
        }

        var badgeLayer :CAShapeLayer!
        func drawBadgeLayer() {
            
            if self.badgeLayer != nil {
                self.badgeLayer.removeFromSuperlayer()
            }
            
            // Omit layer if text is nil
            if self.badgeValue == nil || self.badgeValue.count == 0 {
                return
            }else if let badgeValueInInt = Int(badgeValue), badgeValueInInt >= 100 {
                badgeValue = "98+"
            }
            
            //! Initial label text layer
            let labelText = APCATextLayer()
            labelText.contentsScale = UIScreen.main.scale
            labelText.string = self.badgeValue.uppercased()
            labelText.fontSize = 12.0
            labelText.font = UIFont.systemFont(ofSize: 9)
            labelText.alignmentMode = CATextLayerAlignmentMode.center
            labelText.foregroundColor = UIColor.white.cgColor
            
            let labelString = self.badgeValue.uppercased() as String?
            let labelFont = UIFont.systemFont(ofSize: 9) as UIFont?
            if badgeValue.count == 1 {
                labelText.fontSize = 14.0
            }
            let attributes = [NSAttributedString.Key.font : labelFont]
            let w = self.frame.size.width
            let h = CGFloat(20.0)  // fixed height
            let labelWidth:CGFloat = 20    // Starting point
            let rect = labelString!.boundingRect(with: CGSize(width: 15, height: h), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            let textWidth = max(round(rect.width * UIScreen.main.scale), labelWidth)
            labelText.frame = CGRect(x: 6, y: -6, width: textWidth, height: textWidth)

            //! Initialize outline, set frame and color
            let shapeLayer = CAShapeLayer()
            shapeLayer.contentsScale = UIScreen.main.scale
            let frame : CGRect = labelText.frame
            let cornerRadius = textWidth/2
            let borderInset = CGFloat(-1.0)
            let aPath = UIBezierPath(roundedRect: frame.insetBy(dx: borderInset, dy: borderInset), cornerRadius: cornerRadius)
            
            shapeLayer.path = aPath.cgPath
            shapeLayer.fillColor = UIColor.red.cgColor
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 0.5

            shapeLayer.insertSublayer(labelText, at: 0)

            shapeLayer.frame = shapeLayer.frame.offsetBy(dx: w*0.5, dy: 0.0)
            
            self.layer.insertSublayer(shapeLayer, at: 999)
            self.layer.masksToBounds = false
            self.badgeLayer = shapeLayer
            
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.drawBadgeLayer()
            self.setNeedsDisplay()
        }
}

class APCATextLayer: CATextLayer {
    override open func draw(in ctx: CGContext) {
        let yDiff: CGFloat
        let fontSize: CGFloat
        let height = self.bounds.height

        if let attributedString = self.string as? NSAttributedString {
            fontSize = attributedString.size().height
            yDiff = (height-fontSize)/2
        } else {
            fontSize = self.fontSize
            yDiff = (height-fontSize)/2 - fontSize/10
        }

        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}

//@IBDesignable extension UIButton {
//
//    @IBInspectable var borderWidth: CGFloat {
//        set {
//            layer.borderWidth = newValue
//        }
//        get {
//            return layer.borderWidth
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        set {
//            guard let uiColor = newValue else { return }
//            layer.borderColor = uiColor.cgColor
//        }
//        get {
//            guard let color = layer.borderColor else { return nil }
//            return UIColor(cgColor: color)
//        }
//    }
//}
