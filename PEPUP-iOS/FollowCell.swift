//
//  FollowCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class FollowCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(cellcontentView)
        
        cellcontentView.addSubview(productImage)
        
        cellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        productImage.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo: cellcontentView.topAnchor).isActive = true
        productImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
    
    let cellcontentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
}
