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
        setup()
        setupObservers()
    }

    @IBAction func addAddressTapped(_ sender: UIButton) {
        // Add Address to User Defaults
        self.view.endEditing(true)
        self.viewModel.addNewAddress()
        showLoader(view: self.view, aicView: &loaderViewScreen)
    }
    
    // Setuo
    func setup() {
        let textFields: [UITextField] = [landMarkField, cityField, stateField, zipCodeField, countryField]
        
        for textField in textFields {
            textField.delegate = self
        }
        addressField.delegate = self
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
}

extension NewAddressViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.saveTextFromTextField(text: textField.text, tag: textField.tag)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.viewModel.saveTextFromTextField(text: textView.text, tag: textView.tag)
    }
}
