//
//  ForgotScreenViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 09/02/22.
//

import UIKit

class ForgotScreenViewController: UIViewController {

    // MARK:- Outlet & ViewModel
    @IBOutlet weak var emailField: UITextField!
    var viewModel: ForgotScreenViewType!
    
    init(viewModel: ForgotScreenViewType) {
        super.init(nibName: StringConstants.forgotViewController, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupObservers()
        // Do any additional setup after loading the view.
    }

    @IBAction func sendBtnTapped(_ sender: UIButton) {
        let emailResult = Validator.email(str: emailField.text ?? "")
        if emailResult.result {
            viewModel.forgotPassword(email: emailField.text!)
        } else {
            showErrorAlert(msg: emailResult.message)
        }
    }
    
    // Error Alert Function
    func showErrorAlert(msg: String?) {
        let alertVc = UIAlertController(title: "Something went wrong!", message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
    
    // Success Alert Function
    func showSuccessAlert(msg: String?) {
        let alertVc = UIAlertController(title: "Password has been reset!", message: msg, preferredStyle: .alert)
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

extension ForgotScreenViewController {
    func setUp() {
        // Set Border Width to Input
        emailField.layer.borderWidth = 1.0
        
        // Set Border Color to Input
        emailField.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // Add gestures
        addTapGestureToView()
        
        // Customise Text Fields
        customiseTextField(textField: emailField, imgName: "email_icon")
        
        // Customise Navbar
        customiseNavbar()
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.userForgotStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success(let msg):
                DispatchQueue.main.async {
                    self.showSuccessAlert(msg: msg)
                }
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.showErrorAlert(msg: msg)
                }
            case .none:
                break
            }
        }
    }
    
    // Customise Text Fields
    func customiseTextField(textField: UITextField, imgName: String) {
        
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 24.0, height: 24.0))
        let image = UIImage(named: imgName)
        imageView.image = image
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.red

        // Create Container View
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 40))
        view.addSubview(imageView)
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = view
    }
    
    // Add Tap Gesture to View
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Customise Navbar
    func customiseNavbar() {
        // Set Title
        self.title = "Forgot Password"
        
        // Customise Naviagtion Bar
        let height: CGFloat = 40
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        self.navigationController?.navigationBar.barTintColor = .mainRed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Customise Back Button Color & Title
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
