//
//  CartFooterCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/13.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class CartFooterCell: BaseCollectionViewCell {
    
    override func setup() {
        backgroundColor = .orange
        cartfootercellContentView.addSubview(lineLabel)
        cartfootercellContentView.addSubview(productpriceLabel)
        cartfootercellContentView.addSubview(productpriceInfoLabel)
        cartfootercellContentView.addSubview(productdeliveryLabel)
        cartfootercellContentView.addSubview(productdeliveryInfoLabel)
        cartfootercellContentView.addSubview(btnPayment)
        cartfootercellContentView.addSubview(spaceLabel)
        self.addSubview(cartfootercellContentView)

        cartfootercellContentViewLayout()
        lineLabelLayout()
        productpriceLabelLayout()
        productpriceInfoLabelLayout()
        productdeliveryLabelLayout()
        productdeliveryInfoLabelLayout()
        btnPaymentLayout()
        spaceLabelLayout()
    }
    
    let cartfootercellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let lineLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let productpriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "상품금액"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productpriceInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productdeliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "배송비"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productdeliveryInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let btnPayment: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.5
        btn.setTitleColor(.black, for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let spaceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xF4F5FC)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func cartfootercellContentViewLayout() {
        cartfootercellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cartfootercellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cartfootercellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cartfootercellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func lineLabelLayout() {
        lineLabel.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        lineLabel.topAnchor.constraint(equalTo:cartfootercellContentView.topAnchor, constant:0).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 339).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant:1).isActive = true
        lineLabel.centerXAnchor.constraint(equalTo:cartfootercellContentView.centerXAnchor).isActive = true
    }

    func productpriceLabelLayout() {
        productpriceLabel.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productpriceLabel.topAnchor.constraint(equalTo:cartfootercellContentView.topAnchor, constant:20).isActive = true
//        productpriceLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productpriceLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productpriceInfoLabelLayout() {
        productpriceInfoLabel.rightAnchor.constraint(equalTo:cartfootercellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productpriceInfoLabel.topAnchor.constraint(equalTo:cartfootercellContentView.topAnchor, constant:20).isActive = true
//        productpriceInfoLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productpriceInfoLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productdeliveryLabelLayout() {
        productdeliveryLabel.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productdeliveryLabel.topAnchor.constraint(equalTo:productpriceLabel.bottomAnchor, constant:10).isActive = true
//        productdeliveryLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productdeliveryLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productdeliveryInfoLabelLayout() {
        productdeliveryInfoLabel.rightAnchor.constraint(equalTo:cartfootercellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productdeliveryInfoLabel.topAnchor.constraint(equalTo:productpriceInfoLabel.bottomAnchor, constant:10).isActive = true
//        productdeliveryInfoLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productdeliveryInfoLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func btnPaymentLayout() {
        btnPayment.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        btnPayment.topAnchor.constraint(equalTo:productdeliveryLabel.bottomAnchor, constant:24).isActive = true
        btnPayment.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 339).isActive = true
        btnPayment.heightAnchor.constraint(equalToConstant:48).isActive = true
        btnPayment.centerXAnchor.constraint(equalTo:cartfootercellContentView.centerXAnchor).isActive = true
    }
    
    func spaceLabelLayout() {
        spaceLabel.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor).isActive = true
        spaceLabel.topAnchor.constraint(equalTo:btnPayment.bottomAnchor, constant:16).isActive = true
        spaceLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width).isActive = true
        spaceLabel.heightAnchor.constraint(equalToConstant:48).isActive = true
    }
}
