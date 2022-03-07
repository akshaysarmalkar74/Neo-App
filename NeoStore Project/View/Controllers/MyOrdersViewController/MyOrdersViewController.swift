//
//  MyOrdersViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import UIKit

class MyOrdersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: MyOrdersViewType!
    
    init(viewModel: MyOrdersViewType) {
        self.viewModel = viewModel
        super.init(nibName: "MyOrdersViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupObservers()
        
        // Register Table View Cell
        tableView.register(UINib(nibName: "MyOrderCell", bundle: nil), forCellReuseIdentifier: "MyOrderCell")
        
        // fetch Orders
        viewModel.fetchOrders()
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.fetchOrdersStatus.bindAndFire { [weak self] (value) in
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

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        let item = self.viewModel.getItemAtIndec(idx: indexPath.row)
        
        // Configure Cell
        let id = item["id"] as? Int ?? 0
        let cost = item["cost"] as? Int ?? 0
        let created = item["created"] as? String ?? ""
        
        cell.configureCell(id: id, cost: cost, created: created)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.viewModel.getItemAtIndec(idx: indexPath.row)
        let orderId = item["id"] as? Int ?? 0
        
        // Create View Controller
        let viewModel = OrderDetailViewModel()
        let vc = OrderDetailViewController(viewModel: viewModel, orderId: orderId)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
