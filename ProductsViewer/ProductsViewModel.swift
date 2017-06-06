//
//  ProductsViewModel.swift
//  ProductsViewer
//

import Foundation
import Alamofire
import ReactiveSwift

enum ProductsSorting: String {
    case alphabeticAscending = "Alphabetic Ascending"
    case alphabeticDescending = "Alphabetic Descending"
    case priceAscending = "Price Ascending"
    case priceDescending = "Price Descending"
    
    static let allValues = [alphabeticAscending, alphabeticDescending, priceAscending, priceDescending]
}

enum ProductsRepresentation {
    case large
    case small
}

class ProductsViewModel: CoreDataControllerViewModel {
    
    var selectedSorting: ProductsSorting = .alphabeticAscending {
        didSet {
            if oldValue != selectedSorting {
                selectedSortingChangeCallbak?(selectedSorting)
            }
        }
    }
    var selectedRepresentation: ProductsRepresentation = .large {
        didSet {
            if oldValue != selectedRepresentation {
                representationChangeCallback?()
            }
        }
    }
    var representationChangeCallback: (()->())?
    var selectedSortingChangeCallbak: ((ProductsSorting)->())?
    var startRetrievingData: (()->())?
    var endRetrievingData: ((_ success: Bool, _ disposed: Bool)->())?
    var request: Request?
    var disposable: Disposable?
    fileprivate(set) var downloadProductsSignalProducer: SignalProducer<Void, AppError>!
    fileprivate var cellSpacing: CGFloat = 10
        
    override var screenTitle: String? {
        return "Procucts"
    }
    
    override init() {
        super.init()

        downloadProductsSignalProducer = SignalProducer { [weak self] (observer, _) in
            guard let strongSelf = self else {
                observer.send(error: .weakSelf)
                return
            }
            
            if !AppDelegate.shared.networkReachable.value {
                observer.send(error: .noInternetConnection)
                return
            }
            
            strongSelf.request?.cancel()
            strongSelf.request = AppDelegate.HTTPManager.request(ApiConstants.baseUrl + ApiConstants.productsListEndpoint, encoding: JSONEncoding.default)
                .responseJSON(completionHandler: { response in
                    if response.result.isSuccess {
                        if let JSON = response.value as? Parameters,
                            let productsInfo = JSON["products"] as? [Parameters] {
                            
                            // Will display Products with appropriate product_id on the screen
                            // Previously downloaded Products stay as they are in the database
                            // Every time app launches it will be possible to remove old Products
                            // based on their lastUpdate field value
                            
                            // I hope this logic will help to implement pagination for this kind of requests
                            // but originally API for server do not supports 'page' parameter
                            
                            strongSelf.removeAllElements(group: 0)
                            for info in productsInfo {
                                if let idString = info["product_id"] as? String, let id = Int(idString) {
                                    let product = Product.productWithIdOrNewOne(id: id)
                                    product.customizeWith(info: info)
                                    strongSelf.append(element: NSNumber(value: id), atGroup: 0)
                                }
                            }
                            AppDelegate.shared.saveContext()
                            observer.sendCompleted()
                        } else {
                            observer.send(error: .unexpectedResponseStructure)
                        }
                    } else {
                        observer.send(error: .unknown)
                    }
                })
        }
    }
    
    func addNetworkreachabilityObservation() {
        AppDelegate.shared.networkReachable.signal.observeValues({ [weak self] reachable in
            self?.disposable?.dispose()
            self?.disposable = nil
            if reachable {
                self?.restartDownload()
            }
        })
    }
    
    func restartDownload() {
        if disposable == nil {
            disposable = downloadProductsSignalProducer.on(starting: { [weak self] in
                self?.startRetrievingData?()
                }, failed: { [weak self] (error) in
                    self?.endRetrievingData?(false, false)
                }, completed: { [weak self] in
                    self?.endRetrievingData?(true, false)
                }, disposed: { [weak self] in
                    self?.endRetrievingData?(false, true)
                    self?.disposable = nil
            }).start()
        }
    }
    
    override func sortDescriptors() -> [NSSortDescriptor]? {
        var sortDescriptors = [NSSortDescriptor]()
        switch selectedSorting {
        case .alphabeticAscending:
            sortDescriptors.append(NSSortDescriptor(key: "name", ascending: true))
        case .alphabeticDescending:
            sortDescriptors.append(NSSortDescriptor(key: "name", ascending: false))
        case .priceAscending:
            sortDescriptors.append(NSSortDescriptor(key: "price", ascending: true))
        case .priceDescending:
            sortDescriptors.append(NSSortDescriptor(key: "price", ascending: false))
        }
        
        sortDescriptors.append(NSSortDescriptor(key: "id", ascending: true))
        
        return sortDescriptors
    }
    
    override func predicate() -> NSPredicate? {
        var productsInDatasource = [NSNumber]()
        var productsCount = -1
        if source.count > 0 {
            if let products = items(group: 0) as? [NSNumber] {
                productsCount = products.count
                productsInDatasource.append(contentsOf: products)
            }
        }
        
        if productsCount > 0 {
            // If we have some downloaded products - then show them
            // For example when we have downloaded the list of products and then Internet dissapears
            let predicate = NSPredicate(format: "id IN %@", Set(productsInDatasource))
            return predicate
        } else {
            // Show products based on internet connection availability
            
            // If no internet connection
            // show all products from the database
            // This works for this particular case, because products on server do not change
            
            if AppDelegate.shared.networkReachable.value {
                let predicate = NSPredicate(format: "id IN %@", Set(productsInDatasource))
                return predicate
            } else {
                let predicate = NSPredicate(format: "id > 0")
                
                return predicate
            }
        }
    }
    
    override func cellSize(collectionViewSize: CGSize) -> CGSize {
        switch selectedRepresentation {
        case .large:
            // check for device orientation
            if collectionViewSize.width > collectionViewSize.height {
                return CGSize(width: (collectionViewSize.width - 3 * cellSpacing) / 4, height: 200)
            } else {
                return CGSize(width: (collectionViewSize.width - cellSpacing) / 2, height: 200)
            }
        case .small:
            if collectionViewSize.width > collectionViewSize.height {
                return CGSize(width: (collectionViewSize.width - 5 * cellSpacing) / 6, height: 200)
            } else {
                return CGSize(width: (collectionViewSize.width - 3 * cellSpacing) / 4, height: 200)
            }
        }
    }
    
}
