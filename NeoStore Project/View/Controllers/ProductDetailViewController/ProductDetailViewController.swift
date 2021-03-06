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
    var loaderViewScreen: UIView?
    @IBOutlet weak var contentHidderView: UIView!
    
    init(viewModel: ProductDetailViewType) {
        super.init(nibName: StringConstants.ProductDetailViewController, bundle: nil)
        self.viewModel = viewModel
    }
        
    deinit {
        print("\(StringConstants.ProductDetailViewController) was deleted")
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        showLoader(view: self.view, aicView: &loaderViewScreen)
        
        // Register Cell
        tableView.register(UINib(nibName: "ProductDetailHeader", bundle: nil), forCellReuseIdentifier: "ProductDetailHeader")
        tableView.register(UINib(nibName: "ProductDetailBody", bundle: nil), forCellReuseIdentifier: "ProductDetailBody")
        tableView.register(UINib(nibName: "ProductDetailFooter", bundle: nil), forCellReuseIdentifier: "ProductDetailFooter")
        
        // Get Data
        viewModel.fetchProductDetails()
        
        // Set Observers
        setupObservers()
        
        tableView.tableFooterView = UIView()
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.fetchProductDetailStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            let product = self.viewModel.getProduct()
            switch value {
            case .success:
                DispatchQueue.main.async {
                    self.contentHidderView.isHidden = true
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.customiseNavbar(title: product?.name ?? "", vcType: StringConstants.ProductDetailViewController, btnSelector: nil)
                    self.tableView.reloadData()
                }
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.ProductDetailViewController, shouldPop: true)
                }
            case .none:
                break
            }
        }
    }
    
    // Error Alert Function
//    func showErrorAlert(msg: String?) {
//        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
//        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
//            self?.dismiss(animated: true, completion: nil)
//            self?.navigationController?.popViewController(animated: true)
//        }
//
//        // Add Button to Alert
//        alertVc.addAction(alertBtn)
//
//        // Present Alert
//        self.present(alertVc, animated: true, completion: nil)
//    }
    
    // Show Success Alert
//    func showSuccessAlert(msg: String?) {
//        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
//        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
//            self?.dismiss(animated: true, completion: nil)
//        }
//
//        // Add Button to Alert
//        alertVc.addAction(alertBtn)
//
//        // Present Alert
//        self.present(alertVc, animated: true, completion: nil)
//    }
    
    func convertIdToCategory(categoryId: Int) -> String {
        let categories = ["Tables", "Sofa", "Chair", "CupBoards"]
        if categoryId < categories.count {
            return categories[categoryId]
        }
        return ""
    }
    @IBAction func buyNowTapped(_ sender: Any) {
        let product = self.viewModel.getProduct()
        
        // Get Id, Name and Image URL
        let images = product?.productImages ?? [ProductImage]()
        let name = product?.name ?? ""
        let id = product?.id
        
        if let mainImgUrl = images[0].image, let mainId = id {
            let viewModel = ProductBuyViewModel(productId: mainId, productImgStrUrl: mainImgUrl, productName: name)
            let vc = ProductBuyViewController(viewModel: viewModel)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func rateNowTapped(_ sender: Any) {
        let product = self.viewModel.getProduct()
        
        // Get Id, Name and Image URL
        let images = product?.productImages ?? [ProductImage]()
        let name = product?.name ?? ""
        let id = product?.id
        
        if let mainImgUrl = images[0].image, let mainId = id {
            let viewModel = ProductRateViewModel(productId: mainId, productImgStrUrl: mainImgUrl, productName: name)
            let vc = ProductRateViewController(viewModel: viewModel)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // Customise Navigation Bar
//    func customiseNavbar(pageTitle: String) {
//        // Set Title
//        self.title = pageTitle
//
//        // Customise Naviagtion Bar
//        self.navigationController?.navigationBar.barTintColor = .mainRed
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
//        // Customise Back Button Color & Title
//        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
//    }
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
            
            let product = self.viewModel.getProduct()
            // Configure Header
            let name = product?.name ?? ""
            let provider = product?.producer ?? ""
            let rating = product?.rating ?? 0
            
            let categoryId = product?.productCategoryID ?? 0
            let category = convertIdToCategory(categoryId: categoryId)
            
            
            cell.configure(name: name, category: category, provider: provider, rating: rating)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailBody", for: indexPath) as! ProductDetailBody
            cell.selectionStyle = .none
            cell.delegate = self
            
            let product = self.viewModel.getProduct()
            // Configure Header
            let price = product?.cost ?? 0
            let description = product?.dataDescription ?? ""
            let images = product?.productImages ?? [ProductImage]()

            // Set Other Images
            cell.allImages = images
            
            // Configure Cell
            cell.configureCell(price: price, description: description)
            
            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailFooter", for: indexPath) as! ProductDetailFooter
//            cell.delegate = self
//            cell.selectionStyle = .none
//            return cell
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

//extension ProductDetailViewController: ProductDetailFooterDelegate {
//    func didTapBuyNow() {
//        // Get Id, Name and Image URL
//        let images = self.curProduct?.productImages ?? [ProductImage]()
//        let name = self.curProduct?.name ?? ""
//        let id = self.curProduct?.id
//
//        if let mainImgUrl = images[0].image, let mainId = id {
//            let viewModel = ProductBuyViewModel()
//            let vc = ProductBuyViewController(productId: mainId, productImgStrUrl: mainImgUrl, productName: name, viewModel: viewModel)
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//            vc.delegate = self
//
//            self.present(vc, animated: true, completion: nil)
//        }
//
//
//    }
//
//    func didTapRateBtn() {
//        // Get Id, Name and Image URL
//        let images = self.curProduct?.productImages ?? [ProductImage]()
//        let name = self.curProduct?.name ?? ""
//        let id = self.curProduct?.id
//
//        if let mainImgUrl = images[0].image, let mainId = id {
//            let viewModel = ProductRateViewModel()
//            let vc = ProductRateViewController(productId: mainId, productImgStrUrl: mainImgUrl, productName: name, viewModel: viewModel)
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//            vc.delegate = self
//
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
//}

extension ProductDetailViewController: ProductBuyViewControllerDelegate, ShareButtonDelegate {
    func didTapShareBtn() {
        let product = self.viewModel.getProduct()
        
        let productName = product?.name ?? ""
        let productProducer = product?.producer ?? ""
        let productRating = product?.rating ?? 0
        
        let sharableText = """
        Name - \(productName)
        Producer - \(productProducer)
        Rating - \(productRating)
        """
        
        let items: [Any] = [sharableText]
        
        
        // Create Activity View Controller
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: [])
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func didReceiveResponse(userMsg: String?) {
        self.viewModel.fetchProductDetails()
        self.showAlert(msg: userMsg, vcType: StringConstants.ProductDetailViewController, shouldPop: false)
    }
    
    
}
