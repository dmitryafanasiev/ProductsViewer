//
//  CoreDataViewController.swift
//  ProductsViewer
//

import CoreData
import Foundation
import UIKit

class CoreDataViewController: UIViewController {
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            fetchResultController?.delegate = self
        }
    }
    
    var insertRowAnimation: UITableViewRowAnimation = .fade
    var deleteRowAnimation: UITableViewRowAnimation = .fade
    var moveRowAnimation: UITableViewRowAnimation = .fade
    var changeRowAnimation: UITableViewRowAnimation = .fade
    
    var fetchResultControllerWillChangeContent:(()->())?
    var fetchResultControllerDidChangeContent:(()->())?
    var fetchResultControllerDidChangeSection:((_ section: NSFetchedResultsSectionInfo, _ atIndex: Int, _ changeType: NSFetchedResultsChangeType)->())?
    var fetchResultControllerDidChangeObject:((_ object: Any, _ atIndexPath: IndexPath?, _ changeType: NSFetchedResultsChangeType, _ newIndexPath: IndexPath?)->())?
    
    func fetchLocalData() {
        do {
            try fetchResultController?.performFetch()
        } catch {
            print("\n-------Error due to fetching data in \(String(describing: self))-------\n")
        }
    }
    
    func configureFetchController() {
        // Configure you fetch request there
    }
}

extension CoreDataViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchResultControllerWillChangeContent?()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchResultControllerDidChangeContent?()
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        fetchResultControllerDidChangeSection?(sectionInfo, sectionIndex, type)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        fetchResultControllerDidChangeObject?(anObject, indexPath, type, newIndexPath)
    }
    
}
