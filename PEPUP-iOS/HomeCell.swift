//
//  HomeCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/29.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class HomeCell: BaseCollectionViewCell {
    
    let homecellcontentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var productImg: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1))
    
    let soldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S O L D"
        label.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    override func setup() {
        backgroundColor = .white
        homecellcontentView.addSubview(productImg)
        homecellcontentView.addSubview(soldLabel)
        self.addSubview(homecellcontentView)
        
        homecellcontentViewLayout()
        productImgLayout()
        soldLabelLayout()
    }
    
    func homecellcontentViewLayout() {
        homecellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        homecellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        homecellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        homecellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func productImgLayout() {
        productImg.leftAnchor.constraint(equalTo:homecellcontentView.leftAnchor).isActive = true
        productImg.topAnchor.constraint(equalTo:homecellcontentView.topAnchor).isActive = true
//        productImg.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productImg.heightAnchor.constraint(equalToConstant:80).isActive = true
    }
    
    func soldLabelLayout() {
        soldLabel.leftAnchor.constraint(equalTo:homecellcontentView.leftAnchor).isActive = true
        soldLabel.topAnchor.constraint(equalTo:homecellcontentView.topAnchor).isActive = true
        soldLabel.widthAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
        soldLabel.heightAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
    }
}
