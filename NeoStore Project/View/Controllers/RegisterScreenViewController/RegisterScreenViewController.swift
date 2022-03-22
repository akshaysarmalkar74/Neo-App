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
    var loaderViewScreen: UIView?
    
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
    
    deinit {
        print("\(StringConstants.registerViewController) was deleted")
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
        self.view.endEditing(true)
        
        // Set Gender and Terms Value
        let genderValue: String = maleBtn.isSelected ? "M" : "F"
        self.viewModel.setGenderValue(value: genderValue)
        self.viewModel.setTermsChecked(value: termsBtn.isSelected)
        
        // Make request
        self.viewModel.doRegister()
        showLoader(view: self.view, aicView: &loaderViewScreen)
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
            
            // Set Delegates
            textFields[idx].delegate = self
            
            // Customise Text Fields
            customiseTextField(textField: textFields[idx], imgName: inputImgs[idx])
        }
        
        // Add gestures
        addTapGestureToView()
        
        // Customise Navigation Bar
        customiseNavbar(title: "Register", vcType: StringConstants.registerViewController, btnSelector: nil)
        
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
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    let viewModel = ProductHomeViewModel()
                    let vc = ProductHomeViewController(viewModel: viewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showAlert(msg: msg, vcType: StringConstants.registerViewController, shouldPop: false)
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
}

extension RegisterScreenViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.saveTextFromTextField(text: textField.text, tag: textField.tag)
    }
}
