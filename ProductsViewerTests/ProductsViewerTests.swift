//
//  ProductsViewerTests.swift
//  ProductsViewerTests
//

import XCTest
@testable import ProductsViewer

class ProductsViewerTests: XCTestCase {
    
    var productsController: ProductsViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navController = storyboard.instantiateInitialViewController() as? UINavigationController
        productsController = navController?.viewControllers.first as? ProductsViewController
    }
    
    override func tearDown() {
        Product.deleteAllObjects()
        super.tearDown()
    }
    
    func testRetrievingProductsFromServer() {
        if let productsVC = productsController {
            productsVC.viewModel.endRetrievingData = { success, disposed in
                if success {
                    if let objectsInDatabase = Product.fetchFromDefaultContext(), objectsInDatabase.count > 0 {
                        XCTAssert(true)
                    } else {
                        XCTAssert(false)
                    }
                }
            }
            
            productsVC.viewModel.restartDownload()
        } else {
            XCTAssert(false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
