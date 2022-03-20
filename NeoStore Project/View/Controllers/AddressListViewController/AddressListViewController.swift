//
//  AddressListViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 23/02/22.
//

import UIKit

class AddressListViewController: UIViewController {

    @IBOutlet weak var contentHidderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var viewModel: AddressListViewType!
    var loaderViewScreen: UIView?
    
    init(viewModel: AddressListViewType) {
        super.init(nibName: StringConstants.AddressListViewController, bundle: nil)
        self.viewModel = viewModel
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
        tableView.register(UINib(nibName: "AddressListViewFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "AddressListViewFooter")
        
        setUpObservers()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch All Address
        self.viewModel.fetchAddress()
        
        let allAddress = self.viewModel.getAllAddress()
        // Show/Hide Table View
        if allAddress.isEmpty {
            contentHidderView.isHidden = false
        } else {
            contentHidderView.isHidden = true
        }
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
    
    func setUpObservers() {
        self.viewModel.placeOrderStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.AddressListViewController, shouldPop: false)
                }
            case .none:
                break
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.AddressListViewController, shouldPop: false)
                }
            }
        }
    }
    
    // Success Alert Function
//    func showSuccessAlert(msg: String?) {
//        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
//        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
//            self?.dismiss(animated: true, completion: nil)
//
//            for controller in (self?.navigationController!.viewControllers)! as Array {
//                if controller.isKind(of: ProductHomeViewController.self) {
//                    self?.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//        }
//
//        // Add Button to Alert
//        alertVc.addAction(alertBtn)
//
//        // Present Alert
//        self.present(alertVc, animated: true, completion: nil)
//    }
    
    // Error Alert Function
//    func showErrorAlert(msg: String?) {
//        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
//        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
//            self?.dismiss(animated: true, completion: nil)
//
//            for controller in (self?.navigationController!.viewControllers)! as Array {
//                if controller.isKind(of: ProductHomeViewController.self) {
//                    self?.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//        }
//
//        // Add Button to Alert
//        alertVc.addAction(alertBtn)
//
//        // Present Alert
//        self.present(alertVc, animated: true, completion: nil)
//    }
}


extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getTotalNumOfAddress()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell", for: indexPath) as! AddressListCell
        cell.selectionStyle = .none
        
        let user = self.viewModel.getCurUser()
        // Configure Cell
        let firstName = user?.firstName ?? ""
        let lastName = user?.lastName ?? ""
        let address = self.viewModel.getAddressAtRow(idx: indexPath.row)
        let fullName = "\(firstName) \(lastName)"
        
        if indexPath.row == self.viewModel.getCurSelectedIdx() {
            cell.configureCell(name: fullName, address: address, isChecked: true)
        } else {
            cell.configureCell(name: fullName, address: address, isChecked: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddressListViewFooter") as! AddressListViewFooter
        footerView.delegate = self
        
        let backgroundView = UIView(frame: footerView.bounds)
        backgroundView.backgroundColor = UIColor.white
        footerView.backgroundView =  backgroundView
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let oldIdx = self.viewModel.getCurSelectedIdx()
        self.viewModel.currentSelectedIdx = indexPath.row
        tableView.reloadRows(at: [IndexPath(row: oldIdx, section: 0), IndexPath(row: self.viewModel.getCurSelectedIdx(), section: 0)], with: .none)
    }
    
}


extension AddressListViewController: AddressListViewFooterDelegate {
    func didTapppedOrderBtn() {
        let selectedAddress = self.viewModel.getAddressAtRow(idx: self.viewModel.currentSelectedIdx)
        showLoader(view: self.view, aicView: &loaderViewScreen)
        self.viewModel.placeOrder(address: selectedAddress)
    }
}
