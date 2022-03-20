//
//  AddressListViewFooter.swift
//  NeoStore Project
//
//  Created by Neosoft on 09/03/22.
//

import UIKit

protocol AddressListViewFooterDelegate: AnyObject {
    func didTapppedOrderBtn()
}

class AddressListViewFooter: UITableViewHeaderFooterView {

    weak var delegate: AddressListViewFooterDelegate?
    
    @IBAction func placeOrderTapped(_ sender: UIButton) {
        self.delegate?.didTapppedOrderBtn()
    }
    

}
