//
//  ProductHomeViewModel.swift
//  NeoStore Project
//
//  Created by Neosoft on 08/03/22.
//

import Foundation

enum FetchAccountDetail {
    case success
    case failure
    case none
}

protocol ProductHomeViewType {
    var sliderImages: [String] {get}
    var categoryImages: [String] {get}
    var totalCartProducts: Int {get set}
    
    func getSliderTotal() -> Int
    func getCategoryTotal() -> Int
    func getCategoryAtIndex(idx: Int) -> String
    func getSliderImgAtIdx(idx: Int) -> String
    func getTotalCartProduct() -> Int
}

class ProductHomeViewModel: ProductHomeViewType {
    let sliderImages = ["slider_img1", "slider_img2", "slider_img3", "slider_img4"]
    let categoryImages = ["tableicon", "sofaicon" ,"chairsicon", "cupboardicon"]
    var totalCartProducts: Int = 0
    
    func getTotalCartProduct() -> Int {
        return totalCartProducts
    }

    func getSliderTotal() -> Int {
        return sliderImages.count
    }
    
    func getCategoryTotal() -> Int {
        return categoryImages.count
    }
    
    func getSliderImgAtIdx(idx: Int) -> String {
        return sliderImages[idx]
    }
    
    func getCategoryAtIndex(idx: Int) -> String {
        return categoryImages[idx]
    }
    
}
