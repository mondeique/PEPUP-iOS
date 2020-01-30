//
//  HomeCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/29.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class HomeCell: BaseCollectionViewCell {
    
    var productImg: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
    
    override func setup() {
        backgroundColor = .black
        self.addSubview(productImg)
    }
}
