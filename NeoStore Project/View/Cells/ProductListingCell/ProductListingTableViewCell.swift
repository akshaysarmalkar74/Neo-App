//
//  ProductListingTableViewCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 09/02/22.
//

import UIKit

class ProductListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImg: LazyImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet var stars: [UIImageView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureProduct(imgName: String, name: String, desc: String, price: Int, rating: Int) {
        // Set Image
        let url = URL(string: imgName)
        if let actualUrl = url {
            productImg.loadImage(fromURL: actualUrl, placeHolderImage: "place")
        }
        
//        productImg.image = UIImage(named: imgName)
        productName.text = name
        productDesc.text = desc
        productPrice.text = "Rs. \(price)"
        
        for i in 1...5 {
            if i <= rating {
                stars[i-1].image = UIImage(named: "star_check")
            } else {
                stars[i-1].image = UIImage(named: "star_unchek")
            }
        }
    }
    
}
