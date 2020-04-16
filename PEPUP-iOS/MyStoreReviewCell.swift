//
//  MyStoreReviewCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/24.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire
import Cosmos

class MyStoreReviewCell: BaseCollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private let reviewcellId = "myreviewcell"
    private let reviewheaderId = "myreviewheadercell"
    
    weak var delegate : MyStoreVC?
    
    var pagenum : Int = 1
    
    var SellerID = UserDefaults.standard.object(forKey: "pk") as! Int
    var sellerInfoDatas = NSDictionary()
    var reviewDatas = Array<NSDictionary>()
    
    let reviewcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width/667 * 114))
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 149)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - UIScreen.main.bounds.height/667 * 130), collectionViewLayout: layout)
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
        getReviewData(pagenum: 1)
        refreshControl.endRefreshing()
    }
    
    override func setup() {
        backgroundColor = .white
        self.addSubview(reviewcollectionView)
        
        getReviewData(pagenum: 1)
        reviewcollectionView.delegate = self
        reviewcollectionView.dataSource = self
        reviewcollectionView.register(MyReviewCell.self, forCellWithReuseIdentifier: reviewcellId)
        reviewcollectionView.register(MyReviewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reviewheaderId)
        
        reviewcollectionView.addSubview(refreshControl)
        
    }
    
    func getReviewData(pagenum : Int) {
        
        print(SellerID)
        Alamofire.AF.request("\(Config.baseURL)/api/store/review/" + String(SellerID) + "/?page=" + String(pagenum), method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                self.sellerInfoDatas = response
                let resultsArray = self.sellerInfoDatas.object(forKey: "results") as! Array<NSDictionary>
                for i in 0..<resultsArray.count {
                    self.reviewDatas.append(resultsArray[i])
                }
                DispatchQueue.main.async {
                    self.reviewcollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reviewDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewcellId, for: indexPath) as! MyReviewCell
        let reviewDictionary = self.reviewDatas[indexPath.row] as NSDictionary
        if let satisfactions = reviewDictionary.object(forKey: "satisfaction") as? Int {
            cell.cosmosView.rating = Double(satisfactions)
        }
        let buyerName = reviewDictionary.object(forKey: "buyer_name") as! String
        if let context = reviewDictionary.object(forKey: "context") as? String {
            cell.reviewcontentLabel.text = context
        }
        if let productImgUrlString = reviewDictionary.object(forKey: "thumbnail") as? String {
            let productimageUrl:NSURL = NSURL(string: productImgUrlString)!
            let productimageData:NSData = NSData(contentsOf: productimageUrl as URL)!
            let productimage = UIImage(data: productimageData as Data)
            cell.productImg.image = productimage
        }
        if let imageUrlString = reviewDictionary.object(forKey: "buyer_profile") as? String {
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let image = UIImage(data: imageData as Data)
            DispatchQueue.main.async {
                cell.buyerName.text = buyerName
                cell.buyerImage.image = image
                cell.buyerImage.layer.cornerRadius = cell.buyerImage.frame.height / 2
                cell.buyerImage.layer.borderColor = UIColor.clear.cgColor
                cell.buyerImage.layer.borderWidth = 1
                cell.buyerImage.clipsToBounds = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {

            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reviewheaderId, for: indexPath) as! MyReviewHeaderCell
                if let sellerInfoDic = self.sellerInfoDatas.object(forKey: "info") as? NSDictionary {
                    let nickname = sellerInfoDic.object(forKey: "nickname") as! String
                    if let satisfactions = sellerInfoDic.object(forKey: "review_score") as? Int {
                        headerView.cosmosView.rating = Double(satisfactions)
                    }
                    if let imageUrlString = sellerInfoDic.object(forKey: "profile") as? String {
                        let imageUrl:NSURL = NSURL(string: imageUrlString)!
                        let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData as Data)
                            headerView.sellerImage.image = image
                            headerView.sellerName.text = nickname
                            headerView.sellerImage.layer.cornerRadius = headerView.sellerImage.frame.height / 2
                            headerView.sellerImage.layer.borderColor = UIColor.clear.cgColor
                            headerView.sellerImage.layer.borderWidth = 1
                            headerView.sellerImage.layer.masksToBounds = false
                            headerView.sellerImage.clipsToBounds = true
                        }
                    }
                }
                return headerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.reviewDatas.count - 1 {
            pagenum = pagenum + 1
            getReviewData(pagenum: pagenum)
        }
    }
}

class MyReviewCell: BaseCollectionViewCell {

