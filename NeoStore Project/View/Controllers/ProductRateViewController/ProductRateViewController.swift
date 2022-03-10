//
//  ProductRateViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 01/03/22.
//

import UIKit

class ProductRateViewController: UIViewController {
    
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet var stars: [UIImageView]!
    
    // Variables
    var productId: Int!
    var productImgStrUrl: String!
    var productName: String!
    var viewModel: ProductRateViewType!
    var delegate: ProductBuyViewControllerDelegate?
    var rating: Int = 3
    var loaderViewScreen: UIView?
    
    init(productId: Int, productImgStrUrl: String, productName: String, viewModel: ProductRateViewType) {
        self.viewModel = viewModel
        self.productId = productId
        self.productImgStrUrl = productImgStrUrl
        self.productName = productName
        super.init(nibName: "ProductRateViewController", bundle: nil)
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
        addTapGesture(imgViews: stars)
        
        paintStars(curRating: rating)
        setupObservers()
    }
    
    func paintStars(curRating: Int) {
        for i in 1...5 {
            if i <= rating {
                stars[i-1].image = UIImage(named: "star_check")
            } else {
                stars[i-1].image = UIImage(named: "star_unchek")
            }
        }
    }

    // Tap Gesture
    func addTapGesture(view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func addTapGesture(imgViews: [UIImageView]) {
        for imgView in imgViews {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imgViewTapped(_:)))
            imgView.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imgViewTapped(_ sender: UITapGestureRecognizer) {
        if let senderView = sender.view as? UIImageView {
            if let newRating = stars.firstIndex(of: senderView) {
                rating = newRating + 1
                paintStars(curRating: rating)
            }
        }
    }
    
    @IBAction func senderBtnTapped(_ sender: UIButton) {
        self.viewModel.rateProduct(productId: String(productId), rating: rating)
        showLoader(view: self.view, aicView: &loaderViewScreen)
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.productRateDetailStatus.bindAndFire { [weak self] (value) in
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
}

extension ProductRateViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
