//
//  ProductDetailHeader.swift
//  NeoStore Project
//
//  Created by Neosoft on 27/02/22.
//

import UIKit

class ProductDetailHeader: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productProvider: UILabel!
    @IBOutlet var ratingStars: [UIImageView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Configure Cell
    func configure(name: String, category: String, provider: String, rating: Int) {
        productName.text = name
        productCategory.text = "Category - \(category)"
        productProvider.text = provider
        
        for i in 1...5 {
            if i <= rating {
                ratingStars[i-1].image = UIImage(named: "star_check")
            } else {
                ratingStars[i-1].image = UIImage(named: "star_unchek")
            }
        }
        
    }
    
}
