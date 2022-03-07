//
//  AddressListCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 24/02/22.
//

import UIKit

class AddressListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var radioImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(name: String, address: String, isChecked: Bool) {
        nameLabel.text = name
        addressLabel.text = address
        if isChecked {
            radioImg.image = UIImage(named: "checked_icon")
        } else {
            radioImg.image = UIImage(named: "uncheck_icon")
        }
    }
    
}
