//
//  ProductHomeViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 15/02/22.
//

import UIKit

class ProductHomeViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var sliderPageControl: UIPageControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    // MARK:- Variables
    let sliderImages = ["slider_img1", "slider_img2", "slider_img3", "slider_img4"]
    let categoryImages = ["tableicon", "sofaicon" ,"chairsicon", "cupboardicon"]
    var currentIdx = 0
    var timer: Timer!
    
    init() {
        super.init(nibName: "ProductHomeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseNavbar()
        
        // Set Delegate and Datasource
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        // Register Cell
        sliderCollectionView.register(UINib(nibName: "SliderCell", bundle: nil), forCellWithReuseIdentifier: "SliderCell")
        categoryCollectionView.register(UINib(nibName: "CategoryViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        
        // Set Timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeSliderImg(_:)), userInfo: nil, repeats: true)
        
        // Configure Slider Page Control
        sliderPageControl.numberOfPages = sliderImages.count
    }
    
    @objc func changeSliderImg(_ sender: Timer) {
        if currentIdx < sliderImages.count - 1 {
            currentIdx += 1
        } else {
            currentIdx = 0
        }
        sliderPageControl.currentPage = currentIdx
        sliderCollectionView.scrollToItem(at: IndexPath(item: currentIdx, section: 0), at: .right, animated: true)
    }
    
    // Customise Navigation Bar
    func customiseNavbar() {
        // Set Title
        self.title = "Register"
        
        // Customise Naviagtion Bar
        self.navigationController?.navigationBar.barTintColor = .mainRed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Customise Back Button Color & Title
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        // Hide Back Bar Button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Add Menu Button
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: .plain, target: self, action: #selector(menuTapped(_:)))
        self.navigationItem.leftBarButtonItem = menuBtn
    }
    
    @objc func menuTapped(_ sender: UIBarButtonItem) {
        print("Menu Tapped")
    }
}

extension ProductHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.restorationIdentifier == "SliderCollectionView" {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        return CGSize(width: (collectionView.frame.width - 12) / 2, height: (collectionView.frame.width - 12) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "SliderCollectionView" {
            return sliderImages.count
        }
        return categoryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.restorationIdentifier == "SliderCollectionView" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
            cell.productImg.image = UIImage(named: sliderImages[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryViewCell
            cell.categoryImg.image = UIImage(named: categoryImages[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let categoryId = indexPath.item + 1
            let viewModel = ProductListViewModel()
            let vc = ProductListViewController(categoryId: String(categoryId), viewModel: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}