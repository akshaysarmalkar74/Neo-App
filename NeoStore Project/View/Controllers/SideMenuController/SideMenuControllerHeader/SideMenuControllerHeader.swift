//
//  SideMenuControllerHeader.swift
//  NeoStore Project
//
//  Created by Neosoft on 23/02/22.
//

import UIKit

class SideMenuControllerHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var email: UILabel!
    
    
        func configure(firstName: String, lastName: String, userEmail: String) {
        profileImg.image = UIImage(named: "profileDemo")
        userName.text = "\(firstName) \(lastName)"
        email.text = userEmail
            
            // Add Border to profileImg
            profileImg.layer.masksToBounds = true
            profileImg.layer.borderWidth = 1.5
            profileImg.layer.borderColor = UIColor.white.cgColor
            profileImg.layer.cornerRadius = profileImg.bounds.width / 2
    }

}
