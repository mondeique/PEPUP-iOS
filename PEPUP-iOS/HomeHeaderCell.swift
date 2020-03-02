//
//  HomeHeaderCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/02.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class HomeHeaderCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white

        headercontentView.addSubview(btnSearchBar)
        headercontentView.addSubview(btnCart)
        headercontentView.addSubview(btnDirect)
        
        
        self.addSubview(headercontentView)

        headercontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        headercontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headercontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headercontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        btnSearchBar.leftAnchor.constraint(equalTo: headercontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        btnSearchBar.topAnchor.constraint(equalTo: headercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 6).isActive = true
        btnSearchBar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 245).isActive = true
        btnSearchBar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 32).isActive = true
        
        btnCart.leftAnchor.constraint(equalTo: btnSearchBar.rightAnchor, constant: UIScreen.main.bounds.width/375 * 16).isActive = true
        btnCart.topAnchor.constraint(equalTo: headercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 2).isActive = true
        btnCart.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnCart.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
        btnDirect.leftAnchor.constraint(equalTo: btnCart.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        btnDirect.topAnchor.constraint(equalTo: headercontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 2).isActive = true
        btnDirect.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnDirect.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
    }
    
    let headercontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnSearchBar: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "search_bar"), for: .normal)
        return btn
    }()
    
    let btnCart: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnCart"), for: .normal)
        return btn
    }()
    
    let btnDirect: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnDirect"), for: .normal)
        return btn
    }()
}
