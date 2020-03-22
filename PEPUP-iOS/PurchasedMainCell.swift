//
//  PurchasedCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/20.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class PurchasedMainCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        purchasecellContentView.addSubview(productImage)
        purchasecellContentView.addSubview(productNameLabel)
        purchasecellContentView.addSubview(productSizeLabel)
        purchasecellContentView.addSubview(productPriceLabel)
        self.addSubview(purchasecellContentView)

        purchasecellContentViewLayout()
        productImageLayout()
        productNameLabelLayout()
        productSizeLabelLayout()
        productPriceLabelLayout()

    }
    
    let purchasecellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.backgroundColor = .white
        return label
    }()

    func purchasecellContentViewLayout() {
        purchasecellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        purchasecellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        purchasecellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        purchasecellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productImageLayout() {
        productImage.leftAnchor.constraint(equalTo:purchasecellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productImage.topAnchor.constraint(equalTo:purchasecellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
        productImage.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 60).isActive = true
        productImage.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 60).isActive = true
    }

    func productNameLabelLayout() {
        productNameLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        productNameLabel.topAnchor.constraint(equalTo:purchasecellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 10).isActive = true
//        productNameLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 150).isActive = true
        productNameLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true
    }

    func productSizeLabelLayout() {
        productSizeLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        productSizeLabel.topAnchor.constraint(equalTo:productNameLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 4).isActive = true
//        productSizeLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
        productSizeLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true
    }

    func productPriceLabelLayout() {
        productPriceLabel.rightAnchor.constraint(equalTo:purchasecellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productPriceLabel.topAnchor.constraint(equalTo:purchasecellContentView.topAnchor, constant:10).isActive = true
//        productPriceLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
        productPriceLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 20).isActive = true
    }
}

class PurchasedMainHeaderCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        purchaseheadercellContentView.addSubview(sellerProfileImg)
        purchaseheadercellContentView.addSubview(sellerNameLabel)
        purchaseheadercellContentView.addSubview(btnConfirm)
        purchaseheadercellContentView.addSubview(btnReview)
        self.addSubview(purchaseheadercellContentView)

        purchaseheadercellContentViewLayout()
        sellerProfileImgLayout()
        sellerNameLabelLayout()
        btnConfirmLayout()
        btnReviewLayout()
    }
    
    let purchaseheadercellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let sellerProfileImg:UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let sellerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnConfirm: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.red, for: .normal)
        btn.setTitle("수령 확인", for: .normal)
        btn.layer.borderColor = UIColor.red.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        return btn
    }()
    
    let btnReview: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("리뷰 작성", for: .normal)
        btn.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        return btn
    }()

    func purchaseheadercellContentViewLayout() {
        purchaseheadercellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        purchaseheadercellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        purchaseheadercellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        purchaseheadercellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func sellerProfileImgLayout() {
        sellerProfileImg.leftAnchor.constraint(equalTo:purchaseheadercellContentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        sellerProfileImg.topAnchor.constraint(equalTo:purchaseheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
        sellerProfileImg.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        sellerProfileImg.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        sellerProfileImg.centerYAnchor.constraint(equalTo:purchaseheadercellContentView.centerYAnchor).isActive = true
    }
    
    func sellerNameLabelLayout() {
        sellerNameLabel.leftAnchor.constraint(equalTo:sellerProfileImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 10).isActive = true
        sellerNameLabel.topAnchor.constraint(equalTo:purchaseheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        sellerNameLabel.centerYAnchor.constraint(equalTo:purchaseheadercellContentView.centerYAnchor).isActive = true
    }
    
    func btnConfirmLayout() {
        btnConfirm.rightAnchor.constraint(equalTo:purchaseheadercellContentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        btnConfirm.topAnchor.constraint(equalTo:purchaseheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 14).isActive = true
        btnConfirm.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 96).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true
        btnConfirm.centerYAnchor.constraint(equalTo:purchaseheadercellContentView.centerYAnchor).isActive = true
    }
    
    func btnReviewLayout() {
        btnReview.rightAnchor.constraint(equalTo:purchaseheadercellContentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        btnReview.topAnchor.constraint(equalTo:purchaseheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 14).isActive = true
        btnReview.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 96).isActive = true
        btnReview.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true
        btnReview.centerYAnchor.constraint(equalTo:purchaseheadercellContentView.centerYAnchor).isActive = true
    }
}

