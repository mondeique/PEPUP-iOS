//
//  PageCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/24.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class PageCell: BaseCollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let shopcellId = "shopcell"
    private let shopheaderId = "shopheadercell"
    
    var SellerID = UserDefaults.standard.object(forKey: "sellerId") as! Int
    var sellerInfoDatas = NSDictionary()
    var productDatas = Array<NSDictionary>()
    
    var shopcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 204)
        collectionView.backgroundColor = .white
        collectionView.isHidden = true
        return collectionView
    }()
    
    override func setup() {
        backgroundColor = .white
        
        shopcollectionView.delegate = self
        shopcollectionView.dataSource = self
        shopcollectionView.register(ShopCell.self, forCellWithReuseIdentifier: shopcellId)
        shopcollectionView.register(ShopHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: shopheaderId)
        self.addSubview(shopcollectionView)
        
        getData()
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/store/shop/" + String(SellerID) + "/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                self.sellerInfoDatas = response.object(forKey: "info") as! NSDictionary
                self.productDatas = response.object(forKey: "results") as! Array<NSDictionary>
                print(self.productDatas.count)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shopcellId, for: indexPath) as! ShopCell
        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
        let is_sold = productDictionary.object(forKey: "sold") as! Bool
        if let productImgDic = productDictionary.object(forKey: "thumbnails") as? NSDictionary {
            let imageUrlString = productImgDic.object(forKey: "thumbnail") as! String
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                cell.productImg.image = image
                if is_sold == true {
                    cell.soldLabel.isHidden = false
                }
                else {
                    cell.soldLabel.isHidden = true
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: shopheaderId, for: indexPath) as! ShopHeaderCell
                if let sellerImgDic = sellerInfoDatas.object(forKey: "profile") as? NSDictionary {
                    let imageUrlString = sellerImgDic.object(forKey: "thumbnail_img") as! String
                    let imageUrl:NSURL = NSURL(string: imageUrlString)!
                    let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                    let image = UIImage(data: imageData as Data)
                    headerView.sellerImage.image = image
                }
                if let sellerName = sellerInfoDatas.object(forKey: "nickname") as? String {
                    headerView.sellerName.text = sellerName
                }
                if let sellerintro = sellerInfoDatas.object(forKey: "profile_introduce") as? String {
                    headerView.sellerIntro.text = sellerintro
                }
                if let followercount = sellerInfoDatas.object(forKey: "followers") as? Int {
                    headerView.followerCountLabel.text = String(followercount)
                }
                if let followingcount = sellerInfoDatas.object(forKey: "followings") as? Int {
                    headerView.followingCountLabel.text = String(followingcount)
                }
               
                return headerView
            
            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CLICK \(indexPath.row)")
    }

}

class ShopCell: BaseCollectionViewCell {
    
    let shopcellcontentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var productImg: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1))
    
    let soldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S O L D"
        label.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    override func setup() {
        backgroundColor = .black
        shopcellcontentView.addSubview(productImg)
        shopcellcontentView.addSubview(soldLabel)
        self.addSubview(shopcellcontentView)
        
        shopcellcontentViewLayout()
        productImgLayout()
        soldLabelLayout()
    }
    
    func shopcellcontentViewLayout() {
        shopcellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        shopcellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        shopcellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        shopcellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func productImgLayout() {
        productImg.leftAnchor.constraint(equalTo:shopcellcontentView.leftAnchor).isActive = true
        productImg.topAnchor.constraint(equalTo:shopcellcontentView.topAnchor).isActive = true
//        productImg.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productImg.heightAnchor.constraint(equalToConstant:80).isActive = true
    }
    
    func soldLabelLayout() {
        soldLabel.leftAnchor.constraint(equalTo:shopcellcontentView.leftAnchor).isActive = true
        soldLabel.topAnchor.constraint(equalTo:shopcellcontentView.topAnchor).isActive = true
        soldLabel.widthAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
        soldLabel.heightAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
    }
}

class ShopHeaderCell: BaseCollectionViewCell {
    
    let shopheadercontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sellerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let sellerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        return label
    }()

    let sellerIntro: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.textAlignment = .left
        return label
    }()

    let followerCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.textAlignment = .center
        return label
    }()

    let followerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.text = "Follower"
        label.textAlignment = .center
        return label
    }()

    let followingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.textAlignment = .center
        return label
    }()

    let followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textAlignment = .center
        label.text = "Following"
        return label
    }()

    let btnFollow: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Follow", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textColor = .white
        btn.backgroundColor = .black
        return btn
    }()

    let btnMessage: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnStoreMessage"), for: .normal)
        return btn
    }()
    
    override func setup() {
        backgroundColor = .white
        self.addSubview(shopheadercontentView)
        
        shopheadercontentView.addSubview(sellerImage)
        shopheadercontentView.addSubview(sellerName)
        shopheadercontentView.addSubview(sellerIntro)
        shopheadercontentView.addSubview(followerCountLabel)
        shopheadercontentView.addSubview(followerLabel)
        shopheadercontentView.addSubview(followingCountLabel)
        shopheadercontentView.addSubview(followingLabel)
        shopheadercontentView.addSubview(btnFollow)
        shopheadercontentView.addSubview(btnMessage)
        
        shopheadercontentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        shopheadercontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        shopheadercontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        shopheadercontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        sellerImage.leadingAnchor.constraint(equalTo: shopheadercontentView.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        sellerImage.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 16).isActive = true
        sellerImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
        sellerImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true

        sellerName.leftAnchor.constraint(equalTo: sellerImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        sellerName.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 48).isActive = true
        sellerName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
        sellerName.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true

        sellerIntro.leadingAnchor.constraint(equalTo: shopheadercontentView.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        sellerIntro.topAnchor.constraint(equalTo: sellerImage.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 16).isActive = true
        sellerIntro.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 337).isActive = true
    //        sellerIntro.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true

        followerCountLabel.leadingAnchor.constraint(equalTo: shopheadercontentView.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 19).isActive = true
        followerCountLabel.topAnchor.constraint(equalTo: sellerIntro.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
    //        followerCountLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
    //        followerCountLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true

        followerLabel.leadingAnchor.constraint(equalTo: shopheadercontentView.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        followerLabel.topAnchor.constraint(equalTo: followerCountLabel.bottomAnchor).isActive = true
    //        followerLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
    //        followerLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true

        followingCountLabel.leadingAnchor.constraint(equalTo: shopheadercontentView.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 98).isActive = true
        followingCountLabel.topAnchor.constraint(equalTo: sellerIntro.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
    //        followingCountLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
    //        followingCountLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true

        followingLabel.leftAnchor.constraint(equalTo: followerLabel.rightAnchor, constant: UIScreen.main.bounds.width/375 * 27).isActive = true
        followingLabel.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor).isActive = true
    //        followingLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
    //        followingLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true

        btnFollow.leadingAnchor.constraint(equalTo: shopheadercontentView.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 209).isActive = true
        btnFollow.topAnchor.constraint(equalTo: sellerIntro.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 27).isActive = true
        btnFollow.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 96).isActive = true
        btnFollow.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true

        btnMessage.leftAnchor.constraint(equalTo: btnFollow.rightAnchor, constant: UIScreen.main.bounds.width/375 * 4).isActive = true
        btnMessage.topAnchor.constraint(equalTo: sellerIntro.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 19).isActive = true
        btnMessage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 48).isActive = true
        btnMessage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 48).isActive = true
    }
}
