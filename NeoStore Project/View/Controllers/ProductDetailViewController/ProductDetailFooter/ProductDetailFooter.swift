//
//  ProductDetailFooter.swift
//  NeoStore Project
//
//  Created by Neosoft on 28/02/22.
//

import UIKit

protocol ProductDetailFooterDelegate: AnyObject {
    func didTapBuyNow()
    func didTapRateBtn()
}

class ProductDetailFooter: UITableViewCell {
    
    weak var delegate: ProductDetailFooterDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buyNowTapped(_ sender: Any) {
        self.delegate?.didTapBuyNow()
    }
    
    @IBAction func rateBtnTapped(_ sender: Any) {
        self.delegate?.didTapRateBtn()
    }
}
