//
//  ProductListViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 18/02/22.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var categoryId: String!
    var viewModel: ProductListViewType!
    var page = 1
    var isPaginating: Bool = false
    var shouldPaginate: Bool = false
    var screenLoaderScreen: UIView?
    var pageTitle: String!
    @IBOutlet weak var contentHidderView: UIView!
    
    init(categoryId: String, viewModel: ProductListViewType, title: String) {
        super.init(nibName: "ProductListViewController", bundle: nil)
        self.categoryId = categoryId
        self.viewModel = viewModel
        self.pageTitle = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader(view: self.view, aicView: &screenLoaderScreen)
        
        // Set Observers
        setupObservers()
        
        // Setup Navigation
        customiseNavbar(pageTitle: pageTitle)
        
        // Configure TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListingCell")
        tableView.separatorStyle = .none
        
        viewModel.fetchProducts(categoryId: categoryId, page: 1)
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.fetchProductsStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success:
                if self.viewModel.products.count % 10 == 0 {
                    self.shouldPaginate = true
                } else {
                    self.shouldPaginate = false
                }
                self.isPaginating = false
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.showErrorAlert(msg: msg)
                }
            case .none:
                break
            }
        }
        
        self.viewModel.tableViewShouldReload.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            if value {
                DispatchQueue.main.async {
                    self.contentHidderView.removeFromSuperview()
                    
                    self.hideLoader(viewLoaderScreen: self.screenLoaderScreen)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // Error Alert Function
    func showErrorAlert(msg: String?) {
        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListingCell", for: indexPath) as! ProductListingTableViewCell
        let product = self.viewModel.getItemAndIndexPath(index: indexPath.row)
        
        cell.configureProduct(product: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.getItemAndIndexPath(index: indexPath.row)
        let productId = product.id ?? 0
        let productDetailViewModel = ProductDetailViewModel()
        let vc = ProductDetailViewController(viewModel: productDetailViewModel, productId: String(productId))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            if !isPaginating && shouldPaginate {
                page += 1
                self.viewModel.fetchProducts(categoryId: categoryId, page: page)
                isPaginating = true
            }
        }
    }
    
    // Customise Navigation Bar
    func customiseNavbar(pageTitle: String) {
        // Set Title
        self.title = pageTitle
        
        // Customise Naviagtion Bar
        self.navigationController?.navigationBar.barTintColor = .mainRed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Customise Back Button Color & Title
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
