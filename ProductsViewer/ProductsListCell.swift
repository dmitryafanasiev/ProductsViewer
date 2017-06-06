//
//  ProductsListCell.swift
//  ProductsViewer
//

import UIKit
import Foundation
import Kingfisher

protocol ProductCustomizationProtocol {
    func customizeWithProduct(product: Product?)
}

class ProductsListCell: UICollectionViewCell, ProductCustomizationProtocol {
    @IBOutlet fileprivate weak var iconImageView: UIImageView?
    @IBOutlet fileprivate weak var nameLabel: UILabel?
    @IBOutlet fileprivate weak var priceLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView?.layer.borderWidth = 1
        iconImageView?.layer.borderColor = UIColor.pvTurquoise().cgColor
        iconImageView?.roundView(radius: 5)
        iconImageView?.kf.indicatorType = .activity
        
        iconImageView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        priceLabel?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        customizeWithProduct(product: nil)
    }
    
    func customizeWithProduct(product: Product?) {
        imageUrl = product?.imageUrl
        name = product?.name
        price = product?.price
    }
    
    var name: String? {
        didSet {
            nameLabel?.text = name
        }
    }
    
    var price: NSNumber? {
        didSet {
            priceLabel?.text = price?.decimalStyleString()
        }
    }
    
    var imageUrl: String? {
        didSet {
            if let urlString = imageUrl, let url = URL(string: urlString) {
                iconImageView?.kf.setImage(with: url)
            } else {
                iconImageView?.kf.cancelDownloadTask()
                iconImageView?.image = nil
            }
        }
    }
    
}
