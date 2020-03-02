//
//  FollowHeaderCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/28.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class FollowHeaderCell: BaseCollectionViewCell {
    
    override func setup() {
        backgroundColor = .white

        headercontentView.addSubview(sellerImage)
        headercontentView.addSubview(sellerName)
        headercontentView.addSubview(tagName)
        
        self.addSubview(headercontentView)

        headercontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        headercontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headercontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headercontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        sellerImage.leftAnchor.constraint(equalTo: headercontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        sellerImage.topAnchor.constraint(equalTo: headercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        sellerImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        sellerImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
        sellerName.leftAnchor.constraint(equalTo: sellerImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 20).isActive = true
        sellerName.topAnchor.constraint(equalTo: headercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
//        sellerName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        sellerName.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 19).isActive = true
        
        tagName.leftAnchor.constraint(equalTo: sellerImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 20).isActive = true
        tagName.topAnchor.constraint(equalTo: headercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 31).isActive = true
//        tagName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        tagName.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 16).isActive = true
        
    }
    
    let headercontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sellerImage: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let sellerName: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        return btn
    }()
    
    let tagName: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        return btn
    }()

}
