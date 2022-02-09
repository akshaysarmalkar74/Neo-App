//
//  LoginScreenViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 02/02/22.
//

import UIKit

class LoginScreenViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var plusIcon: UIImageView!
    
    var viewModel: LoginScreenViewType!
    
    init(viewModel: LoginScreenViewType) {
        self.viewModel = viewModel
        super.init(nibName: StringConstants.loginViewController, bundle: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func loginBtnTapped(_ sender: UIButton) {
        // Validate Email And Password
        let emailTuple = Validator.email(str: usernameField.text ?? "")
        let passwordTuple  = Validator.loginPassword(str: passwordField.text ?? "")
        
        if emailTuple.result && passwordTuple.result {
            viewModel.doLogin(username: usernameField.text!, password: passwordField.text!)
        } else if !emailTuple.result {
            // Show Alert for Email
            showErrorAlert(error: emailTuple.message)
        } else {
            // Show Alert for password
            showErrorAlert(error: passwordTuple.message)
        }
        
    }
    
    @IBAction func forgotBtnTapped(_ sender: Any) {
        print("Forgot Tapped")
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
    
}

extension LoginScreenViewController {
    func setUp() {
        // Set Border Width to Input
        usernameField.layer.borderWidth = 1.0
        passwordField.layer.borderWidth = 1.0
        
        // Set Border Color to Input
        usernameField.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        passwordField.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // Add gestures
        addTapGestureToView()
        addTapGestureToPlusIcon()
        
        // Customise Text Fields
        customiseTextField(textField: usernameField, imgName: "username_icon")
        customiseTextField(textField: passwordField, imgName: "password_icon")
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.userLoginStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success:
                DispatchQueue.main.async {
                    let vc = TestViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.showErrorAlert(error: msg)
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
    
    // Add tap gesture to Plus Icon
    func addTapGestureToPlusIcon() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(plusIconTapped(_:)))
        plusIcon.addGestureRecognizer(tapGesture)
    }
    
    @objc func plusIconTapped(_ sender: UITapGestureRecognizer) {
        let viewModel = RegisterScreenViewModel()
        navigationController?.pushViewController(RegisterScreenViewController(viewModel: viewModel), animated: true)
    }
}
