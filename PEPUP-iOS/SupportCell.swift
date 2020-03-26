//
//  SupportCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/26.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class SupportCell: BaseCollectionViewCell {

    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.backgroundColor = .white
        label.textColor = UIColor(rgb: 0xB7B7BF)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet{
            self.label.textColor = isSelected ? .black : UIColor(rgb: 0xB7B7BF)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setup() {
        self.addSubview(label)
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: UIScreen.main.bounds.height/667 * -8).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 50).isActive = true
        label.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 19).isActive = true
    }

}
