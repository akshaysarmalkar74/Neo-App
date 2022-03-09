//
//  ViewControllerExtension.swift
//  NeoStore Project
//
//  Created by Neosoft on 09/03/22.
//

import Foundation
import UIKit

extension UIViewController {

    func showLoader(view: UIView, aic: inout UIActivityIndicatorView?) {
        let parentView = UIView(frame: view.bounds)
        parentView.isUserInteractionEnabled = false
        parentView.backgroundColor = UIColor.black
        parentView.alpha = 0.3
        
        aic = UIActivityIndicatorView(style: .large)
        aic?.color = .white
        aic?.startAnimating()
        aic?.center = view.center
        
        if let actualAic = aic {
            parentView.addSubview(actualAic)
        }
        view.addSubview(parentView)
    }
    
    func hideLoader(viewLoader: UIActivityIndicatorView?) {
        viewLoader?.removeFromSuperview()
        viewLoader?.stopAnimating()
    }
}
