//
//  CartListViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import UIKit

class CartListViewController: UIViewController, CartListSectionFooterDelegate {
    func didTappedOrderButton() {
        let viewModel = AddressListViewModel()
        let vc = AddressListViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // Outlets
    @IBOutlet weak var cartTable: UITableView!
    
    // Variables
    var viewModel: CartListViewType!
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 5
    var loaderViewScreen: UIView?
    
    init(viewModel: CartListViewType) {
        super.init(nibName: StringConstants.CartListViewController, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Observers
        setupObservers()
        customiseNavbar()
        
        cartTable.delegate = self
        cartTable.dataSource = self
        cartTable.register(UINib(nibName: "CartProductCell", bundle: nil), forCellReuseIdentifier: "CartListCell")
        cartTable.register(UINib(nibName: "CartPageTotalCell", bundle: nil), forCellReuseIdentifier: "CartPageTotalCell")
        cartTable.register(UINib(nibName: "CartListSectionFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "CartListSectionFooter")
        
        // Fetch Carts
        showLoader(view: self.view, aicView: &loaderViewScreen)
        self.viewModel.fetchCart()
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.fetchCartStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.cartTable.isHidden = true
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
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.cartTable.reloadData()
                }
            }
        }
        
    }
    
    // Success Alert Function
    func showSuccessAlert(msg: String?) {
        let alertVc = UIAlertController(title: "Password has been sent to your email!", message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
            self?.navigationController?.popViewController(animated: true)
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
    
    // Error Alert Function
    func showErrorAlert(msg: String?) {
        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
            self?.navigationController?.popViewController(animated: true)
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
    
    // Customise Navigation Bar
    func customiseNavbar() {
        // Set Title
        self.title = "My Cart"
        
        // Customise Naviagtion Bar
        self.navigationController?.navigationBar.barTintColor = .mainRed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Customise Back Button Color & Title
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
    }

    
}

extension CartListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as! CartProductCell
            cell.delegate = self
            cell.selectionStyle = .none
            
            let cartItem = self.viewModel.getItemAndIndexPath(index: indexPath.row)
            if let productDetails = cartItem.product {
                // Configure Cell
                cell.configure(productDetails: productDetails, cartItem: cartItem)
            } else {
                print("Unable to Fetch info about product")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartPageTotalCell", for: indexPath) as! CartPageTotalCell
            cell.selectionStyle = .none
            cell.priceLabel.text = "₹  \(viewModel.getTotalPrice())"
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.getNumOfRows()
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.viewModel.getNumOfRows() > 0 && section == 1 {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CartListSectionFooter") as! CartListSectionFooter
            footerView.delegate = self
            
            let backgroundView = UIView(frame: footerView.bounds)
            backgroundView.backgroundColor = UIColor.white
            footerView.backgroundView =  backgroundView
            
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 67.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.viewModel.getNumOfRows() > 0 && section == 1 {
            return 67.0
        }
        return 0
    }
    
    // Delete Item
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cartItem = self.viewModel.getItemAndIndexPath(index: indexPath.row)
        let productId = cartItem.product?.id ?? 0
        
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, _ in
            self?.showDeleteAlert(productId: productId)
        }
        
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = UIColor.white
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func showDeleteAlert(productId: Int) {
        let alertVc = UIAlertController(title: nil, message: "Are you sure you want to delete?", preferredStyle: .alert)
        let deleteBtn = UIAlertAction(title: "Yes", style: .default) { [weak self] deleteAction in
            self?.viewModel.deleteCart(productId: "\(productId)")
        }
        
        let cancelBtn = UIAlertAction(title: "No", style: .default) { [weak self] cancelAction in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alertVc.addAction(deleteBtn)
        alertVc.addAction(cancelBtn)
        
        self.present(alertVc, animated: true)
    }
    
}

extension CartListViewController: CartEditButtonDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func didTapEditBtn(id: Int, quantity: String?) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        if let curQty = Int(quantity ?? "") {
            pickerView.selectRow(curQty - 1, inComponent: 0, animated: false)
        }

        vc.view.addSubview(pickerView)
        
        let alert = UIAlertController(title: "Update Quantity", message: "", preferredStyle: .actionSheet)
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { [weak self] (UIAlertAction) in
            if let updatedQuantityNum = self?.viewModel.getSelectedRow() {
                // Call API
                self?.viewModel.editCart(productId: "\(id)", quantity: updatedQuantityNum)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.numOfQuantityItems()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.viewModel.itemAtIndexInQuantity(idx: row))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.selectedRow = row + 1
    }
    
}
