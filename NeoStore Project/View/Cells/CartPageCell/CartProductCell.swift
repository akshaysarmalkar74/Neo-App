//
//  CartProductCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 10/02/22.
//

import UIKit

protocol CartEditButtonDelegate {
    func didTapEditBtn(id: Int, quantity: String?)
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
        print(sender.currentTitle!)
        if let actualId = productId {
            self.delegate?.didTapEditBtn(id: actualId, quantity: sender.currentTitle)
        }
    }
    
    func configure(productDetails: Product, cartItem: CartListData) {
        let name = productDetails.name ?? ""
        let price = productDetails.subTotal ?? 0
        let category = productDetails.productCategory ?? ""
        let img = productDetails.productImages ?? ""
        let id = productDetails.id ?? 0
        let quantity = cartItem.quantity ?? 0
        
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
