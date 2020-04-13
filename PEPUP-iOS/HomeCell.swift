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
    
    var productImg: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1))
        image.backgroundColor = .lightGray
        return image
    }()
    
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
    
    let pepuptag: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pepupTag")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        image.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        image.layer.shadowOpacity = 5.0
        image.layer.shadowRadius = 6.0
        image.isHidden = true
        return image
    }()
    
    override func setup() {
        backgroundColor = .white
        homecellcontentView.addSubview(productImg)
        homecellcontentView.addSubview(pepuptag)
        homecellcontentView.addSubview(soldLabel)
        self.addSubview(homecellcontentView)
        
        homecellcontentViewLayout()
        productImgLayout()
        pepuptagLayout()
        soldLabelLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        productImg.image = nil
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
    
    func pepuptagLayout() {
        pepuptag.rightAnchor.constraint(equalTo:homecellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -8).isActive = true
        pepuptag.topAnchor.constraint(equalTo:homecellcontentView.topAnchor).isActive = true
        pepuptag.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 12).isActive = true
        pepuptag.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 26).isActive = true
    }
    
    func soldLabelLayout() {
        soldLabel.leftAnchor.constraint(equalTo:homecellcontentView.leftAnchor).isActive = true
        soldLabel.topAnchor.constraint(equalTo:homecellcontentView.topAnchor).isActive = true
        soldLabel.widthAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
        soldLabel.heightAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
    }
}

class HomeHeaderCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white

        headercontentView.addSubview(btnSearchBar)
        headercontentView.addSubview(btnCart)
        headercontentView.addSubview(btnDirect)
        
        
        self.addSubview(headercontentView)

        headercontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        headercontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headercontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headercontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        btnSearchBar.leftAnchor.constraint(equalTo: headercontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        btnSearchBar.topAnchor.constraint(equalTo: headercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 6).isActive = true
        btnSearchBar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 245).isActive = true
        btnSearchBar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true
        
        btnCart.leftAnchor.constraint(equalTo: btnSearchBar.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        btnCart.topAnchor.constraint(equalTo: headercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 2).isActive = true
        btnCart.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnCart.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
        btnDirect.leftAnchor.constraint(equalTo: btnCart.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        btnDirect.topAnchor.constraint(equalTo: headercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 2).isActive = true
        btnDirect.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnDirect.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
    }
    
    let headercontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnSearchBar: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "search_bar"), for: .normal)
        return btn
    }()
    
    let btnCart: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnCart"), for: .normal)
        return btn
    }()
    
    let btnDirect: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnDirect"), for: .normal)
        return btn
    }()
}
