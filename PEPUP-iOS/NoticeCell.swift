//
//  NoticeCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/26.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class NoticeCell: BaseCollectionViewCell {

    override func setup() {
        backgroundColor = .white
        noticecellcontentView.addSubview(noticeLabel)
        noticecellcontentView.addSubview(lineLabel)
        self.addSubview(noticecellcontentView)

        noticecellcontentViewLayout()
        noticeLabelLayout()
        lineLabelLayout()
    }
    
    let noticecellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let noticeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func noticecellcontentViewLayout() {
        noticecellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        noticecellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        noticecellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        noticecellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func noticeLabelLayout() {
        noticeLabel.leftAnchor.constraint(equalTo:noticecellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        noticeLabel.topAnchor.constraint(equalTo:noticecellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
        noticeLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 20).isActive = true
        noticeLabel.centerYAnchor.constraint(equalTo:noticecellcontentView.centerYAnchor).isActive = true
    }
    
    func lineLabelLayout() {
        lineLabel.bottomAnchor.constraint(equalTo:noticecellcontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 1).isActive = true
    }

}
