//
//  NSManagedObjectContextExtensions.swift
//  ProductsViewer
//

import CoreData

extension NSManagedObjectContext {
    
    public func insertObject<T: NSManagedObject>() -> T {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T else {
            fatalError("Invalid Core Data Model.")
        }
        return object
    }
    
    public func removeObjects(objects: [NSManagedObject]) {
        for obj in objects {
            delete(obj)
        }
    }
    
}
