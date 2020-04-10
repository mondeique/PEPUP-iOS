//
//  MessageCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class MessageCell: BaseCollectionViewCell {

    override func setup() {
        backgroundColor = .white
        messagecellcontentView.addSubview(profileImage)
        messagecellcontentView.addSubview(userNameLabel)
        messagecellcontentView.addSubview(userChatLabel)
        messagecellcontentView.addSubview(chattimeLabel)
        messagecellcontentView.addSubview(unreadCount)
        self.addSubview(messagecellcontentView)

        messagecellcontentViewLayout()
        profileImageLayout()
        userNameLabelLayout()
        userChatLabelLayout()
        chattimeLabelLayout()
        unreadCountLayout()
        
    }
    
    let messagecellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let userChatLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let chattimeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0xB7B7BF)
        label.textAlignment = .left
        label.backgroundColor = .white
        return label
    }()
    
    let unreadCount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.backgroundColor = .black
        label.layer.cornerRadius = 22
        label.clipsToBounds = true
        return label
    }()

    func messagecellcontentViewLayout() {
        messagecellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        messagecellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messagecellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        messagecellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func profileImageLayout() {
        profileImage.leftAnchor.constraint(equalTo:messagecellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 44).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 44).isActive = true
        profileImage.centerYAnchor.constraint(equalTo:messagecellcontentView.centerYAnchor).isActive = true
    }
    
    func userNameLabelLayout() {
        userNameLabel.leftAnchor.constraint(equalTo:profileImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        userNameLabel.topAnchor.constraint(equalTo:messagecellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
//        userNameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 10).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 19).isActive = true
    }
    
    func userChatLabelLayout() {
        userChatLabel.leftAnchor.constraint(equalTo:profileImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        userChatLabel.topAnchor.constraint(equalTo:userNameLabel.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
        userChatLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 214).isActive = true
        userChatLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    func chattimeLabelLayout() {
        chattimeLabel.rightAnchor.constraint(equalTo:messagecellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        chattimeLabel.topAnchor.constraint(equalTo:messagecellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
//        chattimeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        chattimeLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 13).isActive = true
    }
    
    func unreadCountLayout() {
        unreadCount.rightAnchor.constraint(equalTo:messagecellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        unreadCount.topAnchor.constraint(equalTo:chattimeLabel.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
//        chattimeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        unreadCount.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 21).isActive = true
    }
}
