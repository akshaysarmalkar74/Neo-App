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
    
    func configureCell(item: OrderModel) {
        // Configure Cell
        let id = item.id ?? 0
        let cost = item.cost ?? 0
        let created = item.created ?? ""
        
        self.orderId.text = "Order ID : \(id)"
        self.orderDate.text = "Order Date: \(created)"
        self.orderPrice.text = "₹ \(cost)"
    }
    
}
