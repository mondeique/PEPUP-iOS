//
//  NotiVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let notiactivityIdentifier = "notiactivitycell"
private let notipurchasedIdentifier = "notipurchasedcell"

class NotiVC: UIViewController, CustomNotiBarDelegate{
    
    var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var customNotiBar = CustomNotiBar()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        setupCustomTabBar()
        setupPageCollectionView()
//        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
//        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: Setup view
    func setupCustomTabBar(){
        self.view.addSubview(customNotiBar)
        customNotiBar.delegate = self
        customNotiBar.translatesAutoresizingMaskIntoConstraints = false
        customNotiBar.indicatorViewWidthConstraint.constant = UIScreen.main.bounds.width/375 * 74
        customNotiBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        customNotiBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: UIScreen.main.bounds.width/375 * -83).isActive = true
        customNotiBar.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
        customNotiBar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 44).isActive = true
    }
    
    func customNotiBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupPageCollectionView() {
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.backgroundColor = .white
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.register(NotiActivityCell.self, forCellWithReuseIdentifier: notiactivityIdentifier)
        pageCollectionView.register(NotiPurchasedCell.self, forCellWithReuseIdentifier: notipurchasedIdentifier)
        self.view.addSubview(pageCollectionView)
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: self.customNotiBar.bottomAnchor).isActive = true
    }
    
//    func getData() {
//        Alamofire.AF.request("\(Config.baseURL)/api/store/shop/" + String(SellerID) + "/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
//            (response) in switch response.result {
//            case .success(let JSON):
//                let response = JSON as! NSDictionary
//                self.sellerInfoDatas = response.object(forKey: "info") as! NSDictionary
//                self.productDatas = response.object(forKey: "results") as! Array<NSDictionary>
//
//            case .failure(let error):
//                print("Request failed with error: \(error)")
//            }
//        }
//    }
    
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource

extension NotiVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notiactivityIdentifier, for: indexPath) as! NotiActivityCell
//            if indexPath.row == 0 {
//                cell.shopcollectionView.isHidden = false
//            }
//            else if indexPath.row == 1 {
//                cell.shopcollectionView.isHidden = true
//            }
//            else if indexPath.row == 2 {
//                cell.shopcollectionView.isHidden = true
//            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notipurchasedIdentifier, for: indexPath) as! NotiPurchasedCell
            if indexPath.row == 0 {
                cell.purchasedcollectionView.isHidden = true
            }
            else if indexPath.row == 1 {
                cell.purchasedcollectionView.isHidden = false
            }
            else if indexPath.row == 2 {
                cell.purchasedcollectionView.isHidden = true
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customNotiBar.indicatorViewLeadingConstraint.constant = UIScreen.main.bounds.width/375 * 16 + scrollView.contentOffset.x / 375 * 100
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        customNotiBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}
//MARK:- UICollectionViewDelegateFlowLayout
extension NotiVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

