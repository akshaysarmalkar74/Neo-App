//
//  CartListViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import UIKit

class CartListViewController: UIViewController {

    // Outlets
    @IBOutlet weak var cartTable: UITableView!
    
    // Variables
    var cartProducts = [[String: Any]]()
    var viewModel: CartListViewType!
    var selectedRow = 0
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 3
    let quantity = [1,2,3,4,5,6,7]
    
    init(viewModel: CartListViewType) {
        super.init(nibName: "CartListViewController", bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Observers
        setupObservers()
        
        cartTable.delegate = self
        cartTable.dataSource = self
        cartTable.register(UINib(nibName: "CartProductCell", bundle: nil), forCellReuseIdentifier: "CartListCell")
        cartTable.register(UINib(nibName: "CartListSectionFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "CartListSectionFooter")
        
        // Fetch Carts
        self.viewModel.fetchCart()
    }

    @IBAction func orderNowBtnTapped(_ sender: Any) {
        let vc = AddressListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.fetchCartStatus.bindAndFire { [weak self] (value) in
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
                    self.cartTable.reloadData()
                }
            }
        }
    }
    
    // Error Alert Function
    func showErrorAlert(msg: String?) {
        let alertVc = UIAlertController(title: "Something went wrong!", message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
            self?.navigationController?.popViewController(animated: true)
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
    
}

extension CartListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as! CartProductCell
        cell.delegate = self
        let cartItem = self.viewModel.getItemAndIndexPath(index: indexPath.row)
        let productDetails = cartItem["product"] as? [String: Any] ?? [String: Any]()
        
        // Configure Cell
        let name = productDetails["name"] as? String ?? ""
        let price = productDetails["sub_total"] as? Int ?? 0
        let category = productDetails["category"] as? String ?? ""
        let img = productDetails["product_images"] as? String ?? ""
        let id = productDetails["id"] as? Int ?? 0
        let quantity = cartItem["quantity"] as? Int ?? 0
        
        cell.configure(name: name, img: img, category: category, price: price, quantity: quantity, id: id)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.viewModel.getNumOfRows() > 0 {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CartListSectionFooter") as! CartListSectionFooter
            let backgroundView = UIView(frame: footerView.bounds)
            backgroundView.backgroundColor = UIColor.white
            footerView.backgroundView =  backgroundView
            
            footerView.priceLabel.text = "Rs - \(viewModel.getTotalPrice())"
            
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.viewModel.getNumOfRows() > 0 {
            return 67.0
        }
        return 0
    }
    
    // Delete Item
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cartItem = self.viewModel.getItemAndIndexPath(index: indexPath.row)
        let product = cartItem["product"] as? [String: Any] ?? [String: Any]()
        let productId = product["id"] as? Int ?? 0
        
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, _ in
            print(productId)
            self?.viewModel.deleteCart(productId: "\(productId)")
        }
        
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = UIColor.white
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension CartListViewController: CartEditButtonDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func didTapEditBtn(id: Int) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        
        let alert = UIAlertController(title: "Update Quantity", message: "", preferredStyle: .actionSheet)
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { [weak self] (UIAlertAction) in
            if let updatedQuantityNum = self?.selectedRow {
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
        return quantity.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(quantity[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row + 1
    }
    
}
