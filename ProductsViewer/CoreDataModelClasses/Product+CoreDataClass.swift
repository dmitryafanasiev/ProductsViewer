//
//  TMTask+CoreDataClass.swift
//  ProductsViewer
//

import Foundation
import CoreData

protocol CoreDataObjectCustomizationProtocol {
    func customizeWith(info: [String : Any])
}

public class Product: NSManagedObject, CoreDataObjectCustomizationProtocol {

}
