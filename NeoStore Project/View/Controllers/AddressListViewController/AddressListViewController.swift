//
//  AddressListViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 23/02/22.
//

import UIKit

class AddressListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let allAddress = UserDefaults.standard.getAllAddress()
    let user = UserDefaults.standard.getUser()
    var currentSelectedIdx = 0
    
    init() {
        super.init(nibName: "AddressListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customiseNavbar()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // Customise Navbar
    func customiseNavbar() {
        // Set Title
        self.title = "Select Address"
        
        // Customise Naviagtion Bar
        self.navigationController?.navigationBar.barTintColor = .mainRed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Customise Back Button Color & Title
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        let addNewBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newBtnTapped(_:)))
        self.navigationItem.rightBarButtonItem = addNewBtn
    }
    
    @objc func newBtnTapped(_ sender: UIBarButtonItem) {
        let vc = NewAddressViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell", for: indexPath) as! AddressListCell
        
        // Configure Cell
        let firstName = user["first_name"] as? String ?? ""
        let lastName = user["last_name"] as? String ?? ""
        let address = allAddress[indexPath.row]
        let fullName = "\(firstName) \(lastName)"
        
        if indexPath.row == currentSelectedIdx {
            cell.configureCell(name: fullName, address: address, isChecked: true)
        } else {
            cell.configureCell(name: fullName, address: address, isChecked: false)
        }
        
        return cell
    }
    
}
