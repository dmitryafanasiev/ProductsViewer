//
//  ProductDetailsViewController.swift
//  ProductsViewer
//

import Foundation
import UIKit
import Kingfisher

class ProductDetailsViewController: UIViewController {
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var iconImageView: UIImageView?
    @IBOutlet fileprivate weak var priceLabel: UILabel?
    @IBOutlet fileprivate weak var nameLabel: UILabel?
    @IBOutlet fileprivate weak var descriptionLabel: UILabel?
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView?
    
    var viewModel = ProductDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.product?.name
        
        applyUIChanges()
        
        viewModel.downloadProductDetailsSignalProducer.on(started: { [weak self] in
            if self?.viewModel.product?.productDescription == nil {
                self?.activityIndicatorView?.startAnimating()
            } else {
                self?.activityIndicatorView?.stopAnimating()
            }
        }, failed: { [weak self] error in
            self?.activityIndicatorView?.stopAnimating()
            if self?.viewModel.product?.productDescription == nil {
                self?.descriptionLabel?.text = "Failed to get product description"
            }
        }, completed: { [weak self] in
            self?.applyUIChanges()
            self?.activityIndicatorView?.stopAnimating()
            if self?.viewModel.product?.productDescription == nil {
                self?.descriptionLabel?.text = "Product description not found"
            }
        }).start()
    }
    
    fileprivate func applyUIChanges() {
        nameLabel?.text = viewModel.product?.name
        
        priceLabel?.text = viewModel.product?.price.decimalStyleString()
        
        if let urlString = viewModel.product?.imageUrl, let url = URL(string: urlString) {
            iconImageView?.kf.setImage(with: url)
        } else {
            iconImageView?.kf.cancelDownloadTask()
            iconImageView?.image = nil
        }
        
        descriptionLabel?.text = viewModel.product?.productDescription
    }
    
}
