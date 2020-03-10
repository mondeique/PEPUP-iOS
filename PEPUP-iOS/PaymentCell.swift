//
//  PaymentCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/10.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class PaymentCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        paymentcellContentView.addSubview(productImage)
        paymentcellContentView.addSubview(productNameLabel)
        paymentcellContentView.addSubview(productSizeLabel)
        paymentcellContentView.addSubview(productPriceLabel)
        self.addSubview(paymentcellContentView)

        paymentcellContentViewLayout()
        productImageLayout()
        productNameLabelLayout()
        productSizeLabelLayout()
        productPriceLabelLayout()

    }
    
    let paymentcellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let productImage: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/375 * 60, height: UIScreen.main.bounds.width/375 * 60))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        return btn
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

    func paymentcellContentViewLayout() {
        paymentcellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        paymentcellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        paymentcellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        paymentcellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productImageLayout() {
        productImage.leftAnchor.constraint(equalTo:paymentcellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productImage.topAnchor.constraint(equalTo:paymentcellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
        productImage.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 60).isActive = true
        productImage.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 60).isActive = true
    }

    func productNameLabelLayout() {
        productNameLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        productNameLabel.topAnchor.constraint(equalTo:paymentcellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 10).isActive = true
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
        productPriceLabel.rightAnchor.constraint(equalTo:paymentcellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productPriceLabel.topAnchor.constraint(equalTo:paymentcellContentView.topAnchor, constant:10).isActive = true
//        productPriceLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
        productPriceLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 20).isActive = true
    }
}
