//
//  ViewModel.swift
//  ProductsViewer
//

import Foundation

protocol ViewModelProtocol {
    func itemsCount(group : Int) -> Int
    func item(atGroup group : Int, atPosition position : Int) -> AnyObject?
    func items(group: Int) -> [AnyObject]?
}

class ViewModel: ViewModelProtocol {
    
    private(set) var source = Array<Array<AnyObject>>()
    private(set) var sourceGroupKeys = Array<AnyObject>() // for handling section info
    
    // MARK: Protocol Methods
    
    func item(atGroup group: Int, atPosition position: Int) -> AnyObject? {
        if source.count > group && source[group].count > position {
            return source[group][position]
        }
        print("\(String(describing: self)) error: trying to access out of bounds element at group \(group) and position \(position)")
        return nil
    }
    
    func itemsCount(group: Int) -> Int {
        if let items = items(group: group) {
            return items.count
        }
        return 0
    }
    
    func items(group: Int) -> [AnyObject]? {
        if source.count > group {
            return source[group]
        }
        print("\(String(describing: self)) error: trying to access out of bounds group \(group)")
        return nil
    }
    
    // MARK: Access To Elements
    
    func append(element: AnyObject, atGroup groupIndex : Int) {
        if source.count > groupIndex {
            source[groupIndex].append(element)
        } else if source.count == groupIndex {
            source.append(Array<AnyObject>())
            source[groupIndex].append(element)
        } else {
            print("\(String(describing: self)) error: trying to access out of bounds group \(groupIndex)")
        }
    }
    
    func append(elements: Array<AnyObject>, atGroup groupIndex: Int) {
        if source.count > groupIndex {
            source[groupIndex].append(contentsOf: elements)
        } else if source.count == groupIndex {
            source.append(Array<AnyObject>())
            source[groupIndex].append(contentsOf: elements)
        } else {
            print("\(String(describing: self)) error: trying to access out of bounds group \(groupIndex)")
        }
    }
    
    func append(element: AnyObject, atGroup groupIndex : Int, atPosition position: Int) {
        if source.count > groupIndex {
            if source[groupIndex].count > position {
                source[groupIndex][position] = element
            } else {
                print("\(String(describing: self)) error: trying to add out of bounds element \(groupIndex)")
            }
        } else if source.count == groupIndex {
            source.append(Array<AnyObject>())
            if position == 0 {
                source[groupIndex].append(element)
            } else {
                print("\(String(describing: self)) error: trying to add out of bounds element \(groupIndex) in empty array")
            }
        } else {
            print("\(String(describing: self)) error: trying to access out of bounds group \(groupIndex)")
        }
    }
    
    func removeAllElements(group groupIndex : Int) {
        if source.count > groupIndex {
            source[groupIndex].removeAll()
        } else {
            print("\(String(describing: self)) error: trying to remove all elements in non-existing group \(groupIndex)")
        }
    }
    
    func removeAllElements() {
        source.removeAll()
    }
    
    // MARK: Access To Group Keys (aka Section Info)
    
    func removeAllGroupKeys() {
        sourceGroupKeys.removeAll()
    }
    
    func groupKey(group: Int) -> AnyObject? {
        if sourceGroupKeys.count > group {
            return sourceGroupKeys[group]
        } else {
            print("\(String(describing: self)) error: trying to access out of bounds group key \(group)")
            return nil
        }
    }
    
    func appendGroupKey(element: AnyObject) {
        sourceGroupKeys.append(element)
    }
    
    func appendGroupKeys(elements: Array<AnyObject>) {
        sourceGroupKeys.append(contentsOf: elements)
    }
    
    // MARK: Clear All Stored Data
    
    func clearAllData() {
        removeAllElements()
        removeAllGroupKeys()
    }

}
