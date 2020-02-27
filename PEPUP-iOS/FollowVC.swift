//
//  FollowVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "followcell"
private let followheaderId = "followheadercell"
private let followfooterId = "followfootercell"

class FollowVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var pagenum : Int = 1
    var productDatas = Array<Dictionary<String, Any>>()
    
    var followcollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData(pagenum: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/defaultWidth * 375, height: screenHeight/defaultHeight * 375)
        
        followcollectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: screenWidth, height: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 49), collectionViewLayout: layout)
        followcollectionView.delegate = self
        followcollectionView.dataSource = self
        followcollectionView.register(FollowCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        followcollectionView.register(FollowHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: followheaderId)
        followcollectionView.register(FollowFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: followfooterId)
        followcollectionView.backgroundColor = UIColor.white
        
        navcontentView.addSubview(btnCart)
        navcontentView.addSubview(btnDirect)
        
        self.view.addSubview(navcontentView)
        self.view.addSubview(followcollectionView)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnCart.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 279).isActive = true
        btnCart.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 2).isActive = true
        btnCart.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 40).isActive = true
        btnCart.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 40).isActive = true
        
        btnDirect.leftAnchor.constraint(equalTo: btnCart.rightAnchor, constant: screenWidth/defaultWidth * 8).isActive = true
        btnDirect.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 2).isActive = true
        btnDirect.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 40).isActive = true
        btnDirect.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 40).isActive = true
        
        followcollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        followcollectionView.topAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        followcollectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    let navcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let btnCart: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnCart"), for: .normal)
        return btn
    }()
    
    let btnDirect: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnDirect"), for: .normal)
        return btn
    }()
    
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.productDatas.count
    }
    
    func getData(pagenum: Int) {
        Alamofire.AF.request("\(Config.baseURL)/api/follow/?page=" + String(pagenum) , method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let results = response["results"] as! NSDictionary
                let products = results.object(forKey: "products") as! Array<Dictionary<String, Any>>
                for i in 0..<products.count {
                    self.productDatas.append(products[i])
                }
                print(response)
                DispatchQueue.main.async {
                    self.followcollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FollowCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: followheaderId, for: indexPath) as! FollowHeaderCell
                return headerView

            case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: followfooterId, for: indexPath) as! FollowFooterCell
                return footerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.width)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 114.0)
    }

}
