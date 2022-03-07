//
//  NewAddressViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 03/03/22.
//

import UIKit

class NewAddressViewController: UIViewController {

    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var landMarkField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    
    init() {
        super.init(nibName: "NewAddressViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customiseNavbar()
    }

    @IBAction func addAddressTapped(_ sender: UIButton) {
        // Add Address to User Defaults
        
        
        self.navigationController?.popViewController(animated: true)
    }
 
    // Error Alert Function
    func showErrorAlert(error: String?) {
        let alertVc = UIAlertController(title: "Something went wrong!", message: error, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
    
    // Customise Navbar
    func customiseNavbar() {
        // Set Title
        self.title = "Add Address"
        
        // Customise Naviagtion Bar
        self.navigationController?.navigationBar.barTintColor = .mainRed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Customise Back Button Color & Title
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
    }
}
