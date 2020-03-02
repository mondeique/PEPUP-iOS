//
//  TagCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/24.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class TagCell: BaseCollectionViewCell {
    
    let tagcellcontentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var productImg: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1))
    
//    let soldLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "S O L D"
//        label.backgroundColor = UIColor.black.withAlphaComponent(0.2)
//        label.textColor = .white
//        label.textAlignment = .center
//        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
//        label.clipsToBounds = true
//        label.isHidden = true
//        return label
//    }()
    
    override func setup() {
        backgroundColor = .white
        tagcellcontentView.addSubview(productImg)
//        tagcellcontentView.addSubview(soldLabel)
        self.addSubview(tagcellcontentView)
        
        tagcellcontentViewLayout()
        productImgLayout()
//        soldLabelLayout()
    }
    
    func tagcellcontentViewLayout() {
        tagcellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tagcellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tagcellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        tagcellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func productImgLayout() {
        productImg.leftAnchor.constraint(equalTo:tagcellcontentView.leftAnchor).isActive = true
        productImg.topAnchor.constraint(equalTo:tagcellcontentView.topAnchor).isActive = true
//        productImg.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productImg.heightAnchor.constraint(equalToConstant:80).isActive = true
    }
    
//    func soldLabelLayout() {
//        soldLabel.leftAnchor.constraint(equalTo:tagcellcontentView.leftAnchor).isActive = true
//        soldLabel.topAnchor.constraint(equalTo:tagcellcontentView.topAnchor).isActive = true
//        soldLabel.widthAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
//        soldLabel.heightAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
//    }
}
