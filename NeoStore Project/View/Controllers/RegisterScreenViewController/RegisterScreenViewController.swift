//
//  RegsiterScreenViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 03/02/22.
//

import UIKit

class RegisterScreenViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Variables
    var isKeyBoardExpanded: Bool = false
    var viewModel: RegisterScreenViewType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupObservers()
        
        // Set Notification Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    init(viewModel: RegisterScreenViewType) {
        self.viewModel = viewModel
        super.init(nibName: StringConstants.registerViewController, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func genderBtnTapped(_ sender: UIButton) {
        maleBtn.isSelected = false
        femaleBtn.isSelected = false
        
        // Select the tapped Btn
        sender.isSelected = true
    }
    
    @IBAction func termsBtnTapped(_ sender: UIButton) {
        termsBtn.isSelected = !termsBtn.isSelected
    }
    
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        // Get Validations Results
        let firstNameResult = Validator.firstName(str: firstNameField.text ?? "")
        let lastNameResult = Validator.lastName(str: lastNameField.text ?? "")
        let emailResult = Validator.email(str: emailField.text ?? "")
        let passwordResult = Validator.registerPassword(str: passwordField.text ?? "")
        let confirmPasswordResult = Validator.confirmPassword(password: passwordField.text ?? "", confirmPass: confirmPasswordField.text ?? "")
        let phoneResult = Validator.phoneNumber(str: phoneField.text ?? "")
        let termsResult = Validator.termsChecked(btn: termsBtn)
        
        // Check all Validations
        if firstNameResult.result && lastNameResult.result && emailResult.result && passwordResult.result && confirmPasswordResult.result && phoneResult.result && termsResult.result {
            let actualPhoneNum: Int = Int(phoneField.text!)!
            let genderValue: String = maleBtn.isSelected ? "M" : "F"
            
            viewModel.doRegister(firstName: firstNameField.text!, lastName: lastNameField.text!, email: emailField.text!, password: passwordField.text!, confirmPassword: confirmPasswordField.text!, gender: genderValue, phoneNumber: actualPhoneNum)
        } else if !firstNameResult.result {
            showErrorAlert(error: firstNameResult.message)
        } else if !lastNameResult.result {
            showErrorAlert(error: lastNameResult.message)
        } else if !emailResult.result {
            showErrorAlert(error: emailResult.message)
        } else if !passwordResult.result {
            showErrorAlert(error: passwordResult.message)
        } else if !confirmPasswordResult.result {
            showErrorAlert(error: confirmPasswordResult.message)
        } else if !phoneResult.result {
            showErrorAlert(error: phoneResult.message)
        } else {
            showErrorAlert(error: termsResult.message)
        }
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
    
    // KeyBoard Notification Functions
    @objc func keyboardAppeared(_ notification: Notification) {
        if !isKeyBoardExpanded {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height + keyboardHeight)
                isKeyBoardExpanded = true
            }
        }
    }
    
    @objc func keyboardDisappeared(_ notification: Notification) {
        if isKeyBoardExpanded {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height - keyboardHeight)
                isKeyBoardExpanded = false
            }
        }
    }
    
}

extension RegisterScreenViewController {
    func setUp() {
        let textFields: [UITextField] = [firstNameField, lastNameField, emailField, passwordField, confirmPasswordField, phoneField]
        let inputImgs: [String] = ["username_icon", "username_icon", "email_icon", "password_icon", "cpassword_icon", "cellphone_icon"]
        
        for idx in 0..<textFields.count {
            // Set Border Width to Input
            textFields[idx].layer.borderWidth = 1.0
            
            // Set Border Color to Input
            textFields[idx].layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            // Customise Text Fields
            customiseTextField(textField: textFields[idx], imgName: inputImgs[idx])
        }
        
        // Add gestures
        addTapGestureToView()
        
        // Customise Navigation Bar
        customiseNavbar()
        
        // Change Terms Label Text Color
        termsLabel.textColor = .white
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.userRegisterStatus.bindAndFire { [weak self] (value) in
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
    
    // Customise Navigation Bar
    func customiseNavbar() {
        // Set Title
        self.title = "Register"
        
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
    
    // Add Tap Gesture to View
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
