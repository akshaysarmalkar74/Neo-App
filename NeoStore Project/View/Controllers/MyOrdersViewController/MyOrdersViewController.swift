//
//  MyOrdersViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import UIKit

class MyOrdersViewController: UIViewController {

    // MARK:- Outlets and Variables
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MyOrdersViewType!
    var loaderViewScreen: UIView?
    
    init(viewModel: MyOrdersViewType) {
        self.viewModel = viewModel
        super.init(nibName: StringConstants.MyOrdersViewController, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupObservers()
        
        showLoader(view: self.view, aicView: &loaderViewScreen)
        
        // Register Table View Cell
        tableView.register(UINib(nibName: "MyOrderCell", bundle: nil), forCellReuseIdentifier: "MyOrderCell")
        tableView.separatorStyle = .none
        
        // fetch Orders
        viewModel.fetchOrders()
        
        customiseNavbar(title: "My Orders", vcType: StringConstants.MyOrdersViewController, btnSelector: nil)
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.fetchOrdersStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.MyOrdersViewController, shouldPop: false)
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
//    func customiseNavbar() {
//        // Set Title
//        self.title = "My Orders"
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

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        let item = self.viewModel.getItemAtIndec(idx: indexPath.row)
        
//      cell.configureCell(id: id, cost: cost, created: created)
        cell.configureCell(item: item)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.viewModel.getItemAtIndec(idx: indexPath.row)
        let orderId = item.id ?? 0
        
        // Create View Controller
        let viewModel = OrderDetailViewModel()
        let vc = OrderDetailViewController(viewModel: viewModel, orderId: orderId)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
