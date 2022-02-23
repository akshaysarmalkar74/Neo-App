//
//  CartProductCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 10/02/22.
//

import UIKit

class CartProductCell: UITableViewCell {

    @IBOutlet weak var productImg: LazyImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var quantityBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func quantityBtn(_ sender: UIButton) {
        print("Quantity Btn Tapped")
    }
    
    func configure(name: String, img: String, category: String, price: Int, quantity: Int) {
        // Set Image
        let url = URL(string: img)
        if let actualUrl = url {
            productImg.loadImage(fromURL: actualUrl, placeHolderImage: "place")
        }
        
        productName.text = name
        productCategory.text = "\(category)"
        productPrice.text = "₹ \(price)"
        quantityBtn.setTitle("\(quantity)", for: .normal)
    }
}
