//
//  ProductDetailBodyCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 28/02/22.
//

import UIKit

class ProductDetailBodyCell: UICollectionViewCell {

    @IBOutlet weak var productImg: UIImageView!
    var isPresent: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isPresent {
            activateBorder()
        }
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
    
    func activateBorder() {
        // Set Border to Image
        productImg.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        productImg.layer.masksToBounds = true
        productImg.contentMode = .scaleAspectFill
        productImg.layer.borderWidth = 3
    }
    
}
