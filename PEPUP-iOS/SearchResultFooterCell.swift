//
//  SearchResultFooterCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/03.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class SearchResultFooterCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(footercontentView)
        
        footercontentView.addSubview(productName)
        footercontentView.addSubview(productPrice)
        footercontentView.addSubview(productSize)
        
        footercontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        footercontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        footercontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        footercontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        productName.leftAnchor.constraint(equalTo: footercontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 2).isActive = true
        productName.topAnchor.constraint(equalTo: footercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        productName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 131).isActive = true
        productName.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
        
        productPrice.leftAnchor.constraint(equalTo: footercontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 2).isActive = true
        productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 6).isActive = true
//        productPrice.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 131).isActive = true
        productPrice.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 19).isActive = true
        
        productSize.rightAnchor.constraint(equalTo: footercontentView.rightAnchor).isActive = true
        productSize.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
//        productSize.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 131).isActive = true
        productSize.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
        
    }
    
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
