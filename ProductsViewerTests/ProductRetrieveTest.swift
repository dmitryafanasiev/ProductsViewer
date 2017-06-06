//
//  ProductRetrieveTest.swift
//  ProductsViewer
//

import XCTest
@testable import ProductsViewer
@testable import ReactiveSwift
@testable import Alamofire

class ProductRetrieveTest: XCTestCase {
    
    var productDetailsController: ProductDetailsViewController?
    var idToTest: Int = 5
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        productDetailsController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsViewController
        productDetailsController?.viewModel.productId = idToTest
        
        // Remove existing product if needed
        if let product = Product.productWithId(id: idToTest) {
            AppDelegate.shared.managedObjectContext.delete(product)
            AppDelegate.shared.saveContext()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProductDownloadById() {
        productDetailsController?.viewModel.downloadProductDetailsSignalProducer.on(
            failed: {  error in
                XCTAssert(false)
            }, completed: {
                if let _ = Product.productWithId(id: self.idToTest) {
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
        }).start()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
