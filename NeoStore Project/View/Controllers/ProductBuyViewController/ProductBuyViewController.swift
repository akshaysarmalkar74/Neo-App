//
//  ProductBuyViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 01/03/22.
//

import UIKit

protocol ProductBuyViewControllerDelegate: AnyObject {
    func didReceiveResponse(userMsg: String?)
}

class ProductBuyViewController: UIViewController {
    
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var qtyInput: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    
    // Variables
    var viewModel: ProductBuyViewType!
    weak var delegate: ProductBuyViewControllerDelegate?
    var isViewShifted = false
    var loaderViewScreen: UIView?
    
    init(viewModel: ProductBuyViewType) {
        self.viewModel = viewModel
        super.init(nibName: StringConstants.ProductBuyViewController, bundle: nil)
    }
    
    deinit {
        print("\(StringConstants.ProductBuyViewController) was deleted")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Values to Outlets
        self.productNameLbl.text = self.viewModel.getProductName()
        qtyInput.delegate = self
        
        let url = URL(string: self.viewModel.getProductImgStr())
        if let actualUrl = url {
            let data = try? Data(contentsOf: actualUrl)
            if let actualData = data {
                productImg.image = UIImage(data: actualData)
            }
        }
        
        // Add Border to Image
        productImg.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        productImg.layer.masksToBounds = true
        productImg.layer.borderWidth = 1
        
        addTapGesture(view: view)
        setupObservers()
        createToolBar()
    }

    // Tap Gesture to parent view
    func addTapGesture(view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // Tap Gesture to Container View
    func addTapGestureToContainerView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewTapped(_:)))
        tapGesture.delegate = self
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func containerViewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.productBuyDetailStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success(let msg), .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.didReceiveResponse(userMsg: msg)
                }
            case .none:
                break
            }
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Submit Btn Tapped
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewModel.buyProduct()
    }
    
    
    func createToolBar() {
         let toolBar = UIToolbar()
         toolBar.sizeToFit()
        
         // Bar Button
         let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
         toolBar.setItems([doneBtn], animated: true)
        
         // Assign ToolBar
         qtyInput.inputAccessoryView = toolBar
    }
    
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        let qtyResult = Validator.validateQuantity(val: qtyInput.text ?? "")
        if qtyResult.result {
            // Dismiss the keyboard
            self.view.endEditing(true)
            
            // Shift Container View Back to Original Position
            containerViewTopConstraint.constant += 70
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            isViewShifted = false
        } else {
            // Show Alert Message
            self.showAlert(msg: qtyResult.message, vcType: StringConstants.ProductBuyViewController, shouldPop: false)
        }
    }
    
}

extension ProductBuyViewController: UIGestureRecognizerDelegate, UITextFieldDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == containerView {
            if qtyInput.isFirstResponder {
                self.view.endEditing(true)
                containerViewTopConstraint.constant += 70
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                isViewShifted = false
            }
        }
        return touch.view == gestureRecognizer.view
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isViewShifted {
            containerViewTopConstraint.constant -= 70
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            isViewShifted = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.saveTextFromTextField(text: textField.text, tag: textField.tag)
    }
}

