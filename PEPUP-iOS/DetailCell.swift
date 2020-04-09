//
//  DetailCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/04/09.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class DetailCell: BaseCollectionViewCell {

    override func setup() {
        backgroundColor = .white
        detailcellcontentView.addSubview(detailLabel)
        detailcellcontentView.addSubview(btnGO)
        detailcellcontentView.addSubview(lineLabel)
        self.addSubview(detailcellcontentView)

        detailcellcontentViewLayout()
        detailLabelLayout()
        btnGOLayout()
        lineLabelLayout()
        
    }
    
    let detailcellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

    let btnGO: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnGO"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func detailcellcontentViewLayout() {
        detailcellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        detailcellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        detailcellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        detailcellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func detailLabelLayout() {
        detailLabel.leftAnchor.constraint(equalTo:detailcellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        detailLabel.topAnchor.constraint(equalTo:detailcellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 20).isActive = true
        detailLabel.centerYAnchor.constraint(equalTo:detailcellcontentView.centerYAnchor).isActive = true
    }
    
    func btnGOLayout() {
        btnGO.rightAnchor.constraint(equalTo:detailcellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        btnGO.topAnchor.constraint(equalTo:detailcellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        btnGO.centerYAnchor.constraint(equalTo:detailcellcontentView.centerYAnchor).isActive = true
        btnGO.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 9).isActive = true
        btnGO.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    func lineLabelLayout() {
        lineLabel.bottomAnchor.constraint(equalTo:detailcellcontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 1).isActive = true
    }
}
