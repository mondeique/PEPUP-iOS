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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        productDatas = Array<Dictionary<String, Any>>()
        getData(pagenum: 1)
        setup()
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIScreen.main.bounds.height/defaultHeight * 20
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
        navcontentView.addSubview(lineLabel)
        
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
        btnCart.addTarget(self, action: #selector(didTapCartButton(sender:)), for: .touchUpInside)
        
        btnDirect.leftAnchor.constraint(equalTo: btnCart.rightAnchor, constant: screenWidth/defaultWidth * 8).isActive = true
        btnDirect.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 2).isActive = true
        btnDirect.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 40).isActive = true
        btnDirect.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 40).isActive = true
        btnDirect.addTarget(self, action: #selector(didTapMessageButton(sender:)), for: .touchUpInside)
        
        lineLabel.leftAnchor.constraint(equalTo: navcontentView.leftAnchor).isActive = true
        lineLabel.bottomAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 1).isActive = true
        
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
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
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
        for i in 0..<imageArray.count {
            let imageDic = imageArray[i] as NSDictionary
            let ImageUrlString = imageDic.object(forKey: "image_url") as! String
            let imageUrl:NSURL = NSURL(string: ImageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let image = UIImage(data: imageData as Data)
            cell.productImage.image = image
        }
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
                    let tagid = tagDic.object(forKey: "id") as! Int
                    let sellerId = sellerInfoDic.object(forKey: "id") as! Int
                    let by = productDic.object(forKey: "by") as! Int
                    DispatchQueue.main.async {
                        if by == 1 {
                            headerView.sellerImage.setImage(image, for: .normal)
                            headerView.sellerName.setTitle(nickname, for: .normal)
                            headerView.sellerImage.setImage(image, for: .normal)
                            headerView.sellerName.setTitle(nickname, for: .normal)
                            headerView.sellerImage.layer.cornerRadius = headerView.sellerImage.frame.height / 2
                            headerView.sellerImage.layer.borderColor = UIColor.clear.cgColor
                            headerView.sellerImage.layer.borderWidth = 1
                            headerView.sellerImage.layer.masksToBounds = false
                            headerView.sellerImage.clipsToBounds = true
                            headerView.tagName.setTitle(tag, for: .normal)
                            headerView.sellerImage.tag = sellerId
                            headerView.sellerName.tag = sellerId
                            headerView.tagName.tag = tagid
                            headerView.sellerImage.addTarget(self, action: #selector(self.sellerstore(_:)), for: .touchUpInside)
                            headerView.sellerName.addTarget(self, action: #selector(self.sellerstore(_:)), for: .touchUpInside)
                            headerView.tagName.addTarget(self, action: #selector(self.tag(_:)), for: .touchUpInside)
                        }
                        else if by == 2{
                            headerView.sellerImage.setImage(UIImage(named: "TagImage"), for: .normal)
                            headerView.sellerName.setTitle("#" + tag, for: .normal)
                            headerView.tagName.setTitle(nickname, for: .normal)
                            headerView.sellerName.tag = tagid
                            headerView.sellerName.addTarget(self, action: #selector(self.tag(_:)), for: .touchUpInside)
                            headerView.tagName.tag = sellerId
                            headerView.tagName.addTarget(self, action: #selector(self.sellerstore(_:)), for: .touchUpInside)
                        }
                    }
                }
                return headerView
            
        case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: followfooterId, for: indexPath) as! FollowFooterCell
                let productDic = self.productDatas[indexPath.section] as NSDictionary
                let productName = productDic.object(forKey: "name") as! String
                let productPrice = productDic.object(forKey: "price") as! Int
                let is_sold = productDic.object(forKey: "sold") as! Bool
                let is_like = productDic.object(forKey: "liked") as! Bool
                let is_pepup = productDic.object(forKey: "is_refundable") as! Bool
                let productSize = productDic.object(forKey: "size") as! String
                let productBrandDic = productDic.object(forKey: "brand") as! NSDictionary
                let productBrand = productBrandDic.object(forKey: "name") as! String
                let productId = productDic.object(forKey: "id") as! Int
                let age = productDic.object(forKey: "age") as! String
                DispatchQueue.main.async {
                    if is_like == true {
                        footerView.btnLike.setImage(UIImage(named: "btnLike_fill"), for: .normal)
                        footerView.btnLike.tag = productId
                        footerView.btnLike.addTarget(self, action: #selector(self.like(_:)), for: .touchUpInside)
                    }
                    else {
                        footerView.btnLike.setImage(UIImage(named: "btnLike"), for: .normal)
                        footerView.btnLike.tag = productId
                        footerView.btnLike.addTarget(self, action: #selector(self.like(_:)), for: .touchUpInside)
                    }
                    footerView.btnMessage.tag = indexPath.section
                    footerView.btnMessage.addTarget(self, action: #selector(self.message(_:)), for: .touchUpInside)
                    footerView.btnDetail.tag = productId
                    footerView.btnfakeDetail.tag = productId
                    footerView.btnfakeDetail.addTarget(self, action: #selector(self.detail(_:)), for: .touchUpInside)
                    footerView.btnDetail.addTarget(self, action: #selector(self.detail(_:)), for: .touchUpInside)
                    footerView.productName.text = productName
                    if is_pepup == true {
                        if is_sold == true {
                            footerView.pepupImage.isHidden = false
                            footerView.btnDetailLabel.text = "S O L D"
                            footerView.btnDetailLabel.textColor = .black
                            footerView.btnDetailContentView.backgroundColor = .white
                            footerView.btnDetail.setTitleColor(.black, for: .normal)
                            footerView.btnDetail.setImage(UIImage(named: "btnGO_sold"), for: .normal)
                        }
                        else {
                            footerView.pepupImage.isHidden = false
                            footerView.btnDetailLabel.text = String(productPrice) + "원"
                            footerView.btnDetailContentView.backgroundColor = UIColor(rgb: 0xD8FF00)
                            footerView.btnDetailLabel.textColor = .black
                            footerView.btnDetailContentView.layer.borderWidth = 0
                            footerView.btnDetail.setImage(UIImage(named: "btnGO_sold"), for: .normal)
                        }
                    }
                    else {
                        if is_sold == true {
                            footerView.pepupImage.isHidden = true
                            footerView.btnDetailLabel.text = "S O L D"
                            footerView.btnDetailLabel.textColor = .black
                            footerView.btnDetailContentView.backgroundColor = .white
                            footerView.btnDetail.setTitleColor(.black, for: .normal)
                            footerView.btnDetail.setImage(UIImage(named: "btnGO_sold"), for: .normal)
                        }
                        else {
                            footerView.pepupImage.isHidden = true
                            footerView.btnDetailLabel.text = String(productPrice) + "원"
                            footerView.btnDetailContentView.backgroundColor = .black
                            footerView.btnDetailLabel.textColor = .white
                            footerView.btnDetail.setImage(UIImage(named: "btnGO_notsold"), for: .normal)
                        }
                    }
                    footerView.sizeInfoLabel.text = productSize
                    footerView.brandInfoLabel.text = productBrand
                    footerView.timeLabel.text = age
                }
                return footerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    @objc func didTapMessageButton(sender: AnyObject){
        self.navigationController?.pushViewController(MessageChatVC(), animated: true)
    }
    
    @objc func didTapCartButton(sender: AnyObject){
        self.navigationController?.pushViewController(CartVC(), animated: true)
    }
    
    @objc func tag(_ sender: UIButton) {
        let nextVC = TagVC()
        nextVC.TagID = sender.tag
        nextVC.TagName = sender.currentTitle
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func sellerstore(_ sender: UIButton) {
        let nextVC = StoreVC()
        nextVC.SellerID = sender.tag
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func like(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "btnLike") {
            sender.setImage(UIImage(named: "btnLike_fill"), for: .normal)
            Alamofire.AF.request("\(Config.baseURL)/api/products/like/" + String(sender.tag) + "/", method: .post, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")

                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
        else if sender.currentImage == UIImage(named: "btnLike_fill") {
            sender.setImage(UIImage(named: "btnLike"), for: .normal)
            Alamofire.AF.request("\(Config.baseURL)/api/products/like/" + String(sender.tag) + "/", method: .post, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")

                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
    
    @objc func message(_ sender: UIButton) {
        let nextVC = MessageChatVC()
        let productDic = self.productDatas[sender.tag] as NSDictionary
        let sellerInfoDic = productDic.object(forKey: "seller") as! NSDictionary
        let sellerId = sellerInfoDic.object(forKey: "id") as! Int
        let sellerName = sellerInfoDic.object(forKey: "nickname") as! String
        nextVC.destinationUid = String(sellerId)
        nextVC.destinationName = sellerName
        if let sellerImgDic = sellerInfoDic.object(forKey: "profile") as? NSDictionary {
            let sellerUrlString = sellerImgDic.object(forKey: "thumbnail_img") as! String
            nextVC.destinationUrlString = sellerUrlString
        }
        if UserDefaults.standard.object(forKey: "pk") as! Int == sellerId {
            print("THIS IS ME")
        }
        else {
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func detail(_ sender: UIButton) {
        let nextVC = DetailVC()
        nextVC.Myid = sender.tag
        navigationController?.pushViewController(nextVC, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.productDatas.count - 1 {
            pagenum = pagenum + 1
            getData(pagenum: pagenum)
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
}
