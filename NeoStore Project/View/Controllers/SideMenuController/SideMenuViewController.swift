//
//  SideMenuViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 23/02/22.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func didTapMenuItem(vcAttr: SideMenuControllerNames)
}

class SideMenuViewController: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    let itemNames = ["My Cart", "Tables", "Sofas", "Chair", "Cupboards", "My Account", "Store Locator", "My Orders", "Logout"]
    let itemImages = ["shoppingcart_icon", "tables_icon", "sofa_icon", "chair", "cupboard_icon", "username_icon", "storelocator_icon", "myorders_icon", "logout_icon"]
    var user: UserData!
    var customDelegate: SideMenuViewControllerDelegate?
    var totalNumOfCarts: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1.00)
        
        tableView.register(UINib(nibName: "SideMenuControllerHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SideMenuControllerHeader")
        tableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        
        
        // Get User
        user = UserDefaults.standard.getUserInstance()
        
        print(totalNumOfCarts)
    }

}


extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        if indexPath.row == 0 {
            cell.configure(img: itemImages[indexPath.row], name: itemNames[indexPath.row], num: 2)
        } else {
            cell.configure(img: itemImages[indexPath.row], name: itemNames[indexPath.row], num: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuControllerHeader") as! SideMenuControllerHeader
        let backgroundView = UIView(frame: headerView.bounds)
        backgroundView.backgroundColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1.00)
        headerView.backgroundView =  backgroundView
        
        
        // Configure Header
        let firstName = user.firstName ?? ""
        let lastName = user.lastName ?? ""
        let email = user.email ?? ""
        
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
