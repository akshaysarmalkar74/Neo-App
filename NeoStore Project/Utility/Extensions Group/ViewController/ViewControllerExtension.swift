//
//  ViewControllerExtension.swift
//  NeoStore Project
//
//  Created by Neosoft on 09/03/22.
//

import Foundation
import UIKit

extension UIViewController {

    func showLoader(view: UIView, aicView: inout UIView?) {
        let parentView = UIView(frame: view.bounds)
        parentView.isUserInteractionEnabled = false
        parentView.backgroundColor = UIColor.black
        parentView.alpha = 0.3
        
        let aic = UIActivityIndicatorView(style: .large)
        aic.color = .white
        aic.startAnimating()
        
        parentView.addSubview(aic)
        view.addSubview(parentView)
        aic.center = view.center
        
        // Assign view to
        aicView = parentView
    }
    
    func hideLoader(viewLoaderScreen: UIView?) {
        viewLoaderScreen?.removeFromSuperview()
    }
}
