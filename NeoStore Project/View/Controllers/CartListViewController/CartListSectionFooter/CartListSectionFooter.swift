//
//  CartListSectionFooter.swift
//  NeoStore Project
//
//  Created by Neosoft on 06/03/22.
//

import UIKit

protocol CartListSectionFooterDelegate: AnyObject {
    func didTappedOrderButton()
}

class CartListSectionFooter: UITableViewHeaderFooterView {
    
    weak var delegate: CartListSectionFooterDelegate?
    
    @IBAction func orderTapped(_ sender: Any) {
        self.delegate?.didTappedOrderButton()
    }
}
