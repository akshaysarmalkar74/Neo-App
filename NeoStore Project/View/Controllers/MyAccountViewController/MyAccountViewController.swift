//
//  MyAccountViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 10/02/22.
//

import UIKit

class MyAccountViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var birthDateField: UITextField!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    
    // Variables
    var user: UserData!
    let datePicker = UIDatePicker()
    var viewModel: MyAccountViewType!
    var currentProfileImgUrl: String!
    var loaderViewScreen: UIView?
    var isAnyTextFieldChanged = false
    
    init(viewModel: MyAccountViewType) {
        super.init(nibName: "MyAccountViewController", bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader(view: self.view, aicView: &loaderViewScreen)
        
        // Fetch User
        if UserDefaults.standard.isProfileUpdated() {
            self.viewModel.getUser()
        } else {
            user = UserDefaults.standard.getUserInstance()
            currentProfileImgUrl = user.profilePic ?? "profileDemo"
            setUserDetails(user: user)
            hideLoader(viewLoaderScreen: loaderViewScreen)
        }
        
        setUp()
        setupObservers()
    }

    
    @IBAction func editProfileBtnTapped(_ sender: UIButton) {
        if sender.currentTitle == "Edit Profile" {
            // Hide Reset Password Button
            resetPasswordBtn.isHidden = true
            sender.setTitle("Submit", for: .normal)
        } else {
            self.viewModel.updateUser(firstName: firstNameField.text ?? "", lastName: lastNameField.text ?? "", email: emailField.text ?? "", birthDate: birthDateField.text ?? "", phoneNo: phoneField.text ?? "", profilePic: "")
            
            // Send Request
            sender.setTitle("Edit Profile", for: .normal)
            resetPasswordBtn.isHidden = false
        }
        toggleEditableFieldInteraction()
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        let viewModel =  ResetPasswordScreenViewModel()
        let vc = ResetPasswordViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Image Tapped
    @IBAction func profileTapped(_ sender: UITapGestureRecognizer) {
        // Get Image Picker
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // Toggle Editable Fields Interaction
    func toggleEditableFieldInteraction() {
        let textFields: [UITextField] = [firstNameField, lastNameField ,emailField, phoneField, birthDateField]
        
        for textField in textFields {
            textField.isUserInteractionEnabled = !textField.isUserInteractionEnabled
        }
        
        profileImg.isUserInteractionEnabled = !profileImg.isUserInteractionEnabled
    }
    
    // Error Alert Function
    func showErrorAlert(msg: String?) {
        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let alertBtn = UIAlertAction(title: "Okay", style: .default) { [weak self] alertAction in
            self?.dismiss(animated: true, completion: nil)
        }
        
        // Add Button to Alert
        alertVc.addAction(alertBtn)
        
        // Present Alert
        self.present(alertVc, animated: true, completion: nil)
    }
}

extension MyAccountViewController {
    // Setup
    func setUp() {
        let textFields: [UITextField] = [firstNameField, lastNameField, emailField, phoneField, birthDateField]
        let inputImgs: [String] = ["username_icon", "username_icon", "email_icon", "cellphone_icon", "dob_icon"]
        
        for idx in 0..<textFields.count {
            // Set Border Width to Input
            textFields[idx].layer.borderWidth = 1.0
            
            // Set Border Color to Input
            textFields[idx].layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            // Set Delegate of TexFields
            textFields[idx].delegate = self
            
            // Customise Text Fields
            customiseTextField(textField: textFields[idx], imgName: inputImgs[idx])
        }
        
        // Add gestures
        addTapGestureToView()
        
        // Customise Navigation Bar
        customiseNavbar()
        
        // Set User Details
//        setUserDetails(user: user)
        
        // Configure Date Picker
        createDatePicker()
        
        // Add Border to profileImg
        profileImg.layer.masksToBounds = true
        profileImg.layer.borderWidth = 1.5
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg.layer.cornerRadius = profileImg.bounds.width / 2
    }
    
    // Date Picker BirthDate
    func createDatePicker() {
//         let toolBar = UIToolbar()
//         toolBar.sizeToFit()
//
//         // Bar Button
//         let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
//         toolBar.setItems([doneBtn], animated: true)
//
//         // Assign ToolBar
//         birthDateField.inputAccessoryView = toolBar
        
        // Assign Date Picker to text Field
        birthDateField.inputView = datePicker
        
        // Mode Date Picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        datePicker.addTarget(self, action: #selector(datePickerValChanged(_:)), for: .valueChanged)
    }
    
    // Setup Observers
    func setupObservers() {
        self.viewModel.updateUserStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success:
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                }
                UserDefaults.standard.setUpdatedProfile(value: true)
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.setUserDetails(user: self.user)
                    self.showErrorAlert(msg: msg)
                }
            case .none:
                break
            }
        }
        
        self.viewModel.userDetailsStatus.bindAndFire { [weak self] (value) in
            guard let `self` = self else {return}
            switch value {
            case .success(let user):
                // Update isUpdated Profile
                self.user = user
                UserDefaults.standard.setUpdatedProfile(value: false)
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.setUserDetails(user: user)
                }
            case .failure(let msg):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderViewScreen)
                    self.showErrorAlert(msg: msg)
                }
            case .none:
                break
            }
        }
    }
    
    
    @objc func datePickerValChanged(_ sender: UIDatePicker) {
        birthDateField.text = dateToString(curDate: datePicker.date)
    }
    
    // Convert Date into string
    func dateToString(curDate: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        return dateFormater.string(from: curDate)
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
        self.title = "My Account"
        
        // Customise Naviagtion Bar
        self.navigationController?.navigationBar.barTintColor = .mainRed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Customise Back Button Color & Title
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        // Add Left Bar Button
        let leftBackBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backBtnTapped(_:)))
        self.navigationItem.leftBarButtonItem = leftBackBtn
    }
    
    @objc func backBtnTapped(_ sender: UIBarButtonItem) {
        // Check if any field is changed or not
        print(isAnyTextFieldChanged)
        if isAnyTextFieldChanged {
            let alertVc = UIAlertController(title: nil, message: "Any Changes made will be discarded. Do you still want to proceed?", preferredStyle: .alert)
            
            // Add Buttons
            let yesBtn = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                print("Yes Tapped")
                self?.dismiss(animated: true, completion: nil)
                self?.navigationController?.popViewController(animated: true)
            }
            let noBtn = UIAlertAction(title: "No", style: .default) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                print("No Tapped")
            }
            
            alertVc.addAction(yesBtn)
            alertVc.addAction(noBtn)
            
            self.present(alertVc, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Add Tap Gesture to View
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Get User Details
    func setUserDetails(user: UserData) {
        firstNameField.text = user.firstName ?? ""
        lastNameField.text = user.lastName ?? ""
        emailField.text = user.email ?? ""
        phoneField.text = user.phoneNo ?? ""
        
        // Set Profile Image
        if let imgName = user.profilePic, imgName.count > 0 {
            profileImg.image = convertBase64StringToImage(imageBase64String: imgName)
        } else {
            profileImg.image = UIImage(named: "profileDemo")
        }
        
        // Set Birthdate
        birthDateField.text = user.dob ?? ""
    }
    
}


extension MyAccountViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImg = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
//        currentProfileImgUrl = convertImageToBase64String(img: selectedImg)
        profileImg.image = selectedImg
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
//        print(img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? "")
//        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        guard let imageData = img.pngData() else { return "" }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
}

extension MyAccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isAnyTextFieldChanged = true
        return true
    }
}
