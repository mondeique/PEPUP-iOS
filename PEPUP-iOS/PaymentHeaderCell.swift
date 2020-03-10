//
//  PaymentHeaderCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/10.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class PaymentHeaderCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        paymentheadercellContentView.addSubview(btnsellerProfile)
        paymentheadercellContentView.addSubview(btnsellerName)
        self.addSubview(paymentheadercellContentView)

        paymentheadercellContentViewLayout()
        btnsellerProfileLayout()
        btnsellerNameLayout()
    }
    
    let paymentheadercellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let btnsellerProfile:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let btnsellerName: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.setTitleColor(.black, for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    func paymentheadercellContentViewLayout() {
        paymentheadercellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        paymentheadercellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        paymentheadercellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        paymentheadercellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func btnsellerProfileLayout() {
        btnsellerProfile.leftAnchor.constraint(equalTo:paymentheadercellContentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        btnsellerProfile.topAnchor.constraint(equalTo:paymentheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
        btnsellerProfile.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnsellerProfile.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnsellerProfile.centerYAnchor.constraint(equalTo:paymentheadercellContentView.centerYAnchor).isActive = true
    }
    
    func btnsellerNameLayout() {
        btnsellerName.leftAnchor.constraint(equalTo:btnsellerProfile.rightAnchor, constant: UIScreen.main.bounds.width/375 * 10).isActive = true
        btnsellerName.topAnchor.constraint(equalTo:paymentheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        btnsellerName.centerYAnchor.constraint(equalTo:paymentheadercellContentView.centerYAnchor).isActive = true
    }
}
