//
//  NewAddressViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 03/03/22.
//

import UIKit

class NewAddressViewController: UIViewController {

    @IBOutlet weak var addressField: UITextView!
    @IBOutlet weak var landMarkField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    
    // Variables
    var viewModel: NewAddressViewType!
    var loaderViewScreen: UIView?
    
    init(viewModel: NewAddressViewType) {
        super.init(nibName: StringConstants.NewAddressViewController, bundle: nil)
        self.viewModel = viewModel
    }
    
    deinit {
        print("\(StringConstants.NewAddressViewController) was deleted")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customiseNavbar(title: "Add Address", vcType: StringConstants.NewAddressViewController, btnSelector: nil)
        setupObservers()
    }

    @IBAction func addAddressTapped(_ sender: UIButton) {
        // Add Address to User Defaults
        self.viewModel.addNewAddress(address: addressField.text ?? "", landmark: landMarkField.text ?? "", city: cityField.text ?? "", zipCode: zipCodeField.text ?? "", state: stateField.text ?? "", country: countryField.text ?? "")
        
        showLoader(view: self.view, aicView: &loaderViewScreen)
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.saveAddressStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success:
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.NewAddressViewController, shouldPop: false)
                }
            case .none:
                break
            }
        }
    }
 
    // Error Alert Function
//    func showErrorAlert(error: String?) {
//        let alertVc = UIAlertController(title: "Something went wrong!", message: error, preferredStyle: .alert)
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
//
    // Customise Navbar
//    func customiseNavbar() {
//        // Set Title
//        self.title = "Add Address"
//
//        // Customise Naviagtion Bar
//        self.navigationController?.navigationBar.barTintColor = .mainRed
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
//        // Customise Back Button Color & Title
//        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
//
//    }
}
