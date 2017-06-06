//
//  StringExtensions.swift
//  ProductsViewer
//

import Foundation

extension String {

    func capitalizedFirstLetter() -> String {
        if characters.count > 0 {
            let first = String(characters.prefix(1)).uppercased()
            let other = String(characters.dropFirst())
            return first + other
        } else {
            return self
        }
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizedFirstLetter()
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
}
