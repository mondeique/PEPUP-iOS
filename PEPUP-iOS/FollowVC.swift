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
        layout.itemSize = CGSize(width: screenWidth/defaultWidth * 375, height: screenWidth/defaultWidth * 375)
        
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
        return self.productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
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
        let productDic = self.productDatas[indexPath.section] as NSDictionary
        let imageArray = productDic.object(forKey: "images") as! Array<Dictionary<String, Any>>
        let imageDic = imageArray[0] as NSDictionary
        let ImageUrlString = imageDic.object(forKey: "image") as! String
        let imageUrl:NSURL = NSURL(string: ImageUrlString)!
        let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
        let image = UIImage(data: imageData as Data)
        cell.productImage.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: followheaderId, for: indexPath) as! FollowHeaderCell
                let productDic = self.productDatas[indexPath.section] as NSDictionary
                let sellerInfoDic = productDic.object(forKey: "seller") as! NSDictionary
                if let profileDic = sellerInfoDic.object(forKey: "profile") as? NSDictionary {
                    let sellerUrlString = profileDic.object(forKey: "thumbnail_img") as! String
                    let imageUrl:NSURL = NSURL(string: sellerUrlString)!
                    let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                    let image = UIImage(data: imageData as Data)
                    let nickname = sellerInfoDic.object(forKey: "nickname") as! String
                    let tagArray = productDic.object(forKey: "tag") as! Array<Dictionary<String, Any>>
                    let tagDic = tagArray[0] as NSDictionary
                    let tag = tagDic.object(forKey: "tag") as! String
                    DispatchQueue.main.async {
                        headerView.sellerImage.setImage(image, for: .normal)
                        headerView.sellerName.setTitle(nickname, for: .normal)
                        headerView.tagName.setTitle(tag, for: .normal)
                        headerView.sellerImage.addTarget(self, action: #selector(self.sellerstore), for: .touchUpInside)
                        headerView.sellerName.addTarget(self, action: #selector(self.sellerstore), for: .touchUpInside)
                        headerView.tagName.addTarget(self, action: #selector(self.tag), for: .touchUpInside)
                    }
                }
                return headerView
            
        case UICollectionView.elementKindSectionFooter:
            
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: followfooterId, for: indexPath) as! FollowFooterCell
                let productDic = self.productDatas[indexPath.section] as NSDictionary
                let productName = productDic.object(forKey: "name") as! String
                let productPrice = productDic.object(forKey: "price") as! Int
                let productSize = productDic.object(forKey: "size") as! String
                let productBrandDic = productDic.object(forKey: "brand") as! NSDictionary
                let productBrand = productBrandDic.object(forKey: "name") as! String
                DispatchQueue.main.async {
                    footerView.btnLike.addTarget(self, action: #selector(self.like), for: .touchUpInside)
                    footerView.btnMessage.addTarget(self, action: #selector(self.message), for: .touchUpInside)
                    footerView.btnDetail.addTarget(self, action: #selector(self.detail), for: .touchUpInside)
                    footerView.productName.text = productName
                    footerView.btnDetail.setTitle(String(productPrice), for: .normal)
                    footerView.sizeInfoLabel.text = productSize
                    footerView.brandInfoLabel.text = productBrand
                }
                return footerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    @objc func tag() {
        print("TOUCH TAG")
    }
    
    @objc func sellerstore() {
        print("TOUCH SELLER STORE")
    }
    
    @objc func like() {
        print("TOUCH LIKE")
//        if btnLike.currentImage == UIImage(named: "btnLike") {
//            btnLike.setImage(UIImage(named: "btnLike_fill"), for: .normal)
//            Alamofire.AF.request("\(Config.baseURL)/api/products/like/" + String(Myid) + "/", method: .post, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
//                (response) in switch response.result {
//                case .success(let JSON):
//                    print("Success with JSON: \(JSON)")
//
//                case .failure(let error):
//                    print("Request failed with error: \(error)")
//                }
//            }
//       }
//        else if btnLike.currentImage == UIImage(named: "btnLike_fill") {
//            btnLike.setImage(UIImage(named: "btnLike"), for: .normal)
//            Alamofire.AF.request("\(Config.baseURL)/api/products/like/" + String(Myid) + "/", method: .post, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
//                (response) in switch response.result {
//                case .success(let JSON):
//                    print("Success with JSON: \(JSON)")
//
//                case .failure(let error):
//                    print("Request failed with error: \(error)")
//                }
//            }
//        }
    }
    
    @objc func message() {
        print("TOUCH MESSAGE")
    }
    
    @objc func detail() {
        print("TOUCH DETAIL")
    }
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 114)
    }
}
