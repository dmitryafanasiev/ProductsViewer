//
//  PostsSortingView.swift
//  ProductsViewer
//

import Foundation
import UIKit

class ProductsSortingView: UIView {
    @IBOutlet weak private var smallProjectImageView: UIImageView!
    @IBOutlet weak private var largeProjectImageView: UIImageView!
    @IBOutlet weak private var currentSortingButton: UIButton!
    
    var sortingButtonPressed: (()->())?
    var representationButtonPressed: ((ProductsRepresentation)->())?
    
    var selectedSorting: ProductsSorting = .alphabeticAscending {
        didSet {
            currentSortingButton.setTitle(selectedSorting.rawValue, for: .normal)
        }
    }
    
    var selectedRepresentation: ProductsRepresentation = .large {
        didSet {
            switch selectedRepresentation {
            case .large:
                largeProjectImageView.tintColor = UIColor.pvPrimaryDarkGrey()
                smallProjectImageView.tintColor = UIColor.pvSecondaryMediumGrey()
                break
            case .small:
                largeProjectImageView.tintColor = UIColor.pvSecondaryMediumGrey()
                smallProjectImageView.tintColor = UIColor.pvPrimaryDarkGrey()
                break
            }
            
            if selectedRepresentation != oldValue {
                representationButtonPressed?(selectedRepresentation)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        if self.subviews.count == 0 {
            return loadNib()
        }
        return self
    }
    
    fileprivate func loadNib() -> ProductsSortingView {
        return UINib(nibName: "ProductsSortingView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ProductsSortingView
    }
    
    @IBAction func didPressSortingButton() {
        sortingButtonPressed?()
    }
    
    @IBAction func didPressLargeRepresentationButton() {
        selectedRepresentation = .large
    }
    
    @IBAction func didPressSmallRepresentationButton() {
        selectedRepresentation = .small
    }
    
}
