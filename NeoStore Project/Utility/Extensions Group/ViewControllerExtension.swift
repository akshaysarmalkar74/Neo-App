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
        let parentView = UIView(frame: UIScreen.main.bounds)
        parentView.isUserInteractionEnabled = false
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.3)
        containerView.layer.cornerRadius = 10
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        parentView.addSubview(containerView)
        containerView.center = parentView.center
        
        let aic = UIActivityIndicatorView(style: .large)
        aic.color = .gray
        aic.startAnimating()
        aic.center = parentView.center
        
        parentView.addSubview(aic)
        view.addSubview(parentView)
        
        // Assign view
        aicView = parentView
    }
    
    func hideLoader(viewLoaderScreen: UIView?) {
        viewLoaderScreen?.removeFromSuperview()
    }
    
    // Error Alert Function
    func showAlert(msg: String?, vcType: String, shouldPop: Bool) {
        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
            if shouldPop {
                self?.navigationController?.popViewController(animated: true)
            }
            
            // Special Case for AddressList Controller
            if vcType == "AddressListViewController" {
                for controller in (self?.navigationController!.viewControllers)! as Array {
                    if controller.isKind(of: ProductHomeViewController.self) {
                        self?.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
    
}
