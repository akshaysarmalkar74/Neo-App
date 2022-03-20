//
//  OrderDetailViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 22/02/22.
//

import UIKit

class OrderDetailViewController: UIViewController {

    // MARK:- Outlets & Variables
    @IBOutlet weak var tableView: UITableView!
    var viewModel: OrderDetailViewType!
    var loaderViewScreen: UIView?
    
    init(viewModel: OrderDetailViewType) {
        super.init(nibName: StringConstants.OrderDetailViewController, bundle: nil)
        self.viewModel = viewModel
    }
    
    deinit {
        print("\(StringConstants.OrderDetailViewController) was deleted")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Delegate and DataSource
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // Set Observers
        setupObservers()
        customiseNavbar(title: "Order ID: \(self.viewModel.getPageTitle())", vcType: StringConstants.OrderDetailViewController, btnSelector: nil)
        
        // Register Cell
        tableView.register(UINib(nibName: "OrderDetailCell", bundle: nil), forCellReuseIdentifier: "OrderDetailCell")
        tableView.register(UINib(nibName: "OrderDetailFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "OrderDetailFooter")
        
        // Get Order
        showLoader(view: self.view, aicView: &loaderViewScreen)
        self.viewModel.getOrderWith()
    }

    // Setup Observers
    func setupObservers() {
        self.viewModel.orderDetailStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.OrderDetailViewController, shouldPop: false)
                }
            case .none:
                break
            }
        }
        
        self.viewModel.tableViewShouldReload.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            if value {
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // Error Alert Function
//    func showErrorAlert(msg: String?) {
//        let alertVc = UIAlertController(title: "Something went wrong!", message: msg, preferredStyle: .alert)
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
    
    // Customise Navigation Bar
//    func customiseNavbar(orderId: Int) {
//        // Set Title
//        self.title = "Order Id: \(orderId)"
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

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
        let product = self.viewModel.getItemAndIndexPath(index: indexPath.row)
        
        cell.configure(product: product)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OrderDetailFooter") as! OrderDetailFooter
        
        let backgroundView = UIView(frame: footerView.bounds)
        backgroundView.backgroundColor = UIColor.white
        footerView.backgroundView =  backgroundView
        
        footerView.priceLabel.text = "₹ \(viewModel.getTotalPrice())"
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 67.0
    }
}
