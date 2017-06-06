//
//  ProductDetailsViewModel.swift
//  ProductsViewer
//

import Foundation
import ReactiveSwift
import Alamofire

class ProductDetailsViewModel: ControllerViewModel {
    var productId: Int = 0 {
        didSet {
            product = Product.productWithId(id: productId)
        }
    }
    private(set) var product: Product?
    fileprivate(set) var downloadProductDetailsSignalProducer: SignalProducer<Void, AppError>!
    
    override init() {
        super.init()
        
        downloadProductDetailsSignalProducer = SignalProducer { [weak self] (observer, _) in
            guard let strongSelf = self else {
                observer.send(error: .weakSelf)
                return
            }
            if strongSelf.productId <= 0 {
                observer.send(error: .unknown)
                return
            }
            let id = strongSelf.productId
            let url = ApiConstants.baseUrl + ApiConstants.productDetailsEndpoint.replacingOccurrences(of: "{product_id}", with: String(describing: id))
            AppDelegate.HTTPManager.request(url, encoding: JSONEncoding.default)
                .responseJSON(completionHandler: { [weak self] response in
                    if response.result.isSuccess {
                        if let JSON = response.value as? Parameters {
                            if let idString = JSON["product_id"] as? String, let id = Int(idString) {
                                let product = Product.productWithIdOrNewOne(id: id)
                                product.customizeWith(info: JSON)
                                
                                AppDelegate.shared.saveContext()
                                self?.productId = id
                                observer.sendCompleted()
                            } else {
                                observer.send(error: .unexpectedResponseStructure)
                            }
                        } else {
                            observer.send(error: .unexpectedResponseStructure)
                        }
                    } else {
                        observer.send(error: .unknown)
                    }
                })
        }
    }
}
