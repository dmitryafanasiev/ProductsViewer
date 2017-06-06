//
//  AppDelegate.swift
//  ProductsViewer
//

import UIKit
import CoreData
import Alamofire
import Kingfisher
import ReachabilitySwift
import ReactiveSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static var HTTPManager : Alamofire.SessionManager = {
        return Alamofire.SessionManager()
    }()
    
    fileprivate var reachability = Reachability()!
    private(set) var networkReachable = MutableProperty<Bool>(false)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        startReachability()
        
        // Image caching
        KingfisherManager.shared.cache.maxDiskCacheSize = UInt(1024 * 1024 * 500) // 500 MB
        KingfisherManager.shared.cache.maxCachePeriodInSecond = TimeInterval(60 * 60 * 24 * 2) // 2 days before image deletion
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        reachability.stopNotifier()
        saveContext()
    }
    
    fileprivate func startReachability() {
        reachability.whenReachable = { [weak self] _ in
            self?.networkReachable.value = true
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.networkReachable.value = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "ProductsViewer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let databaseName = "ProductsViewerDatabase.sqlite"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(databaseName)
        let options = [NSMigratePersistentStoresAutomaticallyOption : true,
                       NSInferMappingModelAutomaticallyOption : true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch let error as NSError {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data." as AnyObject?
            dict[NSUnderlyingErrorKey] = error
            
            let wrappedError = NSError(domain: "productsviewer.error.domain", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        } catch {
            NSLog("Unresolved error (not NSError)")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
