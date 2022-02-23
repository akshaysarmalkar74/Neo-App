//
//  CartListViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import UIKit

class CartListViewController: UIViewController {

    @IBOutlet weak var cartTable: UITableView!
    var cartProducts = [[String: Any]]()
    var viewModel: CartListViewType!
    
    init(viewModel: CartListViewType) {
        super.init(nibName: "CartListViewController", bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Observers
        setupObservers()
        
        cartTable.delegate = self
        cartTable.dataSource = self
        cartTable.register(UINib(nibName: "CartProductCell", bundle: nil), forCellReuseIdentifier: "CartListCell")
        cartTable.register(UINib(nibName: "CartListFooterCell", bundle: nil), forCellReuseIdentifier: "CartListFooterCell")
        
        // Cell Height
        cartTable.rowHeight = UITableView.automaticDimension;
        cartTable.estimatedRowHeight = 90.0;
        
        // Fetch Carts
        self.viewModel.fetchCart()
    }

    @IBAction func orderNowBtnTapped(_ sender: Any) {
        print("Order Now Tapped")
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.fetchCartStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
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
                print("Hello")
                DispatchQueue.main.async {
                    self.cartTable.reloadData()
                }
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

extension CartListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.getNumOfItems() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as! CartProductCell
            let cartItem = self.viewModel.getItemAndIndexPath(index: indexPath.row)
            let productDetails = cartItem["product"] as? [String: Any] ?? [String: Any]()
            
            // Configure Cell
            let name = productDetails["name"] as? String ?? ""
            let price = productDetails["sub_total"] as? Int ?? 0
            let category = productDetails["category"] as? String ?? ""
            let img = productDetails["product_images"] as? String ?? ""
            let quantity = cartItem["quantity"] as? Int ?? 0
            
            cell.configure(name: name, img: img, category: category, price: price, quantity: quantity)
            
            return cell
        } else {
            let footerCell = tableView.dequeueReusableCell(withIdentifier: "CartListFooterCell", for: indexPath) as! CartListFooterCell
            footerCell.totalPrice.text = "\(viewModel.getTotalPrice())"
            return footerCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
