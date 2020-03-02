//
//  TagHeaderCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/02.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class TagHeaderCell: BaseCollectionViewCell {
    
    let tagheadercellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let followimage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "followImage")
        return image
    }()
    
    let followLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "팔로우 하시고 인기상품을 피드에서 확인해 보세요!"
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.clipsToBounds = true
        return label
    }()
    
    let followButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Follow", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(tagheadercellcontentView)
        
        tagheadercellcontentView.addSubview(followimage)
        tagheadercellcontentView.addSubview(followLabel)
        tagheadercellcontentView.addSubview(followButton)
        
        tagheadercellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tagheadercellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tagheadercellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        tagheadercellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        followimage.leftAnchor.constraint(equalTo: tagheadercellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        followimage.topAnchor.constraint(equalTo: tagheadercellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 16).isActive = true
        followimage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        followimage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
        followLabel.leftAnchor.constraint(equalTo: followimage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        followLabel.topAnchor.constraint(equalTo: tagheadercellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        followLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 134).isActive = true
        followLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true
        
        followButton.leftAnchor.constraint(equalTo: followLabel.rightAnchor, constant: UIScreen.main.bounds.width/375 * 53).isActive = true
        followButton.topAnchor.constraint(equalTo: tagheadercellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 96).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true
    }
}
