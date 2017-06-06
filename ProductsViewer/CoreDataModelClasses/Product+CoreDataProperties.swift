//
//  TMTask+CoreDataProperties.swift
//  ProductsViewer
//

import Foundation
import CoreData

extension Product {

    @NSManaged public var id: NSNumber
    @NSManaged public var price: NSNumber
    @NSManaged public var name: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var lastUpdated: Date?
    
    func customizeWith(info: [String : Any]) {
        if let name = info["name"] as? String {
            self.name = name
        }
        if let image = info["image"] as? String {
            self.imageUrl = image
        }
        if let price = info["price"] as? Int {
            self.price = NSNumber(value: price)
        }
        if let desc = info["description"] as? String {
            self.productDescription = desc
        }
        lastUpdated = Date()
    }

}

extension Product {
    
    static func productWithId(id: Int) -> Product? {
        return Product.fetchFromDefaultContext(withPredicate: NSPredicate(format: "id == %@", NSNumber(value: id)))?.first
    }
    
    static func productWithIdOrNewOne(id: Int) -> Product {
        let product: Product = productWithId(id: id) ?? newProduct(id: id)
        
        return product
    }
    
    static func newProduct(id: Int) -> Product {
        let product: Product = AppDelegate.shared.managedObjectContext.insertObject()
        product.id = NSNumber(value: id)
        product.lastUpdated = Date()
        
        return product
    }
    
}
