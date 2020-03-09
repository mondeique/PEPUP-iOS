//
//  CartCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/13.
//  Copyright © 2020 Mondeique. All rights reserved.
//

//
//  CartCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/13.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class CartCell: BaseCollectionViewCell{
    
    override func setup() {
        backgroundColor = .red
        cartcellContentView.addSubview(productImage)
        cartcellContentView.addSubview(productNameLabel)
        cartcellContentView.addSubview(productSizeLabel)
        cartcellContentView.addSubview(productPriceLabel)
        self.addSubview(cartcellContentView)

        cartcellContentViewLayout()
        productImageLayout()
        productNameLabelLayout()
        productSizeLabelLayout()
        productPriceLabelLayout()
        
    }
    
    let cartcellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let productImage: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        return btn
    }()

    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
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

    func cartcellContentViewLayout() {
        cartcellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cartcellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cartcellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cartcellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productImageLayout() {
        productImage.leftAnchor.constraint(equalTo:cartcellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productImage.topAnchor.constraint(equalTo:cartcellContentView.topAnchor, constant:10).isActive = true
        productImage.widthAnchor.constraint(equalToConstant:80).isActive = true
        productImage.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productNameLabelLayout() {
        productNameLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 16).isActive = true
        productNameLabel.topAnchor.constraint(equalTo:cartcellContentView.topAnchor, constant:10).isActive = true
        productNameLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 150).isActive = true
//        productNameLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productSizeLabelLayout() {
        productSizeLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 16).isActive = true
        productSizeLabel.topAnchor.constraint(equalTo:productNameLabel.bottomAnchor, constant:4).isActive = true
//        productSizeLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productSizeLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productPriceLabelLayout() {
        productPriceLabel.rightAnchor.constraint(equalTo:cartcellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productPriceLabel.topAnchor.constraint(equalTo:cartcellContentView.topAnchor, constant:10).isActive = true
//        productPriceLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productPriceLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }
}
