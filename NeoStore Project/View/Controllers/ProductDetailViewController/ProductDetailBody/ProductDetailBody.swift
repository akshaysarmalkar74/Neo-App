//
//  ProductDetailBody.swift
//  NeoStore Project
//
//  Created by Neosoft on 27/02/22.
//

import UIKit

class ProductDetailBody: UITableViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var mainImg: LazyImageView!
    @IBOutlet weak var productImages: UICollectionView!
    @IBOutlet weak var productDesc: UILabel!
    
    // Variables
    var allImages: [[String: Any]]!
    
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

        // Configure the view for the selected state
    }
    
    func configureCell(price: Int, description: String) {
        productPrice.text = "Rs. \(price)"
        productDesc.text = description
        
        if allImages.count > 0 {
            // Set Main Image
            let imgStr = allImages[0]["image"] as? String ?? ""
            let url = URL(string: imgStr)
            if let actualUrl = url {
                mainImg.loadImage(fromURL: actualUrl, placeHolderImage: "place")
            }
        }
        
        // Reload Collection View
        productImages.reloadData()
    }
    
}

extension ProductDetailBody: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailBodyCell", for: indexPath) as! ProductDetailBodyCell
        let currentImgUrl = allImages[indexPath.row]["image"] as? String
        
        if let unWrappedImgUrl = currentImgUrl {
            cell.configureProductDetailBodyCell(img: unWrappedImgUrl)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentImgUrl = allImages[indexPath.row]["image"] as? String
        let cell = collectionView.cellForItem(at: indexPath) as! ProductDetailBodyCell
        cell.isSelected = true
        
        if let unWrappedImgUrl = currentImgUrl {
            let url = URL(string: unWrappedImgUrl)
            if let actualUrl = url {
                mainImg.loadImage(fromURL: actualUrl, placeHolderImage: "place")
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductDetailBodyCell
        cell.isSelected = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.frame.size.height
        return CGSize(width: cellHeight * 1.1, height: cellHeight)
    }
    
}
