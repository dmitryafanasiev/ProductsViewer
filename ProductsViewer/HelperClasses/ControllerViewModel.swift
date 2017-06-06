//
//  ControllerViewModel.swift
//  ProductsViewer
//

import Foundation
import CoreGraphics

protocol CellSizeProtocol {
    func cellSize(collectionViewSize: CGSize) -> CGSize
}

protocol CoreDataViewModelProtocol {
    func predicate() -> NSPredicate?
    func sortDescriptors() -> [NSSortDescriptor]?
}

class ControllerViewModel : ViewModel, CellSizeProtocol {
    
    var screenTitle: String? {
        return nil
    }
    
    func cellSize(collectionViewSize: CGSize) -> CGSize {
        // Override to implement
        return CGSize.zero
    }
    
}

class CoreDataControllerViewModel: ControllerViewModel, CoreDataViewModelProtocol {
    
    func sortDescriptors() -> [NSSortDescriptor]? {
        // Override to implement
        return nil
    }

    func predicate() -> NSPredicate? {
        // Override to implement
        return nil
    }

}
