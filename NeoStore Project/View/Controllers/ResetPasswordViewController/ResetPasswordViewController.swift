//
//  ResetPasswordViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 10/02/22.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordConfirm: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Variables
    var isKeyBoardExpanded: Bool = false
    var viewModel: ResetPasswordScreenViewType!
    var loaderViewScreen: UIView?
    
    init(viewModel: ResetPasswordScreenViewType) {
        self.viewModel = viewModel
        super.init(nibName: StringConstants.ResetPasswordViewController, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupObservers()
        
        // Set Notification Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func resetBtnTapped(_ sender: UIButton) {
        self.viewModel.reset(password: newPassword.text ?? "", confirmPassword: newPasswordConfirm.text ?? "", oldPassword: currentPassword.text ?? "")
        
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
    
    // Error Alert Function
//    func showErrorAlert(msg: String?) {
//        self.hideLoader(viewLoaderScreen: loaderViewScreen)
//
//        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
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
    
    // Success Alert Function
//    func showSuccessAlert(msg: String?) {
//        self.hideLoader(viewLoaderScreen: loaderViewScreen)
//
//        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
//        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
//            self?.dismiss(animated: true, completion: nil)
//            self?.navigationController?.popViewController(animated: true)
//        }
//
//        // Add Button to Alert
//        alertVc.addAction(alertBtn)
//
//        // Present Alert
//        self.present(alertVc, animated: true, completion: nil)
//    }
}

extension ResetPasswordViewController {
    // Setup
    func setUp() {
        let textFields: [UITextField] = [currentPassword, newPassword, newPasswordConfirm]
        let inputImgs: [String] = ["cpassword_icon", "password_icon", "cpassword_icon"]
        
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
        
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.passwordResetStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success(let msg), .failure(let msg):
                DispatchQueue.main.async {
                    self.showAlert(msg: msg, vcType: StringConstants.ResetPasswordViewController, shouldPop: true)
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
        self.title = "Reset Password"
        
        // Customise Naviagtion Bar
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
