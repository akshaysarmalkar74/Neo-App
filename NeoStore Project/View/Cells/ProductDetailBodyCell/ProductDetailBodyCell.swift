//
//  ProductDetailBodyCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 28/02/22.
//

import UIKit

class ProductDetailBodyCell: UICollectionViewCell {

    @IBOutlet weak var productImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureProductDetailBodyCell(img: String) {
        let url = URL(string: img)
        if let actualUrl = url {
            let data = try? Data(contentsOf: actualUrl)
            if let actualData = data {
                productImg.image = UIImage(data: actualData)
            }
        }
        
    }
    
}
