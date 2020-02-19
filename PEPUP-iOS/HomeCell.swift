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
    
    let soldBG: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.red
        return label
    }()
    
    let soldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S O L D"
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        // TODO: - custom Font
        label.clipsToBounds = true
        return label
    }()
    
    
    override func setup() {
        backgroundColor = .white
        homecellcontentView.addSubview(productImg)
        homecellcontentView.addSubview(soldBG)
        homecellcontentView.addSubview(soldLabel)
        self.addSubview(homecellcontentView)
        
        homecellcontentViewLayout()
        productImgLayout()
        soldBGLayout()
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
    
    func soldBGLayout() {
        soldBG.leftAnchor.constraint(equalTo:homecellcontentView.leftAnchor).isActive = true
        soldBG.topAnchor.constraint(equalTo:homecellcontentView.topAnchor).isActive = true
//        soldBG.widthAnchor.constraint(equalToConstant:80).isActive = true
//        soldBG.heightAnchor.constraint(equalToConstant:80).isActive = true
    }
    
    func soldLabelLayout() {
        soldLabel.leftAnchor.constraint(equalTo:homecellcontentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 34).isActive = true
        soldLabel.topAnchor.constraint(equalTo:homecellcontentView.topAnchor, constant:UIScreen.main.bounds.width/375 * 52).isActive = true
//        soldLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        soldLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }
}
