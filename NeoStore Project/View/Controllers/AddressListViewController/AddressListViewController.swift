//
//  AddressListViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 23/02/22.
//

import UIKit

class AddressListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var allAddress = [String]()
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
        tableView.register(UINib(nibName: "AddressListCell", bundle: nil), forCellReuseIdentifier: "AddressListCell")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allAddress = UserDefaults.standard.getAllAddress()
        tableView.reloadData()
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
        let viewModel = NewAddressViewModel()
        let vc = NewAddressViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func placeOrderBtnTapped(_ sender: UIButton) {
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
            cell.configureCell(name: fullName, address: address, isUnchecked: false)
        } else {
            cell.configureCell(name: fullName, address: address, isUnchecked: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let oldIdx = currentSelectedIdx
        currentSelectedIdx = indexPath.row
        tableView.reloadRows(at: [IndexPath(row: oldIdx, section: 0), IndexPath(row: currentSelectedIdx, section: 0)], with: .none)
    }
    
}
