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
        
        self.addSubview(srtotalcontentView)
        
//        srtotalcontentView.addSubview(btnDetail)
        srtotalcontentView.addSubview(cellcontentView)
        srtotalcontentView.addSubview(footercontentView)

        cellcontentView.addSubview(productImage)
        cellcontentView.addSubview(pepupImage)
                
        footercontentView.addSubview(productName)
        footercontentView.addSubview(productPrice)
        footercontentView.addSubview(productSize)
        
        srtotalcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        srtotalcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        srtotalcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        srtotalcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

//        btnDetail.leftAnchor.constraint(equalTo: srtotalcontentView.leftAnchor).isActive = true
//        btnDetail.topAnchor.constraint(equalTo: srtotalcontentView.topAnchor).isActive = true
//        btnDetail.widthAnchor.constraint(equalTo: srtotalcontentView.widthAnchor).isActive = true
//        btnDetail.heightAnchor.constraint(equalTo: srtotalcontentView.heightAnchor).isActive = true

        cellcontentView.leftAnchor.constraint(equalTo: srtotalcontentView.leftAnchor).isActive = true
        cellcontentView.topAnchor.constraint(equalTo: srtotalcontentView.topAnchor).isActive = true
        cellcontentView.widthAnchor.constraint(equalTo: srtotalcontentView.widthAnchor).isActive = true
        cellcontentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 170).isActive = true
        
        productImage.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo: cellcontentView.topAnchor).isActive = true
        productImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 170).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 170).isActive = true
        
        pepupImage.rightAnchor.constraint(equalTo: cellcontentView.rightAnchor).isActive = true
        pepupImage.bottomAnchor.constraint(equalTo: cellcontentView.bottomAnchor).isActive = true
        pepupImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        pepupImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
        footercontentView.leftAnchor.constraint(equalTo: srtotalcontentView.leftAnchor).isActive = true
        footercontentView.topAnchor.constraint(equalTo: cellcontentView.bottomAnchor).isActive = true
        footercontentView.widthAnchor.constraint(equalTo: srtotalcontentView.widthAnchor).isActive = true
        footercontentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 56).isActive = true
        
        productName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: UIScreen.main.bounds.width/375 * 2).isActive = true
        productName.topAnchor.constraint(equalTo: footercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        productName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 131).isActive = true
        productName.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
        
        productPrice.leftAnchor.constraint(equalTo: self.leftAnchor, constant: UIScreen.main.bounds.width/375 * 2).isActive = true
        productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 6).isActive = true
//        productPrice.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 131).isActive = true
        productPrice.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 19).isActive = true
        
        productSize.rightAnchor.constraint(equalTo: self.rightAnchor, constant: UIScreen.main.bounds.width/375 * -2).isActive = true
        productSize.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: UIScreen.main.bounds.height/667 * -8).isActive = true
//        productSize.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 131).isActive = true
        productSize.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    let srtotalcontentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let btnDetail: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = .white
//        return btn
//    }()
    
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
    
    let footercontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productSize: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = UIColor(rgb: 0x6B6A6E)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
