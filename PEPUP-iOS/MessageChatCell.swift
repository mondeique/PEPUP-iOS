//
//  MessageChatCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class MyMessageChatCell: BaseCollectionViewCell {

    override func setup() {
        backgroundColor = .white
//        messagecellcontentView.addSubview(profileImage)
//        messagecellcontentView.addSubview(userNameLabel)
        messagecellcontentView.addSubview(backgroundLabel)
        backgroundLabel.addSubview(userChatLabel)
//        messagecellcontentView.addSubview(chattimeLabel)
        self.addSubview(messagecellcontentView)

        messagecellcontentViewLayout()
        backgroundLabelLayout()
//        profileImageLayout()
//        userNameLabelLayout()
        userChatLabelLayout()
//        chattimeLabelLayout()
        
    }
    
    let messagecellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let backgroundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black
        return label
    }()
    
    let userChatLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
//    let chattimeLabel : UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 11)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "2020.11.02"
//        label.textColor = UIColor(rgb: 0xB7B7BF)
//        label.textAlignment = .left
//        label.backgroundColor = .white
//        return label
//    }()

    func messagecellcontentViewLayout() {
        messagecellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        messagecellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messagecellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        messagecellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func backgroundLabelLayout() {
        backgroundLabel.rightAnchor.constraint(equalTo:messagecellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        backgroundLabel.topAnchor.constraint(equalTo:messagecellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
        backgroundLabel.widthAnchor.constraint(lessThanOrEqualToConstant:UIScreen.main.bounds.width/375 * 256).isActive = true
//        backgroundLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    func userChatLabelLayout() {
        userChatLabel.leftAnchor.constraint(equalTo:backgroundLabel.leftAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        userChatLabel.topAnchor.constraint(equalTo:backgroundLabel.topAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        userChatLabel.centerXAnchor.constraint(equalTo:backgroundLabel.centerXAnchor).isActive = true
        userChatLabel.centerYAnchor.constraint(equalTo:backgroundLabel.centerYAnchor).isActive = true
//        userChatLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 214).isActive = true
//        userChatLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
//    func chattimeLabelLayout() {
//        chattimeLabel.rightAnchor.constraint(equalTo:messagecellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
//        chattimeLabel.topAnchor.constraint(equalTo:messagecellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
////        chattimeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        chattimeLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 13).isActive = true
//    }

}

class DestinationMessageChatCell: BaseCollectionViewCell {

    override func setup() {
        backgroundColor = .white
        messagecellcontentView.addSubview(profileImage)
        messagecellcontentView.addSubview(backgroundLabel)
        backgroundLabel.addSubview(userChatLabel)
//        messagecellcontentView.addSubview(chattimeLabel)
        self.addSubview(messagecellcontentView)

        messagecellcontentViewLayout()
        profileImageLayout()
        backgroundLabelLayout()
        userChatLabelLayout()
//        chattimeLabelLayout()
        
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
    
    let backgroundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xF4F5FC)
        return label
    }()
    
    let userChatLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
//    let chattimeLabel : UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 11)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "2020.11.02"
//        label.textColor = UIColor(rgb: 0xB7B7BF)
//        label.textAlignment = .left
//        label.backgroundColor = .white
//        return label
//    }()

    func messagecellcontentViewLayout() {
        messagecellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        messagecellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messagecellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        messagecellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func profileImageLayout() {
        profileImage.leftAnchor.constraint(equalTo:messagecellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 36).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 36).isActive = true
        profileImage.centerYAnchor.constraint(equalTo:messagecellcontentView.centerYAnchor).isActive = true
    }
    
    func backgroundLabelLayout() {
        backgroundLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        backgroundLabel.centerYAnchor.constraint(equalTo:messagecellcontentView.centerYAnchor).isActive = true
        backgroundLabel.widthAnchor.constraint(lessThanOrEqualToConstant:UIScreen.main.bounds.width/375 * 256).isActive = true
//        backgroundLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    func userChatLabelLayout() {
        userChatLabel.leftAnchor.constraint(equalTo:backgroundLabel.leftAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        userChatLabel.topAnchor.constraint(equalTo:backgroundLabel.topAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        userChatLabel.centerXAnchor.constraint(equalTo:backgroundLabel.centerXAnchor).isActive = true
        userChatLabel.centerYAnchor.constraint(equalTo:backgroundLabel.centerYAnchor).isActive = true
//        userChatLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 214).isActive = true
//        userChatLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
//    func chattimeLabelLayout() {
//        chattimeLabel.rightAnchor.constraint(equalTo:messagecellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
//        chattimeLabel.topAnchor.constraint(equalTo:messagecellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
////        chattimeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        chattimeLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 13).isActive = true
//    }

}

