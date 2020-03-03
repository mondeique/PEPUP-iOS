//
//  SearchResultCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/03.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class SearchResultCell: BaseCollectionViewCell {
    
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(cellcontentView)
        
        cellcontentView.addSubview(productImage)
        cellcontentView.addSubview(pepupImage)
        
        cellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        productImage.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo: cellcontentView.topAnchor).isActive = true
        productImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 170).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 170).isActive = true
        
        pepupImage.rightAnchor.constraint(equalTo: cellcontentView.rightAnchor).isActive = true
        pepupImage.bottomAnchor.constraint(equalTo: cellcontentView.bottomAnchor).isActive = true
        pepupImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        pepupImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
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
    
    let pepupImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "pepup_img")
        image.isHidden = true
        return image
    }()
}
