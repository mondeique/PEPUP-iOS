//
//  CartHeaderCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/13.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class CartHeaderCell: BaseCollectionViewCell {
    
    override func setup() {
        backgroundColor = .white
        cartheadercellContentView.addSubview(btnsellerProfile)
        cartheadercellContentView.addSubview(btnsellerName)
        self.addSubview(cartheadercellContentView)

        cartheadercellContentViewLayout()
        btnsellerProfileLayout()
        btnsellerNameLayout()
    }
    
    let cartheadercellContentView: UIView = {
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
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.setTitleColor(.black, for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    @objc func sellerstore() {
        print("TOUCH SELLER STORE!")
    }
    
    func cartheadercellContentViewLayout() {
        cartheadercellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cartheadercellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cartheadercellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cartheadercellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func btnsellerProfileLayout() {
        btnsellerProfile.leftAnchor.constraint(equalTo:cartheadercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
//        btnsellerProfile.topAnchor.constraint(equalTo:cartheadercellContentView.topAnchor, constant:6).isActive = true
        btnsellerProfile.widthAnchor.constraint(equalToConstant:44).isActive = true
        btnsellerProfile.heightAnchor.constraint(equalToConstant:44).isActive = true
        btnsellerProfile.centerYAnchor.constraint(equalTo:cartheadercellContentView.centerYAnchor).isActive = true
    }
    
    func btnsellerNameLayout() {
        btnsellerName.leftAnchor.constraint(equalTo:btnsellerProfile.rightAnchor, constant:UIScreen.main.bounds.width/375 * 14).isActive = true
        btnsellerName.topAnchor.constraint(equalTo:cartheadercellContentView.topAnchor, constant:19).isActive = true
//        btnsellerName.widthAnchor.constraint(equalToConstant:80).isActive = true
//        btnsellerName.heightAnchor.constraint(equalToConstant:80).isActive = true
    }
}
