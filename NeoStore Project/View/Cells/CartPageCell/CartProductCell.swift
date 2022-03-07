//
//  CartProductCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 10/02/22.
//

import UIKit

protocol CartEditButtonDelegate {
    func didTapEditBtn(id: Int)
}

class CartProductCell: UITableViewCell {
    
    @IBOutlet weak var productImg: LazyImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var quantityBtn: UIButton!
    
    // Variables & Constants
    var productId: Int?
    var delegate: CartEditButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func quantityBtn(_ sender: UIButton) {
        // Call delegate
        if let actualId = productId {
            self.delegate?.didTapEditBtn(id: actualId)
        }
    }
    
    func configure(name: String, img: String, category: String, price: Int, quantity: Int, id: Int) {
        // Set Image
        let url = URL(string: img)
        if let actualUrl = url {
            productImg.loadImage(fromURL: actualUrl, placeHolderImage: "place")
        }
        
        self.productId = id
        productName.text = name
        productCategory.text = "\(category)"
        productPrice.text = "₹ \(price)"
        quantityBtn.setTitle("\(quantity)", for: .normal)
    }
}
