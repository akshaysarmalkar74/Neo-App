//
//  SideMenuCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 23/02/22.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(img: String, name: String, num: Int?) {
        if let actualNum = num {
            itemNum.text = "\(actualNum)"
            itemNum.isHidden = false
        } else {
            itemNum.isHidden = true
        }
        itemName.text = name
        itemImg.image = UIImage(named: img)
    }
    
}
