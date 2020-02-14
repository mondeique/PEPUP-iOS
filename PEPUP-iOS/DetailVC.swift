//
//  DetailVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class DetailVC: UIViewController{
    
    var productDatas = NSDictionary()
    var deliveryDatas = NSDictionary()
    var sellerDatas = NSDictionary()
    var Myid:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Hello, \(Myid)")
    }
    
    func setup() {
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenWidth, height: screenHeight)))
        
        scrollView.addSubview(productImage)
        scrollView.addSubview(productPrice)
        scrollView.addSubview(btnLike)
        scrollView.addSubview(btnMessage)
        scrollView.addSubview(productName)
        scrollView.addSubview(pepupImage)
        scrollView.addSubview(deliveryLabel)
        scrollView.addSubview(deliveryPriceLabel)
        scrollView.addSubview(mountainLabel)
        scrollView.addSubview(mountainPriceLabel)
        scrollView.addSubview(pepupadImage)
        scrollView.addSubview(sizeLabel)
        scrollView.addSubview(sizeInfoLabel)
        scrollView.addSubview(brandLabel)
        scrollView.addSubview(brandInfoLabel)
        scrollView.addSubview(contentLabel)
        scrollView.addSubview(tagLabel)
        scrollView.addSubview(storeLabel)
        scrollView.addSubview(sellerProfile)
        scrollView.addSubview(sellerNameLabel)
        scrollView.addSubview(sellerSoldLabel)
        scrollView.addSubview(sellerReviewLabel)
        scrollView.addSubview(btnStore)
        scrollView.addSubview(btnReview)
        scrollView.addSubview(btnCart)
        
    
        NSLayoutConstraint(item: productImage, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: productImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 375).isActive = true
        NSLayoutConstraint(item: productImage, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: productImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 375).isActive = true
        
        NSLayoutConstraint(item: productPrice, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: productPrice, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: productPrice, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottomMargin, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: productPrice, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28).isActive = true
        
        NSLayoutConstraint(item: btnMessage, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .rightMargin, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: btnMessage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: btnMessage, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottomMargin, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: btnMessage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: btnLike, attribute: .right, relatedBy: .equal, toItem: btnMessage, attribute: .leftMargin, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: btnLike, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: btnLike, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottomMargin, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: btnLike, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: productName, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: productName, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120).isActive = true
        NSLayoutConstraint(item: productName, attribute: .top, relatedBy: .equal, toItem: productPrice, attribute: .bottomMargin, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: productName, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: pepupImage, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .rightMargin, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: pepupImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: pepupImage, attribute: .top, relatedBy: .equal, toItem: btnMessage, attribute: .bottomMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pepupImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: deliveryLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: deliveryLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: deliveryLabel, attribute: .top, relatedBy: .equal, toItem: productName, attribute: .bottomMargin, multiplier: 1, constant: 32).isActive = true
        NSLayoutConstraint(item: deliveryLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: deliveryPriceLabel, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .rightMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: deliveryPriceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: deliveryPriceLabel, attribute: .top, relatedBy: .equal, toItem: productPrice, attribute: .bottomMargin, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: deliveryPriceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: mountainLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: mountainLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: mountainLabel, attribute: .top, relatedBy: .equal, toItem: deliveryLabel, attribute: .bottomMargin, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: mountainLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: mountainPriceLabel, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .rightMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: mountainPriceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: mountainPriceLabel, attribute: .top, relatedBy: .equal, toItem: deliveryPriceLabel, attribute: .bottomMargin, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: mountainPriceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: pepupadImage, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pepupadImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 375).isActive = true
        NSLayoutConstraint(item: pepupadImage, attribute: .top, relatedBy: .equal, toItem: mountainLabel, attribute: .bottomMargin, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: pepupadImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        
        NSLayoutConstraint(item: sizeLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: sizeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31).isActive = true
        NSLayoutConstraint(item: sizeLabel, attribute: .top, relatedBy: .equal, toItem: pepupadImage, attribute: .bottomMargin, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: sizeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: sizeInfoLabel, attribute: .left, relatedBy: .equal, toItem: sizeLabel, attribute: .rightMargin, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: sizeInfoLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: sizeInfoLabel, attribute: .top, relatedBy: .equal, toItem: pepupadImage, attribute: .bottomMargin, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: sizeInfoLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: brandLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: brandLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 39).isActive = true
        NSLayoutConstraint(item: brandLabel, attribute: .top, relatedBy: .equal, toItem: sizeLabel, attribute: .bottomMargin, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: brandLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: brandInfoLabel, attribute: .left, relatedBy: .equal, toItem: brandLabel, attribute: .rightMargin, multiplier: 1, constant: 32).isActive = true
        NSLayoutConstraint(item: brandInfoLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: brandInfoLabel, attribute: .top, relatedBy: .equal, toItem: sizeInfoLabel, attribute: .bottomMargin, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: brandInfoLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: contentLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: contentLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 266).isActive = true
        NSLayoutConstraint(item: contentLabel, attribute: .top, relatedBy: .equal, toItem: brandLabel, attribute: .bottomMargin, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: contentLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 59).isActive = true
        
        NSLayoutConstraint(item: tagLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: tagLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: tagLabel, attribute: .top, relatedBy: .equal, toItem: contentLabel, attribute: .bottomMargin, multiplier: 1, constant: 24).isActive = true
        NSLayoutConstraint(item: tagLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: storeLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: storeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 94).isActive = true
        NSLayoutConstraint(item: storeLabel, attribute: .top, relatedBy: .equal, toItem: tagLabel, attribute: .bottomMargin, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: storeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: sellerProfile, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: sellerProfile, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56).isActive = true
        NSLayoutConstraint(item: sellerProfile, attribute: .top, relatedBy: .equal, toItem: storeLabel, attribute: .bottomMargin, multiplier: 1, constant: 24).isActive = true
        NSLayoutConstraint(item: sellerProfile, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56).isActive = true
        
        NSLayoutConstraint(item: sellerNameLabel, attribute: .left, relatedBy: .equal, toItem: sellerProfile, attribute: .rightMargin, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: sellerNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 76).isActive = true
        NSLayoutConstraint(item: sellerNameLabel, attribute: .top, relatedBy: .equal, toItem: storeLabel, attribute: .bottomMargin, multiplier: 1, constant: 31).isActive = true
        NSLayoutConstraint(item: sellerNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: sellerReviewLabel, attribute: .left, relatedBy: .equal, toItem: sellerProfile, attribute: .rightMargin, multiplier: 1, constant: 38).isActive = true
        NSLayoutConstraint(item: sellerReviewLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: sellerReviewLabel, attribute: .top, relatedBy: .equal, toItem: sellerNameLabel, attribute: .bottomMargin, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: sellerReviewLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: sellerSoldLabel, attribute: .left, relatedBy: .equal, toItem: sellerReviewLabel, attribute: .rightMargin, multiplier: 1, constant: 44).isActive = true
        NSLayoutConstraint(item: sellerSoldLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: sellerSoldLabel, attribute: .top, relatedBy: .equal, toItem: sellerNameLabel, attribute: .bottomMargin, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: sellerSoldLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: btnStore, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: btnStore, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 375).isActive = true
        NSLayoutConstraint(item: btnStore, attribute: .top, relatedBy: .equal, toItem: sellerReviewLabel, attribute: .bottomMargin, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: btnStore, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56).isActive = true
        
        NSLayoutConstraint(item: btnReview, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: btnReview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 375).isActive = true
        NSLayoutConstraint(item: btnReview, attribute: .top, relatedBy: .equal, toItem: btnStore, attribute: .bottomMargin, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: btnReview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56).isActive = true
        
        NSLayoutConstraint(item: btnCart, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .leftMargin, multiplier: 1, constant: 18).isActive = true
        NSLayoutConstraint(item: btnCart, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 339).isActive = true
        NSLayoutConstraint(item: btnCart, attribute: .top, relatedBy: .equal, toItem: btnReview, attribute: .bottomMargin, multiplier: 1, constant: 42).isActive = true
        NSLayoutConstraint(item: btnCart, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56).isActive = true

        scrollView.contentSize = CGSize(width: screenWidth, height: 1700)
        view.addSubview(scrollView)
        
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/products/" + String(Myid) + "/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json",  "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                self.productDatas = response.object(forKey: "product") as! NSDictionary
                self.deliveryDatas = response.object(forKey: "delivery_policy") as! NSDictionary
                self.sellerDatas = self.productDatas.object(forKey: "seller") as! NSDictionary

                self.setimage()
//                self.setbutton()
                self.setinfo()
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func setimage() {
        if let productImgArray = self.productDatas.object(forKey: "thumbnails") as? Array<NSDictionary> {
            let productUrlDictionary = productImgArray[0] as NSDictionary
            let imageUrlString = productUrlDictionary.object(forKey: "thumbnail") as! String
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let image = UIImage(data: imageData as Data)
            productImage.image = image
        }
        if let sellerImgDic = self.sellerDatas.object(forKey: "profile") as? NSDictionary {
            let sellerUrlString = sellerImgDic.object(forKey: "thumbnail_img") as! String
            let imageUrl:NSURL = NSURL(string: sellerUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let image = UIImage(data: imageData as Data)
            sellerProfile.image = image
        }
    }
    
    func setinfo() {
        if let price = self.productDatas.object(forKey: "price") as? Int {
            productPrice.text = String(price)
        }
        if let name = self.productDatas.object(forKey: "name") as? String {
            productName.text = name
        }
        if let delivery = self.deliveryDatas.object(forKey: "general") as? Int {
            deliveryPriceLabel.text = String(delivery)
        }
        if let mountain = self.deliveryDatas.object(forKey: "mountain") as? Int {
            mountainPriceLabel.text = String(mountain)
        }
        if let brandDic = self.productDatas.object(forKey: "brand") as? NSDictionary {
            let brand = brandDic.object(forKey: "name") as! String
            brandInfoLabel.text = brand
        }
        if let size = self.productDatas.object(forKey: "size") as? String {
            sizeInfoLabel.text = size
        }
        if let content = self.productDatas.object(forKey: "content") as? String {
            contentLabel.text = content
        }
        if let nickname = self.sellerDatas.object(forKey: "nickname") as? String {
            sellerNameLabel.text = nickname
        }
        if let review = self.sellerDatas.object(forKey: "reviews") as? Int {
            sellerReviewLabel.text = String(review)
        }
        if let sold = self.sellerDatas.object(forKey: "sold") as? Int {
            sellerSoldLabel.text = String(sold)
        }
    }
    
    let productImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    let productPrice: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnLike: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "home_unselected"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        return btn
    }()
    
    let btnMessage: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "home_unselected"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        return btn
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pepupImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "home_unselected")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let deliveryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "배송비"
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deliveryPriceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mountainLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "도서산간지역"
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mountainPriceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pepupadImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pepup_AD")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Size"
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sizeInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Brand"
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let brandInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.text = "Tag"
        label.backgroundColor = .white
        return label
    }()
    
    let storeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 17)
        label.text = "STORE INFO"
        return label
    }()
    
    let sellerProfile: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let sellerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sellerSoldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sellerReviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnStore: UIButton = {
        let btn = UIButton()
        btn.setTitle("Store", for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.textAlignment = .left
        btn.titleLabel?.textColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        btn.addTarget(self, action: #selector(store), for: .touchUpInside)
        return btn
    }()
    
    let btnReview: UIButton = {
        let btn = UIButton()
        btn.setTitle("Review", for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.backgroundColor = .white
        btn.titleLabel?.textColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        btn.addTarget(self, action: #selector(review), for: .touchUpInside)
        return btn
    }()
    
    let btnCart: UIButton = {
        let btn = UIButton()
        btn.setTitle("카트 담기", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        btn.addTarget(self, action: #selector(review), for: .touchUpInside)
        return btn
    }()

}

