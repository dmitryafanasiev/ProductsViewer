//
//  ActivityView.swift
//  ProductsViewer
//

import UIKit

class ActivityView: UIView {
    static let sharedInstance = ActivityView.instanceFromNib()
    @IBOutlet weak fileprivate var whiteBackgroundView: UIView?
    
    class func instanceFromNib() -> ActivityView {
        let view =  UINib(nibName: "ActivityView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ActivityView
        view.whiteBackgroundView?.roundView(radius: 6)
        return view
    }
    
    class func show() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        let indicator = ActivityView.sharedInstance
        if indicator.superview == nil {
            indicator.frame = window.bounds
            window.addSubview(indicator)
        }
        indicator.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            indicator.alpha = 1.0
            }, completion: nil)
    }
    
    class func hide() {
        let indicator = ActivityView.sharedInstance
        if indicator.superview != nil {
            indicator.removeFromSuperview()
        }
    }
    
}
