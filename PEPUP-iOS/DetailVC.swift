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
    
    var responseDatas = NSDictionary()
    var productDatas = NSDictionary()
    var deliveryDatas = NSDictionary()
    var sellerDatas = NSDictionary()
    var productimageArray = Array<String>()
    var Myid:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setup() {
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        var scrollView: UIScrollView!
        
        navcontentView.addSubview(btnBack)
//        navcontentView.addSubview(sellerNameLabel)
        contentView.addSubview(btnCart)
        contentView.addSubview(btnCartBag)
        
        view.addSubview(navcontentView)
        view.addSubview(contentView)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
//        sellerNameLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
//        sellerNameLabel.leftAnchor.constraint(equalTo: navcontentView.leftAnchor).isActive = true
//        sellerNameLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * 567).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        btnCart.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        btnCart.widthAnchor.constraint(equalToConstant: 337).isActive = true
        btnCart.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnCart.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        btnCart.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
        btnCartBag.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        btnCartBag.widthAnchor.constraint(equalToConstant: 337).isActive = true
        btnCartBag.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnCartBag.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        btnCartBag.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
        scrollView = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: navBarHeight+statusBarHeight), size: CGSize(width: screenWidth, height: screenHeight-100)))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollView.contentInset = UIEdgeInsets.zero
        view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeight + statusBarHeight).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (screenHeight/defaultHeight) * -100.0).isActive = true
        
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight/defaultHeight * 1300)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        
        scrollView.addSubview(productImage)
        scrollView.addSubview(discountRate)
        scrollView.addSubview(productPrice)
        scrollView.addSubview(pricewonLabel)
        scrollView.addSubview(btnLike)
        scrollView.addSubview(btnMessage)
        scrollView.addSubview(productName)
        scrollView.addSubview(pepupImage)
        scrollView.addSubview(lineLabel1)
        scrollView.addSubview(deliveryLabel)
        scrollView.addSubview(deliveryPriceLabel)
        scrollView.addSubview(mountainLabel)
        scrollView.addSubview(mountainPriceLabel)
        scrollView.addSubview(lineLabelAD)
        scrollView.addSubview(pepupadImage)
        scrollView.addSubview(sizeLabel)
        scrollView.addSubview(sizeInfoLabel)
        scrollView.addSubview(brandLabel)
        scrollView.addSubview(brandInfoLabel)
        scrollView.addSubview(contentLabel)
        scrollView.addSubview(tagLabel)
        scrollView.addSubview(tagButton)
        scrollView.addSubview(storeinfoLabel)
        scrollView.addSubview(sellerProfile)
        scrollView.addSubview(sellerStarImage)
        scrollView.addSubview(sellerNameLabel)
        scrollView.addSubview(sellerSoldLabel)
        scrollView.addSubview(sellerReviewLabel)
        scrollView.addSubview(lineLabel2)
        scrollView.addSubview(storeLabel)
        scrollView.addSubview(btnStore)
        scrollView.addSubview(lineLabel3)
        scrollView.addSubview(reviewLabel)
        scrollView.addSubview(btnReview)
        scrollView.addSubview(lineLabel4)
        
    
        NSLayoutConstraint(item: productImage, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: productImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth).isActive = true
        NSLayoutConstraint(item: productImage, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: productImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth).isActive = true
        NSLayoutConstraint(item: productImage, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: btnLike, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 279).isActive = true
