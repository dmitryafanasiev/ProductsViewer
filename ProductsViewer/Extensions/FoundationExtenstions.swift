//
//  FoundationExtenstions.swift
//  ProductsViewer
//

import Foundation

extension Array where Element: Equatable  {
    
    mutating func removeObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
    mutating func removeObjects(objects: [Element]) {
        for object in objects {
            removeObject(object: object)
        }
    }
    
}

extension NSNumber {
    
    func decimalStyleString() -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        return "$ " + (fmt.string(from: self) ?? "0")
    }
    
}
