//
//  StoreLocatorCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 07/03/22.
//

import UIKit

class StoreLocatorCell: UITableViewCell {

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