//        NSLayoutConstraint(item: btnLike, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: btnLike, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 8).isActive = true
//        NSLayoutConstraint(item: btnLike, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: btnMessage, attribute: .left, relatedBy: .equal, toItem: btnLike, attribute: .right, multiplier: 1, constant: screenWidth/defaultWidth * 8).isActive = true
//        NSLayoutConstraint(item: btnMessage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: btnMessage, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 8).isActive = true
//        NSLayoutConstraint(item: btnMessage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: discountRate, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//        NSLayoutConstraint(item: discountRate, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: discountRate, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 16).isActive = true
//        NSLayoutConstraint(item: discountRate, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28).isActive = true
        
        if discountRate.isHidden == false {
            NSLayoutConstraint(item: productPrice, attribute: .left, relatedBy: .equal, toItem: discountRate, attribute: .right, multiplier: 1, constant: screenWidth/defaultWidth * 6).isActive = true
            NSLayoutConstraint(item: productPrice, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
            NSLayoutConstraint(item: productPrice, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 16).isActive = true
//            NSLayoutConstraint(item: productPrice, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28).isActive = true
        }
        else {
            NSLayoutConstraint(item: productPrice, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
            NSLayoutConstraint(item: productPrice, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
            NSLayoutConstraint(item: productPrice, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 16).isActive = true
//            NSLayoutConstraint(item: productPrice, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28).isActive = true
        }
        
        // TODO: - 원 안뜸..
        NSLayoutConstraint(item: pricewonLabel, attribute: .left, relatedBy: .equal, toItem: productPrice, attribute: .right, multiplier: 1, constant: screenWidth/defaultWidth * 2).isActive = true
        NSLayoutConstraint(item: pricewonLabel, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 21).isActive = true
        
        NSLayoutConstraint(item: productName, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//        NSLayoutConstraint(item: productName, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: productName, attribute: .top, relatedBy: .equal, toItem: productPrice, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
//        NSLayoutConstraint(item: productName, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: pepupImage, attribute: .left, relatedBy: .equal, toItem: btnLike, attribute: .right, multiplier: 1, constant: screenWidth/defaultWidth * 8).isActive = true
//        NSLayoutConstraint(item: pepupImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: pepupImage, attribute: .top, relatedBy: .equal, toItem: productPrice, attribute: .bottom, multiplier: 1, constant: 4).isActive = true
//        NSLayoutConstraint(item: pepupImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: lineLabel1, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
        NSLayoutConstraint(item: lineLabel1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth/defaultWidth * 339).isActive = true
        NSLayoutConstraint(item: lineLabel1, attribute: .top, relatedBy: .equal, toItem: productName, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 16).isActive = true
        NSLayoutConstraint(item: lineLabel1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: lineLabel1, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: deliveryLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//        NSLayoutConstraint(item: deliveryLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: deliveryLabel, attribute: .top, relatedBy: .equal, toItem: lineLabel1, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 15).isActive = true
//        NSLayoutConstraint(item: deliveryLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        NSLayoutConstraint(item: deliveryPriceLabel, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: screenWidth/defaultWidth * 357).isActive = true
//        NSLayoutConstraint(item: deliveryPriceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: deliveryPriceLabel, attribute: .top, relatedBy: .equal, toItem: lineLabel1, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 15).isActive = true
//        NSLayoutConstraint(item: deliveryPriceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: mountainLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//        NSLayoutConstraint(item: mountainLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: mountainLabel, attribute: .top, relatedBy: .equal, toItem: deliveryLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 4).isActive = true
//        NSLayoutConstraint(item: mountainLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: mountainPriceLabel, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: screenWidth/defaultWidth * 357).isActive = true
//        NSLayoutConstraint(item: mountainPriceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: mountainPriceLabel, attribute: .top, relatedBy: .equal, toItem: deliveryPriceLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 4).isActive = true
//        NSLayoutConstraint(item: mountainPriceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true

        NSLayoutConstraint(item: pepupadImage, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: pepupadImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth).isActive = true
        NSLayoutConstraint(item: pepupadImage, attribute: .top, relatedBy: .equal, toItem: mountainLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 16).isActive = true
        NSLayoutConstraint(item: pepupadImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: pepupadImage, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: lineLabelAD, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
        NSLayoutConstraint(item: lineLabelAD, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth/defaultWidth * 339).isActive = true
        NSLayoutConstraint(item: lineLabelAD, attribute: .top, relatedBy: .equal, toItem: mountainLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 36).isActive = true
        NSLayoutConstraint(item: lineLabelAD, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: lineLabelAD, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        if pepupImage.isHidden == true {
            NSLayoutConstraint(item: sizeLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//            NSLayoutConstraint(item: sizeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 31).isActive = true
            NSLayoutConstraint(item: sizeLabel, attribute: .top, relatedBy: .equal, toItem: mountainLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 76).isActive = true
//            NSLayoutConstraint(item: sizeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true

            NSLayoutConstraint(item: sizeInfoLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: screenWidth/defaultWidth * 89).isActive = true
//            NSLayoutConstraint(item: sizeInfoLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
            NSLayoutConstraint(item: sizeInfoLabel, attribute: .top, relatedBy: .equal, toItem: mountainLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 76).isActive = true
//            NSLayoutConstraint(item: sizeInfoLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        }
        else {
            NSLayoutConstraint(item: sizeLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//            NSLayoutConstraint(item: sizeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth/defaultWidth * 31).isActive = true
            NSLayoutConstraint(item: sizeLabel, attribute: .top, relatedBy: .equal, toItem: pepupadImage, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 40).isActive = true
//            NSLayoutConstraint(item: sizeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenHeight/defaultHeight * 19).isActive = true

            NSLayoutConstraint(item: sizeInfoLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: screenWidth/defaultWidth * 89).isActive = true
//            NSLayoutConstraint(item: sizeInfoLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
            NSLayoutConstraint(item: sizeInfoLabel, attribute: .top, relatedBy: .equal, toItem: pepupadImage, attribute: .bottom, multiplier: 1, constant: screenWidth/defaultWidth * 40).isActive = true
//            NSLayoutConstraint(item: sizeInfoLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        }
        
        NSLayoutConstraint(item: brandLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//        NSLayoutConstraint(item: brandLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 39).isActive = true
        NSLayoutConstraint(item: brandLabel, attribute: .top, relatedBy: .equal, toItem: sizeLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 4).isActive = true
//        NSLayoutConstraint(item: brandLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: brandInfoLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: screenWidth/defaultWidth * 89).isActive = true
//        NSLayoutConstraint(item: brandInfoLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: brandInfoLabel, attribute: .top, relatedBy: .equal, toItem: sizeInfoLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 4).isActive = true
//        NSLayoutConstraint(item: brandInfoLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: contentLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
        NSLayoutConstraint(item: contentLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth/defaultWidth * 339).isActive = true
        NSLayoutConstraint(item: contentLabel, attribute: .top, relatedBy: .equal, toItem: brandLabel, attribute: .bottom, multiplier: 1, constant: screenWidth/defaultWidth * 16).isActive = true
        NSLayoutConstraint(item: contentLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenHeight/defaultHeight * 59).isActive = true
        
        NSLayoutConstraint(item: tagLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 20).isActive = true
//        NSLayoutConstraint(item: tagLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: tagLabel, attribute: .top, relatedBy: .equal, toItem: contentLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 24).isActive = true
//        NSLayoutConstraint(item: tagLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: tagButton, attribute: .left, relatedBy: .equal, toItem: tagLabel, attribute: .right, multiplier: 1, constant: screenWidth/defaultWidth * 16).isActive = true
//        NSLayoutConstraint(item: tagButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: tagButton, attribute: .top, relatedBy: .equal, toItem: contentLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 22).isActive = true
//        NSLayoutConstraint(item: tagButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: storeinfoLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//        NSLayoutConstraint(item: storeinfoLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 94).isActive = true
        NSLayoutConstraint(item: storeinfoLabel, attribute: .top, relatedBy: .equal, toItem: tagLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 107).isActive = true
//        NSLayoutConstraint(item: storeinfoLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: sellerProfile, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
        NSLayoutConstraint(item: sellerProfile, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56).isActive = true
        NSLayoutConstraint(item: sellerProfile, attribute: .top, relatedBy: .equal, toItem: storeinfoLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 24).isActive = true
        NSLayoutConstraint(item: sellerProfile, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56).isActive = true
        
        NSLayoutConstraint(item: sellerNameLabel, attribute: .left, relatedBy: .equal, toItem: sellerProfile, attribute: .right, multiplier: 1, constant: screenWidth/defaultWidth * 16).isActive = true
//        NSLayoutConstraint(item: sellerNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 76).isActive = true
        NSLayoutConstraint(item: sellerNameLabel, attribute: .top, relatedBy: .equal, toItem: storeinfoLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 31).isActive = true
//        NSLayoutConstraint(item: sellerNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: sellerStarImage, attribute: .left, relatedBy: .equal, toItem: sellerProfile, attribute: .right, multiplier: 1, constant: screenWidth/defaultWidth * 16).isActive = true
//        NSLayoutConstraint(item: sellerStarImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 76).isActive = true
        NSLayoutConstraint(item: sellerStarImage, attribute: .top, relatedBy: .equal, toItem: sellerNameLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 5).isActive = true
//        NSLayoutConstraint(item: sellerStarImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: sellerReviewLabel, attribute: .left, relatedBy: .equal, toItem: sellerStarImage, attribute: .right, multiplier: 1, constant: screenWidth/defaultWidth * 6).isActive = true
//        NSLayoutConstraint(item: sellerReviewLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: sellerReviewLabel, attribute: .top, relatedBy: .equal, toItem: sellerNameLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 4).isActive = true
//        NSLayoutConstraint(item: sellerReviewLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: sellerSoldLabel, attribute: .left, relatedBy: .equal, toItem: sellerReviewLabel, attribute: .right, multiplier: 1, constant: screenWidth/defaultWidth * 20).isActive = true
//        NSLayoutConstraint(item: sellerSoldLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 36).isActive = true
        NSLayoutConstraint(item: sellerSoldLabel, attribute: .top, relatedBy: .equal, toItem: sellerNameLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 4).isActive = true
//        NSLayoutConstraint(item: sellerSoldLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19).isActive = true
        
        NSLayoutConstraint(item: lineLabel2, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
        NSLayoutConstraint(item: lineLabel2, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth/defaultWidth * 339).isActive = true
        NSLayoutConstraint(item: lineLabel2, attribute: .top, relatedBy: .equal, toItem: sellerReviewLabel, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 30).isActive = true
        NSLayoutConstraint(item: lineLabel2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: lineLabel2, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: storeLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//        NSLayoutConstraint(item: storeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45).isActive = true
        NSLayoutConstraint(item: storeLabel, attribute: .top, relatedBy: .equal, toItem: lineLabel2, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 18).isActive = true
//        NSLayoutConstraint(item: storeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: btnStore, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 348).isActive = true
//        NSLayoutConstraint(item: btnStore, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 9).isActive = true
        NSLayoutConstraint(item: btnStore, attribute: .top, relatedBy: .equal, toItem: lineLabel2, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 18).isActive = true
//        NSLayoutConstraint(item: btnStore, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: lineLabel3, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
        NSLayoutConstraint(item: lineLabel3, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth/defaultWidth * 339).isActive = true
        NSLayoutConstraint(item: lineLabel3, attribute: .top, relatedBy: .equal, toItem: btnStore, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 20).isActive = true
        NSLayoutConstraint(item: lineLabel3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: lineLabel3, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
         NSLayoutConstraint(item: reviewLabel, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
//        NSLayoutConstraint(item: reviewLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45).isActive = true
        NSLayoutConstraint(item: reviewLabel, attribute: .top, relatedBy: .equal, toItem: lineLabel3, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 17).isActive = true
//        NSLayoutConstraint(item: reviewLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: btnReview, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 348).isActive = true
//        NSLayoutConstraint(item: btnReview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 9).isActive = true
        NSLayoutConstraint(item: btnReview, attribute: .top, relatedBy: .equal, toItem: btnStore, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 40).isActive = true
//        NSLayoutConstraint(item: btnReview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: lineLabel4, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: screenWidth/defaultWidth * 18).isActive = true
        NSLayoutConstraint(item: lineLabel4, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenHeight/defaultHeight * 339).isActive = true
        NSLayoutConstraint(item: lineLabel4, attribute: .top, relatedBy: .equal, toItem: btnReview, attribute: .bottom, multiplier: 1, constant: screenHeight/defaultHeight * 20).isActive = true
        NSLayoutConstraint(item: lineLabel4, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: lineLabel4, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/products/" + String(Myid) + "/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json",  "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                self.responseDatas = response
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
        if let productImgArray = self.productDatas.object(forKey: "images") as? Array<NSDictionary> {
            for i in 0..<productImgArray.count {
                let productUrlDictionary = productImgArray[i] as NSDictionary
                let imageUrlString = productUrlDictionary.object(forKey: "image") as! String
                productimageArray.append(imageUrlString)
            }
            let imageUrl:NSURL = NSURL(string: productimageArray[0])!
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
        if let is_liked = self.responseDatas.object(forKey: "liked") as? Bool {
            if is_liked == true {
                btnLike.setImage(UIImage(named: "btnLike_fill"), for: .normal)
            }
            else {
                btnLike.setImage(UIImage(named: "btnLike"), for: .normal)
            }
        }
        if let is_bagged = self.responseDatas.object(forKey: "isbagged") as? Bool {
            if is_bagged == true {
                btnCart.isHidden = true
                btnCartBag.isHidden = false
            }
            else {
                btnCart.isHidden = false
                btnCartBag.isHidden = true
            }
        }
        if let is_refundable = self.productDatas.object(forKey: "is_refundable") as? Bool {
            if is_refundable == true {
                pepupImage.isHidden = false
                pepupadImage.isHidden = false
            }
            else {
                pepupImage.isHidden = true
                pepupadImage.isHidden = true
            }
        }
        setup()
    }
    
    func setinfo() {
        if let discounted_rate = self.productDatas.object(forKey: "discount_rate") as? Float64 {
            if discounted_rate == 0.0 {
                discountRate.isHidden = true
            }
            else {
                discountRate.isHidden = false
                discountRate.text = String(Int(discounted_rate * 100.0)) + "%"
            }
        }
        
        if let price = self.productDatas.object(forKey: "discounted_price") as? Int {
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
        if let tag = self.productDatas.object(forKey: "tag") as? Array<NSDictionary> {
            let tag_0 = tag[0]
            let tagId = tag_0.object(forKey: "id") as! Int
            let tagName = tag_0.object(forKey: "tag") as! String
            tagButton.setTitle(tagName, for: .normal)
            tagButton.tag = tagId
            tagButton.addTarget(self, action: #selector(tag(_:)), for: .touchUpInside)
            
        }
        if let nickname = self.sellerDatas.object(forKey: "nickname") as? String {
            sellerNameLabel.text = nickname
        }
        if let review = self.sellerDatas.object(forKey: "review_score") as? Int {
            sellerReviewLabel.text = String(review) + " / 5"
        }
        if let sold = self.sellerDatas.object(forKey: "sold") as? Int {
            sellerSoldLabel.text = "SOLD " + String(sold)
        }
        setup()
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func like() {
        if btnLike.currentImage == UIImage(named: "btnLike") {
            btnLike.setImage(UIImage(named: "btnLike_fill"), for: .normal)
            Alamofire.AF.request("\(Config.baseURL)/api/products/like/" + String(Myid) + "/", method: .post, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                            
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
        else if btnLike.currentImage == UIImage(named: "btnLike_fill") {
            btnLike.setImage(UIImage(named: "btnLike"), for: .normal)
            Alamofire.AF.request("\(Config.baseURL)/api/products/like/" + String(Myid) + "/", method: .post, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                            
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
    
    @objc func message() {
        print("TOUCH MESSAGE")
    }
    
    @objc func store() {
        let sellerId = self.sellerDatas.object(forKey: "id") as! Int
        UserDefaults.standard.set(sellerId, forKey: "sellerId")
        let pk = UserDefaults.standard.object(forKey: "pk") as! Int
        if sellerId == pk {
            print("I am seller~")
        }
        else {
            let nextVC = TestStoreVC()
            let nextCell = PageCell()
            nextVC.SellerID = sellerId
            nextCell.SellerID = sellerId
            navigationController?.pushViewController(nextVC, animated: true)
            print("I am not me")
        }
    }
    
    @objc func review() {
        print("TOUCH REVIEW")
    }
    
    @objc func cart() {
        if btnCart.isHidden == false {
            btnCart.isHidden = true
            btnCartBag.isHidden = false
            btnCartBag.isEnabled = false
            btnCart.isEnabled = false
        }
        else {
            btnCart.isEnabled = false
            btnCartBag.isEnabled = false
        }
        Alamofire.AF.request("\(Config.baseURL)/api/trades/bagging/" + String(Myid) + "/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        print("TOUCH CART")
    }
    
    @objc func tag(_ sender: UIButton) {
        let nextVC = TagVC()
        nextVC.TagID = sender.tag
        nextVC.TagName = sender.currentTitle
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    let navcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let btnBack: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnBack"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let productImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let discountRate: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xD8FF00)
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.isHidden = true
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.sizeToFit()
        return label
    }()
    
    let pricewonLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnLike: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnLike"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(like), for: .touchUpInside)
        return btn
    }()
    
    let btnMessage: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnMessage"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(message), for: .touchUpInside)
        return btn
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let pepupImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "pepup_img")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let lineLabel1: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deliveryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "배송비"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deliveryPriceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mountainLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "도서산간지역"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mountainPriceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lineLabelAD: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pepupadImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pepup_AD")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Size"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let sizeInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Brand"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let brandInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.textColor = .black
        label.text = "Tag"
        label.backgroundColor = .white
        return label
    }()
    
    let tagButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        btn.titleLabel?.textColor = .black
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        return btn
    }()
    
    let storeinfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.text = "STORE INFO"
        label.sizeToFit()
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
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sellerStarImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Star")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let sellerSoldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sellerReviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lineLabel2: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let storeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Store"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let btnStore: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnGO"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(store), for: .touchUpInside)
        return btn
    }()
    
    let lineLabel3: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Review"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let btnReview: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnGO"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(review), for: .touchUpInside)
        return btn
    }()
    
    let lineLabel4: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnCart: UIButton = {
        let btn = UIButton()
        btn.setTitle("카트 담기", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.addTarget(self, action: #selector(cart), for: .touchUpInside)
        btn.isHidden = false
        return btn
    }()
    
    let btnCartBag: UIButton = {
        let btn = UIButton()
        btn.setTitle("담겨 있어요!", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.black.cgColor
        btn.addTarget(self, action: #selector(cart), for: .touchUpInside)
        btn.isHidden = false
        return btn
    }()

}

