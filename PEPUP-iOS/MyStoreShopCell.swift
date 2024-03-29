//
//  PageCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/24.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class MyStoreShopCell: BaseCollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private let myshopcellId = "myshopcell"
    private let myshopheaderId = "myshopheadercell"
    
    weak var delegate : MyStoreVC?
    
    var pagenum : Int = 1
    
    var SellerID = UserDefaults.standard.object(forKey: "pk") as! Int
    var sellerInfoDatas = NSDictionary()
    var productDatas = Array<NSDictionary>()
    
    let shopcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 204)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - UIScreen.main.bounds.height/667 * 150 - UIScreen.main.bounds.height/667 * 20), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isHidden = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getShopData(pagenum: 1)
        refreshControl.endRefreshing()
    }
    
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(shopcollectionView)
        
        shopcollectionView.delegate = self
        shopcollectionView.dataSource = self
        shopcollectionView.register(MyShopCell.self, forCellWithReuseIdentifier: myshopcellId)
        shopcollectionView.register(MyShopHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: myshopheaderId)
        
        shopcollectionView.addSubview(refreshControl)
        
        getShopData(pagenum: 1)
    }
    
    func getShopData(pagenum: Int) {
        Alamofire.AF.request("\(Config.baseURL)/api/store/shop/" + String(SellerID) + "/?page=" + String(pagenum), method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                self.sellerInfoDatas = response.object(forKey: "info") as! NSDictionary
                print(self.sellerInfoDatas)
                self.productDatas = response.object(forKey: "results") as! Array<NSDictionary>
                DispatchQueue.main.async {
                    self.shopcollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myshopcellId, for: indexPath) as! MyShopCell
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
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: myshopheaderId, for: indexPath) as! MyShopHeaderCell
                if let imageUrlString = sellerInfoDatas.object(forKey: "profile") as? String {
                    let imageUrl:NSURL = NSURL(string: imageUrlString)!
                    let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                    let image = UIImage(data: imageData as Data)
                    headerView.sellerImage.image = image
                    headerView.sellerImage.layer.cornerRadius = headerView.sellerImage.frame.height / 2
                    headerView.sellerImage.layer.borderColor = UIColor.clear.cgColor
                    headerView.sellerImage.layer.borderWidth = 1
                    headerView.sellerImage.layer.masksToBounds = false
                    headerView.sellerImage.clipsToBounds = true
                }
                if let reviewscore = sellerInfoDatas.object(forKey: "review_score") as? Int {
                    if 0 <= Float(reviewscore) && Float(reviewscore) < 0.5 {
                        headerView.star1.image = UIImage(named: "star_blank")
                    }
                    if 0.5 <= Float(reviewscore) && Float(reviewscore) < 1 {
                        headerView.star1.image = UIImage(named: "star_half")
                    }
                    else if 1 <= Float(reviewscore) && Float(reviewscore) < 1.5 {
                        headerView.star1.image = UIImage(named: "star")
                    }
                    else if 1.5 <= Float(reviewscore) && Float(reviewscore) < 2 {
                        headerView.star1.image = UIImage(named: "star")
                        headerView.star2.image = UIImage(named: "star_half")
                    }
                    else if 2 <= Float(reviewscore) && Float(reviewscore) < 2.5 {
                        headerView.star1.image = UIImage(named: "star")
                        headerView.star2.image = UIImage(named: "star")
                    }
                    else if 2.5 <= Float(reviewscore) && Float(reviewscore) < 3 {
                        headerView.star1.image = UIImage(named: "star")
                        headerView.star2.image = UIImage(named: "star")
                        headerView.star3.image = UIImage(named: "star_half")
                    }
                    else if 3 <= Float(reviewscore) && Float(reviewscore) < 3.5 {
                        headerView.star1.image = UIImage(named: "star")
                        headerView.star2.image = UIImage(named: "star")
                        headerView.star3.image = UIImage(named: "star")
                    }
                    else if 3.5 <= Float(reviewscore) && Float(reviewscore) < 4 {
                        headerView.star1.image = UIImage(named: "star")
                        headerView.star2.image = UIImage(named: "star")
                        headerView.star3.image = UIImage(named: "star")
                        headerView.star4.image = UIImage(named: "star_half")
                    }
                    else if 4 <= Float(reviewscore) && Float(reviewscore) < 4.5 {
                        headerView.star1.image = UIImage(named: "star")
                        headerView.star2.image = UIImage(named: "star")
                        headerView.star3.image = UIImage(named: "star")
                        headerView.star4.image = UIImage(named: "star")
                    }
                    else if 4.5 <= Float(reviewscore) && Float(reviewscore) < 5 {
                        headerView.star1.image = UIImage(named: "star")
                        headerView.star2.image = UIImage(named: "star")
                        headerView.star3.image = UIImage(named: "star")
                        headerView.star4.image = UIImage(named: "star")
                        headerView.star5.image = UIImage(named: "star_half")
                    }
                    else if Float(reviewscore) == 5{
                        headerView.star1.image = UIImage(named: "star")
                        headerView.star2.image = UIImage(named: "star")
                        headerView.star3.image = UIImage(named: "star")
                        headerView.star4.image = UIImage(named: "star")
                        headerView.star5.image = UIImage(named: "star")
                    }
                }
                if let reviewcount = sellerInfoDatas.object(forKey: "review_count") as? Int {
                    headerView.reviewCount.text = "(" + String(reviewcount) + ")"
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
                
                headerView.btnEdit.addTarget(self, action: #selector(editprofile), for: .touchUpInside)
                return headerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CLICK \(indexPath.row)")
        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
        let productId = productDictionary.object(forKey: "id") as! Int
        let nextVC = DetailVC()
        nextVC.Myid = productId
        delegate?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.productDatas.count - 1 {
            pagenum = pagenum + 1
            getShopData(pagenum: pagenum)
        }
    }
    
    @objc func editprofile() {
        let nextVC = EditProfileVC()
        self.delegate?.navigationController?.pushViewController(nextVC, animated: true)
    }

}

class MyShopCell: BaseCollectionViewCell {
    
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
        backgroundColor = .white
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

class MyShopHeaderCell: BaseCollectionViewCell {
    
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
    
    let star1: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "star_blank")
        return img
    }()
    
    let star2: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "star_blank")
        return img
    }()
    
    let star3: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "star_blank")
        return img
    }()
    
    let star4: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "star_blank")
        return img
    }()
    
    let star5: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "star_blank")
        return img
    }()
    
    let reviewCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()

    let sellerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()

    let sellerIntro: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()

    let followerCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()

    let followerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.text = "Follower"
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()

    let followingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()

    let followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textAlignment = .center
        label.text = "Following"
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()

    let btnEdit: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Edit profile", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textColor = .black
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.black.cgColor
        btn.backgroundColor = .white
        return btn
    }()

    override func setup() {
        backgroundColor = .white
        self.addSubview(shopheadercontentView)

        shopheadercontentView.addSubview(sellerImage)
        shopheadercontentView.addSubview(star1)
        shopheadercontentView.addSubview(star2)
        shopheadercontentView.addSubview(star3)
        shopheadercontentView.addSubview(star4)
        shopheadercontentView.addSubview(star5)
        shopheadercontentView.addSubview(reviewCount)
        shopheadercontentView.addSubview(sellerName)
        shopheadercontentView.addSubview(sellerIntro)
        shopheadercontentView.addSubview(followerCountLabel)
        shopheadercontentView.addSubview(followerLabel)
        shopheadercontentView.addSubview(followingCountLabel)
        shopheadercontentView.addSubview(followingLabel)
        shopheadercontentView.addSubview(btnEdit)

        shopheadercontentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        shopheadercontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        shopheadercontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        shopheadercontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        sellerImage.leadingAnchor.constraint(equalTo: shopheadercontentView.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        sellerImage.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 16).isActive = true
        sellerImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
        sellerImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
        
        star1.leftAnchor.constraint(equalTo: sellerImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        star1.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
        star1.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        star1.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        
        star2.leftAnchor.constraint(equalTo: star1.rightAnchor).isActive = true
        star2.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
        star2.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        star2.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        
        star3.leftAnchor.constraint(equalTo: star2.rightAnchor).isActive = true
        star3.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
        star3.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        star3.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        
        star4.leftAnchor.constraint(equalTo: star3.rightAnchor).isActive = true
        star4.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
        star4.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        star4.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        
        star5.leftAnchor.constraint(equalTo: star4.rightAnchor).isActive = true
        star5.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
        star5.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        star5.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        
        reviewCount.leftAnchor.constraint(equalTo: sellerImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 100).isActive = true
        reviewCount.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 25).isActive = true
//        reviewCount.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
        reviewCount.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true

        sellerName.leftAnchor.constraint(equalTo: sellerImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        sellerName.topAnchor.constraint(equalTo: shopheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 48).isActive = true
//        sellerName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
//        sellerName.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true

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

        btnEdit.leadingAnchor.constraint(equalTo: shopheadercontentView.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 209).isActive = true
        btnEdit.topAnchor.constraint(equalTo: sellerIntro.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 27).isActive = true
        btnEdit.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 148).isActive = true
        btnEdit.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true

    }
}


