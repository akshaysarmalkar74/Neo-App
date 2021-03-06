//
//  ProductHomeViewController.swift
//  NeoStore Project
//
//  Created by Neosoft on 15/02/22.
//

import UIKit
import SideMenu

class ProductHomeViewController: UIViewController, SideMenuViewControllerDelegate {
    let sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController(viewModel: SideMenuViewModel()))
    
    // MARK:- IBOutlets
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var sliderPageControl: UIPageControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var sliderHeightConstrant: NSLayoutConstraint!
    
    // MARK:- Variables
    var currentIdx = 0
    var timer: Timer?
    let screenHeight = UIScreen.main.bounds.height
    var viewModel: ProductHomeViewType!
    
    init(viewModel: ProductHomeViewType) {
        super.init(nibName: StringConstants.ProductHomeViewController, bundle: nil)
        self.viewModel = viewModel
    }
    
    deinit {
        print("\(StringConstants.ProductHomeViewController) was deleted")
        timer?.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Delegate and Datasource
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        // Register Cell
        sliderCollectionView.register(UINib(nibName: "SliderCell", bundle: nil), forCellWithReuseIdentifier: "SliderCell")
        categoryCollectionView.register(UINib(nibName: "CategoryViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        
        // Set Timer
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changeSliderImg(_:)), userInfo: nil, repeats: true)
        
        // Configure Slider Page Control
        sliderPageControl.numberOfPages = self.viewModel.sliderImages.count
        
        // Update Height of Slider Image Constraint
        sliderHeightConstrant.constant = screenHeight * 0.35
        
        customiseNavbar(title: "NeoStore", vcType: StringConstants.ProductHomeViewController, btnSelector: #selector(menuTapped(_:)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show Navigation Bar
        configureSideMenu()
    }

    
    @objc func changeSliderImg(_ sender: Timer) {
        if currentIdx < self.viewModel.getSliderTotal() - 1 {
            currentIdx += 1
        } else {
            currentIdx = 0
        }
        let indexPath = IndexPath(item: currentIdx, section: 0)
        sliderPageControl.currentPage = currentIdx
        sliderCollectionView.layoutIfNeeded()
        sliderCollectionView.isPagingEnabled = false
        sliderCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        sliderCollectionView.isPagingEnabled = true
    }
    
    // Customise Navigation Bar
//    func customiseNavbar() {
//        // Set Title
//        self.title = "NeoStore"
//
//        // Customise Naviagtion Bar
//        self.navigationController?.navigationBar.barTintColor = .mainRed
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
//        // Customise Back Button Color & Title
//        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
//
//        // Hide Back Bar Button
//        self.navigationItem.setHidesBackButton(true, animated: true)
//
//        // Add Menu Button
//        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: .plain, target: self, action: #selector(menuTapped(_:)))
//        self.navigationItem.leftBarButtonItem = menuBtn
//    }
    
    @objc func menuTapped(_ sender: UIBarButtonItem) {
        self.present(sideMenu, animated: true, completion: nil)
    }
    
    // MARK:- Side Menu
    func configureSideMenu() {
        sideMenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        sideMenu.setNavigationBarHidden(true, animated: false)
        sideMenu.menuWidth = 300
        if let mainRootVc = sideMenu.viewControllers[0] as? SideMenuViewController {
            mainRootVc.customDelegate = self
        }
    }
    
    func didTapMenuItem(vcAttr: SideMenuControllerNames) {
        switch vcAttr {
        case .MyCart:
            let myCartVm = CartListViewModel()
            let myCartVc = CartListViewController(viewModel: myCartVm)
            self.navigationController?.pushViewController(myCartVc, animated: true)
            self.sideMenu.dismiss(animated: false, completion: nil)
        case .Tables:
            let myCartVm = ProductListViewModel(categoryId: ProductCategoryId.Tables.rawValue)
            let myCartVc = ProductListViewController(viewModel: myCartVm, title: "Tables")
            self.sideMenu.dismiss(animated: false, completion: nil)
            self.navigationController?.pushViewController(myCartVc, animated: true)
        case .Sofas:
            let myCartVm = ProductListViewModel(categoryId: ProductCategoryId.Sofas.rawValue)
            let myCartVc = ProductListViewController(viewModel: myCartVm, title: "Sofas")
            self.sideMenu.dismiss(animated: false, completion: nil)
            self.navigationController?.pushViewController(myCartVc, animated: true)
        case .Chair:
            let myCartVm = ProductListViewModel(categoryId: ProductCategoryId.Chair.rawValue)
            let myCartVc = ProductListViewController(viewModel: myCartVm, title: "Chairs")
            self.sideMenu.dismiss(animated: false, completion: nil)
            self.navigationController?.pushViewController(myCartVc, animated: true)
        case .Cupboard:
            let myCartVm = ProductListViewModel(categoryId: ProductCategoryId.Cupboards.rawValue)
            let myCartVc = ProductListViewController(viewModel: myCartVm, title: "CupBoards")
            self.sideMenu.dismiss(animated: false, completion: nil)
            self.navigationController?.pushViewController(myCartVc, animated: true)
        case .MyAccount:
            let myAccountVm = MyAccountScreenViewModel()
            let myAccountVc = MyAccountViewController(viewModel: myAccountVm)
            self.sideMenu.dismiss(animated: false, completion: nil)
            self.navigationController?.pushViewController(myAccountVc, animated: true)
        case .StoreLocator:
            break
        case .MyOrders:
            let myOrdersVm = MyOrdersViewModel()
            let myOrdersVc = MyOrdersViewController(viewModel: myOrdersVm)
            self.sideMenu.dismiss(animated: false, completion: nil)
            self.navigationController?.pushViewController(myOrdersVc, animated: true)
        case .Logout:
            // Remove User Defaults
//            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.user.rawValue)
//            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userToken.rawValue)
            
            // Pop to Login Vc
            setRootToLogInController()
//            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setRootToLogInController() {
//          Clear User Defaults
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.user.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userToken.rawValue)
        
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: LoginScreenViewController(viewModel: LoginScreenViewModel()))
        
        // Make it visible
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension ProductHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.restorationIdentifier == "SliderCollectionView" {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: (collectionView.frame.width - 12) / 2, height: (collectionView.frame.width - 12) / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "SliderCollectionView" {
            return self.viewModel.getSliderTotal()
        } else {
            return self.viewModel.getCategoryTotal()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.restorationIdentifier == "SliderCollectionView" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
            cell.productImg.image = UIImage(named: self.viewModel.getSliderImgAtIdx(idx: indexPath.row))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryViewCell
            cell.categoryImg.image = UIImage(named: self.viewModel.getCategoryAtIndex(idx: indexPath.row))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            var categoryId: Int
            var pageTitle: String
            switch indexPath.item {
            case 0:
                categoryId = 1
                pageTitle = "Tables"
            case 1:
                categoryId = 3
                pageTitle = "Chairs"
            case 2:
                categoryId = 2
                pageTitle = "Sofas"
            case 3:
                categoryId = 4
                pageTitle = "CupBoards"
            default:
                categoryId = 0
                pageTitle = ""
            }
            let viewModel = ProductListViewModel(categoryId: String(categoryId))
            let vc = ProductListViewController(viewModel: viewModel, title: pageTitle)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
