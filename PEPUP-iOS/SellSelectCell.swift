//
//  SellSelectCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/11.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class SellSelectCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        sellselectcellContentView.addSubview(productImage)
        
        self.addSubview(sellselectcellContentView)

        sellselectcellContentViewLayout()
        productImageLayout()
        
    }
    
    let sellselectcellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let productImage: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.clipsToBounds = true
        return imageview
    }()
    
    func sellselectcellContentViewLayout() {
        sellselectcellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sellselectcellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sellselectcellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        sellselectcellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productImageLayout() {
        productImage.leftAnchor.constraint(equalTo:sellselectcellContentView.leftAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo:sellselectcellContentView.topAnchor).isActive = true
        productImage.widthAnchor.constraint(equalTo:sellselectcellContentView.widthAnchor).isActive = true
        productImage.heightAnchor.constraint(equalTo:sellselectcellContentView.heightAnchor).isActive = true
    }
}
