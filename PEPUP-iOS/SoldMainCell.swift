//
//  SoldMainCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/22.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class SoldMainCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        soldcellContentView.addSubview(productImage)
        soldcellContentView.addSubview(productNameLabel)
        soldcellContentView.addSubview(productSizeLabel)
        soldcellContentView.addSubview(productPriceLabel)
        self.addSubview(soldcellContentView)

        soldcellContentViewLayout()
        productImageLayout()
        productNameLabelLayout()
        productSizeLabelLayout()
        productPriceLabelLayout()

    }
    
    let soldcellContentView: UIView = {
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

    func soldcellContentViewLayout() {
        soldcellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        soldcellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        soldcellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        soldcellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productImageLayout() {
        productImage.leftAnchor.constraint(equalTo:soldcellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productImage.topAnchor.constraint(equalTo:soldcellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
        productImage.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 60).isActive = true
        productImage.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 60).isActive = true
    }

    func productNameLabelLayout() {
        productNameLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        productNameLabel.topAnchor.constraint(equalTo:soldcellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 10).isActive = true
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
        productPriceLabel.rightAnchor.constraint(equalTo:soldcellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productPriceLabel.topAnchor.constraint(equalTo:soldcellContentView.topAnchor, constant:10).isActive = true
//        productPriceLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
        productPriceLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 20).isActive = true
    }
}

class SoldMainHeaderCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        soldheadercellContentView.addSubview(sellerProfileImg)
        soldheadercellContentView.addSubview(sellerNameLabel)
        soldheadercellContentView.addSubview(btnDelivery)
        soldheadercellContentView.addSubview(btnComplete)
        self.addSubview(soldheadercellContentView)

        soldheadercellContentViewLayout()
        sellerProfileImgLayout()
        sellerNameLabelLayout()
        btnDeliveryLayout()
        btnCompleteLayout()
    }
    
    let soldheadercellContentView: UIView = {
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
    
    let btnDelivery: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.red, for: .normal)
        btn.setTitle("운송장 입력", for: .normal)
        btn.layer.borderColor = UIColor.red.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        return btn
    }()
    
    let btnComplete: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("입력 완료", for: .normal)
        btn.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        return btn
    }()

    func soldheadercellContentViewLayout() {
        soldheadercellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        soldheadercellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        soldheadercellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        soldheadercellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func sellerProfileImgLayout() {
        sellerProfileImg.leftAnchor.constraint(equalTo:soldheadercellContentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        sellerProfileImg.topAnchor.constraint(equalTo:soldheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
        sellerProfileImg.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        sellerProfileImg.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        sellerProfileImg.centerYAnchor.constraint(equalTo:soldheadercellContentView.centerYAnchor).isActive = true
    }
    
    func sellerNameLabelLayout() {
        sellerNameLabel.leftAnchor.constraint(equalTo:sellerProfileImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 10).isActive = true
        sellerNameLabel.topAnchor.constraint(equalTo:soldheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        sellerNameLabel.centerYAnchor.constraint(equalTo:soldheadercellContentView.centerYAnchor).isActive = true
    }
    
    func btnDeliveryLayout() {
        btnDelivery.rightAnchor.constraint(equalTo:soldheadercellContentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        btnDelivery.topAnchor.constraint(equalTo:soldheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 14).isActive = true
        btnDelivery.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 96).isActive = true
        btnDelivery.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true
        btnDelivery.centerYAnchor.constraint(equalTo:soldheadercellContentView.centerYAnchor).isActive = true
    }
    
    func btnCompleteLayout() {
        btnComplete.rightAnchor.constraint(equalTo:soldheadercellContentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        btnComplete.topAnchor.constraint(equalTo:soldheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 14).isActive = true
        btnComplete.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 96).isActive = true
        btnComplete.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true
        btnComplete.centerYAnchor.constraint(equalTo:soldheadercellContentView.centerYAnchor).isActive = true
    }
}

