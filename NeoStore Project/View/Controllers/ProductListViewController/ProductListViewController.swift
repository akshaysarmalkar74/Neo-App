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
    var allProducts: [[String: Any]] = []
    var isPaginating: Bool = false
    var shouldPaginate: Bool = false
    
    init(categoryId: String, viewModel: ProductListViewType) {
        super.init(nibName: "ProductListViewController", bundle: nil)
        self.categoryId = categoryId
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Observers
        setupObservers()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListingCell")
        
        viewModel.fetchProducts(categoryId: categoryId, page: 1)
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.fetchProductsStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success(let data):
                self.allProducts.append(contentsOf: data)
                if data.count == 10 {
                    self.shouldPaginate = true
                } else {
                    self.shouldPaginate = false
                }
                self.isPaginating = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let msg):
                DispatchQueue.main.async {
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
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListingCell", for: indexPath) as! ProductListingTableViewCell
        let product = allProducts[indexPath.row]

        // Configure Data
        let imgName = product["product_images"] as? String ?? ""
        let name = product["name"] as? String ?? ""
        let desc = product["producer"] as? String ?? ""
        let price = product["cost"] as? Int ?? 0
        let rating = product["rating"] as? Int ?? 0
        
        cell.configureProduct(imgName: imgName, name: name, desc: desc, price: price, rating: rating)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
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
}