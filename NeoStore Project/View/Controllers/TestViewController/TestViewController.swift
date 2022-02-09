//
//  TestViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 08/02/22.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    init() {
        super.init(nibName: "TestViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        print("Logout Tapped")
        
        // Remove User Defaults
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.user.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userToken.rawValue)
    }
}
