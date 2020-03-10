//
//  PaymentFooterCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/10.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class PaymentFooterCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        cartfootercellContentView.addSubview(productdeliveryLabel)
        cartfootercellContentView.addSubview(productdeliveryInfoLabel)
        self.addSubview(cartfootercellContentView)

        cartfootercellContentViewLayout()
        productdeliveryLabelLayout()
        productdeliveryInfoLabelLayout()
    }
    
    let cartfootercellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let productdeliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "+ 배송비"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.backgroundColor = .white
        return label
    }()

    let productdeliveryInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.backgroundColor = .white
        return label
    }()

    func cartfootercellContentViewLayout() {
        cartfootercellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cartfootercellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cartfootercellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cartfootercellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productdeliveryLabelLayout() {
        productdeliveryLabel.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productdeliveryLabel.topAnchor.constraint(equalTo:cartfootercellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 21).isActive = true
        productdeliveryLabel.centerYAnchor.constraint(equalTo: cartfootercellContentView.centerYAnchor).isActive = true
    }

    func productdeliveryInfoLabelLayout() {
        productdeliveryInfoLabel.rightAnchor.constraint(equalTo:cartfootercellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productdeliveryInfoLabel.topAnchor.constraint(equalTo:cartfootercellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 21).isActive = true
        productdeliveryInfoLabel.centerYAnchor.constraint(equalTo: cartfootercellContentView.centerYAnchor).isActive = true
    }
}
