//
//  UIViewExtensions.swift
//  ProductsViewer
//

import UIKit

extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(newValue) {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set(newValue) {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    static var defaultReuseIdentifier : String {
        return String(describing: self)
    }
    
    func roundView(radius: CGFloat) {
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = radius
    }
    
}
