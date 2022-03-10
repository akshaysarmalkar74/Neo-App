//
//  AddressListViewFooter.swift
//  NeoStore Project
//
//  Created by Neosoft on 09/03/22.
//

import UIKit

protocol AddressListViewFooterDelegate {
    func didTapppedOrderBtn()
}

class AddressListViewFooter: UITableViewHeaderFooterView {

    var delegate: AddressListViewFooterDelegate?
    
    @IBAction func placeOrderTapped(_ sender: UIButton) {
        self.delegate?.didTapppedOrderBtn()
    }
    

}
