//
//  CoreDataCollectionViewController.swift
//  ProductsViewer
//

import CoreData
import UIKit

class CoreDataCollectionViewController: CoreDataViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    class UpdateItem {
        var startIndex: IndexPath?
        var endIndex: IndexPath?
        var sectionInfo: NSFetchedResultsSectionInfo?
        var sectionIndex: Int?
        var type: NSFetchedResultsChangeType?
    }
    
    fileprivate var updateItems: [UpdateItem]?
    fileprivate var needReloadInsteadOfBatchUpdates = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchResultControllerWillChangeContent = { [weak self] in
            self?.updateItems = [UpdateItem]()
        }
        
        fetchResultControllerDidChangeContent = { [weak self] in
            guard let strongSelf = self, let updateItems = self?.updateItems else {
                return
            }
            if strongSelf.needReloadInsteadOfBatchUpdates {
                strongSelf.needReloadInsteadOfBatchUpdates = false
                strongSelf.updateItems = nil
                strongSelf.collectionView.reloadData()
            } else {
                strongSelf.collectionView?.performBatchUpdates({
                    for item in updateItems {
                        switch item.type! {
                        case .insert:
                            if item.sectionInfo == nil {
                                if let index = item.endIndex {
                                    strongSelf.collectionView.insertItems(at: [index])
                                }
                            } else {
                                strongSelf.collectionView.insertSections(IndexSet(integer: item.sectionIndex!))
                            }
                            break
                        case .delete:
                            if item.sectionInfo == nil {
                                if let index = item.startIndex {
                                    strongSelf.collectionView.deleteItems(at: [index])
                                }
                            } else {
                                strongSelf.collectionView.deleteSections(IndexSet(integer: item.sectionIndex!))
                            }
                            break
                        case .move:
                            if item.sectionInfo == nil {
                                if let index = item.startIndex {
                                    strongSelf.collectionView.insertItems(at: [index])
                                }
                                if let endIndex = item.endIndex {
                                    strongSelf.collectionView.deleteItems(at: [endIndex])
                                }
                            }
                        case .update:
                            if item.sectionInfo == nil {
                                if let index = item.startIndex {
                                    strongSelf.collectionView.reloadItems(at: [index])
                                }
                            } else {
                                strongSelf.collectionView.reloadSections(IndexSet(integer: item.sectionIndex!))
                            }
                            break
                        }
                    }
                }, completion: { completed in
                        if completed {
                            strongSelf.updateItems = nil
                        }
                })
            }
        }
        
        fetchResultControllerDidChangeObject = { [weak self] (object, indexPath, type, newIndexPath) in
            guard let strongSelf = self else {
                return
            }
            
            if strongSelf.needReloadInsteadOfBatchUpdates {
                return
            }
            
            var needToAppendBatchUpdate = false
            
            switch type {
            case .insert, .move:
                strongSelf.needReloadInsteadOfBatchUpdates = true
            case .delete:
                if let indexPath = indexPath {
                    let sectionsNumber = strongSelf.collectionView.numberOfItems(inSection: indexPath.section)
                    if sectionsNumber <= 1 {
                        strongSelf.needReloadInsteadOfBatchUpdates = true
                    } else {
                        needToAppendBatchUpdate = true
                    }
                } else {
                    strongSelf.needReloadInsteadOfBatchUpdates = true
                }
            case .update:
                needToAppendBatchUpdate = true
            }
            
            if needToAppendBatchUpdate {
                if type == .move {
                    let item1 = UpdateItem()
                    item1.type = .delete
                    item1.startIndex = indexPath
                    item1.endIndex = indexPath
                    strongSelf.updateItems?.append(item1)
                    
                    let item2 = UpdateItem()
                    item2.type = .insert
                    item2.startIndex = newIndexPath
                    item2.endIndex = newIndexPath
                    strongSelf.updateItems?.append(item2)
                } else {
                    let item = UpdateItem()
                    item.type = type
                    item.startIndex = indexPath
                    item.endIndex = newIndexPath
                    strongSelf.updateItems?.append(item)
                }
            }
        }
        
        fetchResultControllerDidChangeSection = { [weak self] (section, index, type) in
            guard let strongSelf = self else {
                return
            }
            if type != .update {
                strongSelf.needReloadInsteadOfBatchUpdates = true
            } else {
                let item = UpdateItem()
                item.type = type
                item.sectionInfo = section
                item.sectionIndex = index
                strongSelf.updateItems?.append(item)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchLocalData()
    }
    
}
