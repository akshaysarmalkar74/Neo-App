//
//  OrderDetailViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 22/02/22.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: OrderDetailViewType!
    var orderId: Int!
    
    init(viewModel: OrderDetailViewType, orderId: Int) {
        super.init(nibName: "OrderDetailViewController", bundle: nil)
        self.viewModel = viewModel
        self.orderId = orderId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Delegate and DataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set Observers
        setupObservers()
        
        // Register Cell
        tableView.register(UINib(nibName: "OrderDetailCell", bundle: nil), forCellReuseIdentifier: "OrderDetailCell")
        tableView.register(UINib(nibName: "CartListSectionFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "CartListSectionFooter")
        
        // Get Order
        self.viewModel.getOrderWith(id: orderId)
    }

    // Setup Observers
    func setupObservers() {
        self.viewModel.orderDetailStatus.bindAndFire { [weak self] (value) in
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.getNumOfRows())
        return viewModel.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
        let product = self.viewModel.getItemAndIndexPath(index: indexPath.row)
        
        // Configure Cell
        let img = product["prod_image"] as? String ?? ""
        let name = product["prod_name"] as? String  ?? ""
        let category = product["prod_cat_name"] as? String  ?? ""
        let quantity = product["quantity"] as? Int ?? 0
        let total = product["total"] as? Int ?? 0
        
        cell.configure(img: img, name: name, category: category, qty: quantity, price: total)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CartListSectionFooter") as! CartListSectionFooter
        
        let backgroundView = UIView(frame: footerView.bounds)
        backgroundView.backgroundColor = UIColor.white
        footerView.backgroundView =  backgroundView
        
//        footerView.priceLabel.text = "Rs - \(viewModel.getTotalPrice())"
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 67.0
    }
}
