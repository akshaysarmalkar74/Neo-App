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
    @IBOutlet weak var plusIconContainer: UIView!
    
    var viewModel: LoginScreenViewType!
    var loaderViewScreen: UIView?
    
    init(viewModel: LoginScreenViewType) {
        self.viewModel = viewModel
        super.init(nibName: StringConstants.loginViewController, bundle: nil)
    }
    
    deinit {
        print("\(StringConstants.loginViewController) was deleted")
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
        self.view.endEditing(true)
        showLoader(view: self.view, aicView: &loaderViewScreen)
        viewModel.doLogin()
    }
    
    @IBAction func forgotBtnTapped(_ sender: UIButton) {
        
        // Create Alert with TextFields
        let alertVc = UIAlertController(title: "Forgot Password", message: "Please enter email", preferredStyle: .alert)
        
        alertVc.addTextField(configurationHandler: nil)
        alertVc.textFields?[0].tag = 3
        alertVc.textFields?[0].delegate = self
        
        let submitBtn = UIAlertAction(title: "Submit", style: .default) { action in
            self.view.endEditing(true)
            self.showLoader(view: self.view, aicView: &self.loaderViewScreen)
            self.viewModel.forgotPassword()
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertVc.addAction(submitBtn)
        alertVc.addAction(cancelBtn)
        
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
        
        // Set Delegates
        usernameField.delegate = self
        passwordField.delegate = self
        
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
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    let viewModel = ProductHomeViewModel()
                    let vc = ProductHomeViewController(viewModel: viewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.loginViewController, shouldPop: false)
                }
            case .none:
                break
            }
        }
        
        self.viewModel.userForgotStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.loginViewController, shouldPop: true)
                }
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.loginViewController, shouldPop: false)
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
        plusIconContainer.addGestureRecognizer(tapGesture)
    }
    
    @objc func plusIconTapped(_ sender: UITapGestureRecognizer) {
        let viewModel = RegisterScreenViewModel()
        navigationController?.pushViewController(RegisterScreenViewController(viewModel: viewModel), animated: true)
    }
    
}

extension LoginScreenViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.saveTextFromTextField(text: textField.text, tag: textField.tag)
    }
}
