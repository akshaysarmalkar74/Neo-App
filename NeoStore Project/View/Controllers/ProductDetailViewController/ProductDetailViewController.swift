//
//  ProductDetailViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 28/02/22.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var viewModel: ProductDetailViewType!
    var productId: String!
    var curProduct: [String: Any]?
    var loaderViewScreen: UIView?
    
    init(viewModel: ProductDetailViewType, productId: String) {
        super.init(nibName: "ProductDetailViewController", bundle: nil)
        self.viewModel = viewModel
        self.productId = productId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        showLoader(view: self.view, aicView: &loaderViewScreen)
        
        // Register Cell
        tableView.register(UINib(nibName: "ProductDetailHeader", bundle: nil), forCellReuseIdentifier: "ProductDetailHeader")
        tableView.register(UINib(nibName: "ProductDetailBody", bundle: nil), forCellReuseIdentifier: "ProductDetailBody")
        tableView.register(UINib(nibName: "ProductDetailFooter", bundle: nil), forCellReuseIdentifier: "ProductDetailFooter")
        
        // Get Data
        viewModel.fetchProductDetails(productId: productId)
        
        // Set Observers
        setupObservers()
        
        tableView.tableFooterView = UIView()
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.fetchProductDetailStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success(let product):
                self.curProduct = product
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.tableView.reloadData()
                }
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showErrorAlert(msg: msg)
                }
            case .none:
                break
            }
        }
    }
    
    // Error Alert Function
    func showErrorAlert(msg: String?) {
        let alertVc = UIAlertController(title: "Something went wrong!", message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
            self?.navigationController?.popViewController(animated: true)
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
    
    // Show Success Alert
    func showSuccessAlert(msg: String?) {
        let alertVc = UIAlertController(title: "Success!!", message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
    
    func convertIdToCategory(categoryId: Int) -> String {
        let categories = ["Tables", "Sofa", "Chair", "CupBoards"]
        if categoryId < categories.count {
            return categories[categoryId]
        }
        return ""
    }
    @IBAction func buyNowTapped(_ sender: Any) {
        // Get Id, Name and Image URL
        let images = self.curProduct?["product_images"] as? [[String: Any]] ?? [[String: Any]]()
        let name = self.curProduct?["name"] as? String ?? ""
        let id = self.curProduct?["id"] as? Int
        
        if let mainImgUrl = images[0]["image"] as? String, let mainId = id {
            let viewModel = ProductBuyViewModel()
            let vc = ProductBuyViewController(productId: mainId, productImgStrUrl: mainImgUrl, productName: name, viewModel: viewModel)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func rateNowTapped(_ sender: Any) {
        // Get Id, Name and Image URL
        let images = self.curProduct?["product_images"] as? [[String: Any]] ?? [[String: Any]]()
        let name = self.curProduct?["name"] as? String ?? ""
        let id = self.curProduct?["id"] as? Int
        
        if let mainImgUrl = images[0]["image"] as? String, let mainId = id {
            let viewModel = ProductRateViewModel()
            let vc = ProductRateViewController(productId: mainId, productImgStrUrl: mainImgUrl, productName: name, viewModel: viewModel)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailHeader", for: indexPath) as! ProductDetailHeader
            cell.selectionStyle = .none
            
            // Configure Header
            let name = self.curProduct?["name"] as? String ?? ""
            let provider = self.curProduct?["producer"] as? String ?? ""
            let rating = self.curProduct?["rating"] as? Int ?? 0
            
            let categoryId = self.curProduct?["product_category_id"] as? Int ?? 0
            let category = convertIdToCategory(categoryId: categoryId)
            
            
            cell.configure(name: name, category: category, provider: provider, rating: rating)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailBody", for: indexPath) as! ProductDetailBody
            cell.selectionStyle = .none
            
            // Configure Header
            let price = self.curProduct?["cost"] as? Int ?? 0
            let description = self.curProduct?["description"] as? String ?? ""
            let images = self.curProduct?["product_images"] as? [[String: Any]] ?? [[String: Any]]()

            // Set Other Images
            cell.allImages = images
            
            // Configure Cell
            cell.configureCell(price: price, description: description)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailFooter", for: indexPath) as! ProductDetailFooter
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ProductDetailViewController: ProductDetailFooterDelegate {
    func didTapBuyNow() {
        // Get Id, Name and Image URL
        let images = self.curProduct?["product_images"] as? [[String: Any]] ?? [[String: Any]]()
        let name = self.curProduct?["name"] as? String ?? ""
        let id = self.curProduct?["id"] as? Int
        
        if let mainImgUrl = images[0]["image"] as? String, let mainId = id {
            let viewModel = ProductBuyViewModel()
            let vc = ProductBuyViewController(productId: mainId, productImgStrUrl: mainImgUrl, productName: name, viewModel: viewModel)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    func didTapRateBtn() {
        // Get Id, Name and Image URL
        let images = self.curProduct?["product_images"] as? [[String: Any]] ?? [[String: Any]]()
        let name = self.curProduct?["name"] as? String ?? ""
        let id = self.curProduct?["id"] as? Int
        
        if let mainImgUrl = images[0]["image"] as? String, let mainId = id {
            let viewModel = ProductRateViewModel()
            let vc = ProductRateViewController(productId: mainId, productImgStrUrl: mainImgUrl, productName: name, viewModel: viewModel)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ProductDetailViewController: ProductBuyViewControllerDelegate {
    
    func didReceiveResponse(userMsg: String?) {
        self.viewModel.fetchProductDetails(productId: self.productId)
        showSuccessAlert(msg: userMsg)
    }
}
