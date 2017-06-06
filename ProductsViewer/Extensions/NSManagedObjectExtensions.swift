//
//  NSManagedObjectExtensions.swift
//  ProductsViewer
//

import CoreData

extension NSManagedObject {
    
    static var entityName : String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    convenience init(managedObjectContext: NSManagedObjectContext) {
        let entityName = type(of: self).entityName
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
        self.init(entity: entity, insertInto: managedObjectContext)
    }
    
    static func deleteAllObjects() {
        let context = AppDelegate.shared.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                context.removeObjects(objects: results)
                
                AppDelegate.shared.saveContext()
            }
        } catch {
            print("Error deleting all objects of \(entityName)")
        }
    }
    
    static func fetchRequestFromDefaultContext() -> NSFetchRequest<NSFetchRequestResult> {
        return fetchRequestFromDefaultContextWithPredicate(predicate: nil)
    }
    
    static func fetchRequestFromDefaultContextWithPredicate(predicate: NSPredicate?) -> NSFetchRequest<NSFetchRequestResult> {
        return fetchRequestFromDefaultContextWithPredicate(predicate: predicate, sortDescriptors: nil)
    }
    
    static func fetchRequestFromDefaultContextWithPredicate(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }
    
    static func fetchFromDefaultContext<T: NSManagedObject>() -> [T]? {
        return fetchFromDefaultContext(withPredicate: nil)
    }
    
    static func fetchFromDefaultContext<T: NSManagedObject>(withPredicate predicate: NSPredicate?) -> [T]? {
        return fetchFromDefaultContext(withPredicate: predicate, sortDescriptors: nil)
    }
    
    static func fetchFromDefaultContext<T: NSManagedObject>(withPredicate predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]? {
        let context = AppDelegate.shared.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let results = try context.fetch(fetchRequest)
            if let managedObjects = results as? [T] {
                return managedObjects
            } else {
                print("fetchFromDefaultContext for \(entityName) didn't found valid objects in the context")
                return nil
            }
        } catch {
            print("fetchFromDefaultContext for \(entityName) failed")
            return nil
        }
    }
    
}
