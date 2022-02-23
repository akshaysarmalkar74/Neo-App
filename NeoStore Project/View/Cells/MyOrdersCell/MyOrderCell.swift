//
//  MyOrderCell.swift
//  NeoStore Project
//
//  Created by Neosoft on 21/02/22.
//

import UIKit

class MyOrderCell: UITableViewCell {

    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(id: Int, cost: Int, created: String) {
        self.orderId.text = "Order ID : \(id)"
        self.orderDate.text = "Order Date: \(created)"
        self.orderPrice.text = "₹ \(cost)"
    }
    
}
