//
//  ProductBuyViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 01/03/22.
//

import UIKit

protocol ProductBuyViewControllerDelegate {
    func didReceiveResponse(userMsg: String?)
}

class ProductBuyViewController: UIViewController {
    
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var qtyInput: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    // Variables
    var productId: Int!
    var productImgStrUrl: String!
    var productName: String!
    var viewModel: ProductBuyViewType!
    var delegate: ProductBuyViewControllerDelegate?
    
    init(productId: Int, productImgStrUrl: String, productName: String, viewModel: ProductBuyViewType) {
        self.viewModel = viewModel
        self.productId = productId
        self.productImgStrUrl = productImgStrUrl
        self.productName = productName
        super.init(nibName: "ProductBuyViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Values to Outlets
        self.productNameLbl.text = productName
        
        let url = URL(string: productImgStrUrl)
        if let actualUrl = url {
            let data = try? Data(contentsOf: actualUrl)
            if let actualData = data {
                productImg.image = UIImage(data: actualData)
            }
        }
        
        addTapGesture(view: view)
        setupObservers()
    }

    // Tap Gesture
    func addTapGesture(view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.productBuyDetailStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success(let msg), .failure(let msg):
                DispatchQueue.main.async {
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
        print("BTN Tapped")
        let qtyResult = Validator.validateQuantity(val: qtyInput.text ?? "")
        if qtyResult.result {
            viewModel.buyProduct(productId: String(productId), quantity: Int(qtyInput.text!)!)
        } else {
            // Show Error
            showAlert(msg: qtyResult.message)
        }
    }
    
    // Error Alert Function
    func showAlert(msg: String?) {
        let alertVc = UIAlertController(title: "Something went wrong!", message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
    
}

extension ProductBuyViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