    let reviewcellcontentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/667 * 114))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buyerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let buyerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        label.textAlignment = .left
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    let cosmosView: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.settings.starSize = Double(UIScreen.main.bounds.width/375 * 16)
        view.settings.emptyColor = UIColor(rgb: 0xEBEBF6)
        view.settings.emptyBorderColor = UIColor(rgb: 0xEBEBF6)
        view.settings.filledBorderColor = .black
        view.settings.filledColor = .black
        view.settings.updateOnTouch = false
        return view
    }()

    let productImg: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let reviewcontentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

    override func setup() {
        backgroundColor = .white
        reviewcellcontentView.addSubview(buyerImage)
        reviewcellcontentView.addSubview(buyerName)
        reviewcellcontentView.addSubview(cosmosView)
        reviewcellcontentView.addSubview(reviewcontentLabel)
        reviewcellcontentView.addSubview(productImg)
        self.addSubview(reviewcellcontentView)

        reviewcellcontentViewLayout()
        buyerImageLayout()
        buyerNameLayout()
        cosmosViewLayout()
        reviewcontentLabelLayout()
        productImgLayout()
    }

    func reviewcellcontentViewLayout() {
        reviewcellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        reviewcellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        reviewcellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        reviewcellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func buyerImageLayout() {
        buyerImage.leftAnchor.constraint(equalTo:reviewcellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        buyerImage.topAnchor.constraint(equalTo:reviewcellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 16).isActive = true
        buyerImage.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 24).isActive = true
        buyerImage.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 24).isActive = true
    }
    
    func buyerNameLayout() {
        buyerName.leftAnchor.constraint(equalTo:buyerImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        buyerName.topAnchor.constraint(equalTo:reviewcellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
//        buyerName.widthAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
        buyerName.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    func cosmosViewLayout() {
        cosmosView.leftAnchor.constraint(equalTo:reviewcellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        cosmosView.topAnchor.constraint(equalTo:buyerName.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
//        cosmosView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 80).isActive = true
        cosmosView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
    }
    
    func reviewcontentLabelLayout() {
        reviewcontentLabel.leftAnchor.constraint(equalTo:reviewcellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        reviewcontentLabel.topAnchor.constraint(equalTo:cosmosView.topAnchor, constant: UIScreen.main.bounds.height/667 * 6).isActive = true
        reviewcontentLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 226).isActive = true
        reviewcontentLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 32).isActive = true
    }

    func productImgLayout() {
        productImg.rightAnchor.constraint(equalTo:reviewcellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        productImg.topAnchor.constraint(equalTo:reviewcellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 16).isActive = true
        productImg.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 82).isActive = true
        productImg.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 82).isActive = true
    }
    
}

class MyReviewHeaderCell: BaseCollectionViewCell {
    
    let reviewheadercontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let sellerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let cosmosView: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.settings.starSize = Double(UIScreen.main.bounds.width/375 * 16)
        view.settings.emptyColor = UIColor(rgb: 0xEBEBF6)
        view.settings.filledColor = .black
        view.settings.emptyBorderColor = UIColor(rgb: 0xEBEBF6)
        view.settings.filledBorderColor = .black
        view.settings.updateOnTouch = false
        return view
    }()

    let sellerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        label.textAlignment = .left
        return label
    }()
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()

    override func setup() {
        backgroundColor = .white
        self.addSubview(reviewheadercontentView)

        reviewheadercontentView.addSubview(sellerImage)
        reviewheadercontentView.addSubview(sellerName)
        reviewheadercontentView.addSubview(cosmosView)
        reviewheadercontentView.addSubview(lineLabel)

        reviewheadercontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        reviewheadercontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        reviewheadercontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        reviewheadercontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

//        sellerImage.leadingAnchor.constraint(equalTo: reviewheadercontentView.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        sellerImage.centerXAnchor.constraint(equalTo: reviewheadercontentView.centerXAnchor).isActive = true
        sellerImage.topAnchor.constraint(equalTo: reviewheadercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 31).isActive = true
        sellerImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        sellerImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
//        sellerName.leftAnchor.constraint(equalTo: sellerImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        sellerName.centerXAnchor.constraint(equalTo: reviewheadercontentView.centerXAnchor).isActive = true
        sellerName.topAnchor.constraint(equalTo: sellerImage.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
//        sellerName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 64).isActive = true
        sellerName.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
        
        cosmosView.centerXAnchor.constraint(equalTo: reviewheadercontentView.centerXAnchor).isActive = true
        cosmosView.topAnchor.constraint(equalTo: sellerName.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
//        cosmosView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 80).isActive = true
        cosmosView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        
//        lineLabel.leftAnchor.constraint(equalTo: star4.rightAnchor).isActive = true
        lineLabel.centerXAnchor.constraint(equalTo: reviewheadercontentView.centerXAnchor).isActive = true
        lineLabel.bottomAnchor.constraint(equalTo: reviewheadercontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 339).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 1).isActive = true
        
    }
}


