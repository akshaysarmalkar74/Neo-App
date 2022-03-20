//
//  SideMenuViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 23/02/22.
//

import UIKit

protocol SideMenuViewControllerDelegate: AnyObject {
    func didTapMenuItem(vcAttr: SideMenuControllerNames)
}

class SideMenuViewController: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    weak var customDelegate: SideMenuViewControllerDelegate?
    var viewModel: SideMenuViewType!
    
    init(viewModel: SideMenuViewType) {
        self.viewModel = viewModel
        super.init(nibName: StringConstants.SideMenuController, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(StringConstants.SideMenuController) was deleted")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.00)
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.00)
        
        tableView.register(UINib(nibName: "SideMenuControllerHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SideMenuControllerHeader")
        tableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        
        
        // Setup Observers
        setupObservers()
        
        // Get User & Carts
        self.viewModel.getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchAccount()
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.tableViewShouldReload.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            if value {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
}


extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getTotalNumOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        let totalNumOfCarts = self.viewModel.getTotalNumOfCarts()
        if indexPath.row == 0 && totalNumOfCarts != 0 {
            cell.configure(img: self.viewModel.itemImages[indexPath.row], name: self.viewModel.itemNames[indexPath.row], num: totalNumOfCarts)
        } else {
            cell.configure(img: self.viewModel.itemImages[indexPath.row], name: self.viewModel.itemNames[indexPath.row], num: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuControllerHeader") as! SideMenuControllerHeader
        let backgroundView = UIView(frame: headerView.bounds)
        backgroundView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.00)
        headerView.backgroundView =  backgroundView
        
        
        // Configure Header
        let firstName = self.viewModel.user.firstName ?? ""
        let lastName = self.viewModel.user.lastName ?? ""
        let email = self.viewModel.user.email ?? ""
        
        headerView.configure(firstName: firstName, lastName: lastName, userEmail: email)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 199.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.customDelegate?.didTapMenuItem(vcAttr: .MyCart)
        case 1:
            self.customDelegate?.didTapMenuItem(vcAttr: .Tables)
        case 2:
            self.customDelegate?.didTapMenuItem(vcAttr: .Sofas)
        case 3:
            self.customDelegate?.didTapMenuItem(vcAttr: .Chair)
        case 4:
            self.customDelegate?.didTapMenuItem(vcAttr: .Cupboard)
        case 5:
            self.customDelegate?.didTapMenuItem(vcAttr: .MyAccount)
        case 6:
            self.customDelegate?.didTapMenuItem(vcAttr: .StoreLocator)
        case 7:
            self.customDelegate?.didTapMenuItem(vcAttr: .MyOrders)
        case 8:
            self.customDelegate?.didTapMenuItem(vcAttr: .Logout)
        default:
            break
        }
    }
}
