//
//  ProductDetailBody.swift
//  NeoStore Project
//
//  Created by Neosoft on 27/02/22.
//

import UIKit

protocol ShareButtonDelegate {
    func didTapShareBtn()
}

class ProductDetailBody: UITableViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var mainImg: LazyImageView!
    @IBOutlet weak var productImages: UICollectionView!
    @IBOutlet weak var productDesc: UILabel!
    
    // Variables
    var allImages: [ProductImage]!
    var delegate: ShareButtonDelegate?
    
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
        
        if let unWrappedImgUrl = currentImgUrl {
            cell.configureProductDetailBodyCell(img: unWrappedImgUrl)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentImgUrl = allImages[indexPath.row].image
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
