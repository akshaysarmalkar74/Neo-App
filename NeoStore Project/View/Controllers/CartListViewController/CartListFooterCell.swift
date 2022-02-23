//
//  CartListFooterCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import UIKit

class CartListFooterCell: UITableViewCell {

    @IBOutlet weak var totalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
