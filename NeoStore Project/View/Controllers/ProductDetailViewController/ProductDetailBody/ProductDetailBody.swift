//
//  ProductDetailBody.swift
//  NeoStore Project
//
//  Created by Neosoft on 27/02/22.
//

import UIKit

protocol ShareButtonDelegate: AnyObject {
    func didTapShareBtn()
}

class ProductDetailBody: UITableViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var mainImg: LazyImageView!
    @IBOutlet weak var productImages: UICollectionView!
    @IBOutlet weak var productDesc: UILabel!
    
    // Variables
    var allImages: [ProductImage]!
    weak var delegate: ShareButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productImages.delegate = self
        productImages.dataSource = self
        
        // Register Cell
        productImages.register(UINib(nibName: "ProductDetailBodyCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailBodyCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(price: Int, description: String) {
        productPrice.text = "Rs. \(price)"
        productDesc.text = description
        
        if allImages.count > 0 {
            // Set Main Image
            let imgStr = allImages[0].image ?? ""
            let url = URL(string: imgStr)
            if let actualUrl = url {
                mainImg.loadImage(fromURL: actualUrl, placeHolderImage: "place")
            }
            
            mainImg.layer.masksToBounds = true
            mainImg.layer.borderWidth = 1.5
            mainImg.layer.borderColor = UIColor.green.cgColor
        }
        
        // Reload Collection View
        productImages.reloadData()
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        // Call delegate
        delegate?.didTapShareBtn()
    }
}

extension ProductDetailBody: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailBodyCell", for: indexPath) as! ProductDetailBodyCell
        let currentImgUrl = allImages[indexPath.row].image
        
        // HighLight the first Image
        if indexPath.row == 0 {
            cell.isSelected = true
            // Show Border
            cell.productImg.layer.masksToBounds = true
            cell.productImg.layer.borderWidth = 2
            cell.productImg.layer.borderColor = UIColor.gray.cgColor
        }
        
        if let unWrappedImgUrl = currentImgUrl {
            cell.configureProductDetailBodyCell(img: unWrappedImgUrl)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentImgUrl = allImages[indexPath.row].image
        let cell = collectionView.cellForItem(at: indexPath) as! ProductDetailBodyCell
        let startingCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! ProductDetailBodyCell
       
        // Hide Border of First Image
        startingCell.productImg.layer.masksToBounds = true
        startingCell.productImg.layer.borderWidth = 0
        startingCell.productImg.layer.borderColor = UIColor.clear.cgColor
        
        
        // Show Border
        cell.productImg.layer.masksToBounds = true
        cell.productImg.layer.borderWidth = 2
        cell.productImg.layer.borderColor = UIColor.gray.cgColor
        
       
        if let unWrappedImgUrl = currentImgUrl {
            let url = URL(string: unWrappedImgUrl)
            if let actualUrl = url {
                mainImg.loadImage(fromURL: actualUrl, placeHolderImage: "place")
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductDetailBodyCell
        
        // Hide Border of current selected cell
        cell.productImg.layer.masksToBounds = true
        cell.productImg.layer.borderWidth = 0
        cell.productImg.layer.borderColor = UIColor.clear.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.frame.size.height
        return CGSize(width: cellHeight * 1.1, height: cellHeight)
    }
    
}
