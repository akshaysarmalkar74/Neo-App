//
//  OrderDetailCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 22/02/22.
//

import UIKit

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var productImg: LazyImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productQty: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(img: String, name: String, category: String, qty: Int, price: Int) {
        // Fetch Image
        let url = URL(string: img)
        if let actualUrl = url {
            productImg.loadImage(fromURL: actualUrl, placeHolderImage: "place")
        }
        
        productTitle.text = name
        productCategory.text = "(\(category))"
        productQty.text = "QTY - \(qty)"
        productPrice.text = "₹ \(price)"
    }
    
}
