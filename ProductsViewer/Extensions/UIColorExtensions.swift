//
//  UIColorExtensions.swift
//  ProductsViewer
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    class func pvBlue() -> UIColor {
        return UIColor(hex: 0x019CFF)
    }
    
    class func pvBlueDisabled() -> UIColor {
        return UIColor(hex: 0x86D3FF)
    }
    
    class func pvBlueHighlited() -> UIColor {
        return UIColor(hex: 0x1069C6)
    }
    
    class func pvTurquoise() -> UIColor {
        return UIColor(hex: 0x60DAD2)
    }
    
    class func pvTurquoiseDark() -> UIColor {
        return UIColor(hex: 0x51D0C7)
    }
    
    class func pvPrimaryDarkGrey() -> UIColor {
        return UIColor(hex: 0x484745)
    }
    
    class func pvSecondaryMediumGrey() -> UIColor {
        return UIColor(hex: 0x969594)
    }
    
    class func pvTertiaryLightGrey() -> UIColor {
        return UIColor(hex: 0xCCCBCB)
    }
    
    class func pvLightGrey() -> UIColor {
        return UIColor(hex: 0xFAFAFA)
    }
    
    class func pvLightBackgroundGrey() -> UIColor {
        return UIColor(hex: 0xF5F5F5)
    }
    
}
