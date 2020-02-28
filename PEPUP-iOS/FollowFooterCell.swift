//
//  FollowFooterCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/28.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class FollowFooterCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(footercontentView)
        
        footercontentView.addSubview(btnLike)
        footercontentView.addSubview(btnMessage)
        footercontentView.addSubview(pepupImage)
        footercontentView.addSubview(btnDetail)
        footercontentView.addSubview(productName)
        footercontentView.addSubview(sizeInfoLabel)
        footercontentView.addSubview(brandInfoLabel)
        
        footercontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        footercontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        footercontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        footercontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        btnLike.leftAnchor.constraint(equalTo: footercontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        btnLike.topAnchor.constraint(equalTo: footercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
        btnLike.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnLike.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
        btnMessage.leftAnchor.constraint(equalTo: btnLike.rightAnchor, constant: UIScreen.main.bounds.width/375 * 10).isActive = true
        btnMessage.topAnchor.constraint(equalTo: footercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
        btnMessage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnMessage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
        pepupImage.leftAnchor.constraint(equalTo: btnMessage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 10).isActive = true
        pepupImage.topAnchor.constraint(equalTo: footercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
        pepupImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        pepupImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
        btnDetail.leftAnchor.constraint(equalTo: pepupImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 90).isActive = true
        btnDetail.topAnchor.constraint(equalTo: footercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        btnDetail.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 119).isActive = true
        btnDetail.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true
        
        productName.leftAnchor.constraint(equalTo: footercontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        productName.topAnchor.constraint(equalTo: btnLike.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
//        productName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        productName.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 19).isActive = true
        
        sizeInfoLabel.leftAnchor.constraint(equalTo: footercontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        sizeInfoLabel.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
//        sizeInfoLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        sizeInfoLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 19).isActive = true
        
        brandInfoLabel.leftAnchor.constraint(equalTo: sizeInfoLabel.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        brandInfoLabel.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
//        brandInfoLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        brandInfoLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 19).isActive = true
        
    }
    
    let footercontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnLike: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnLike"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let btnMessage: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnMessage"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let pepupImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "pepup_img")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let btnDetail: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let sizeInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let brandInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
}
