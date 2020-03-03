//
//  SearchCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/03.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview(cellcontentView)
        addSubview(storecontentView)
        
        cellcontentView.addSubview(productLabel)
        cellcontentView.addSubview(productcountLabel)
        cellcontentView.addSubview(btnGO)
        cellcontentView.addSubview(lineLabel)
        
        storecontentView.addSubview(storeProfile)
        storecontentView.addSubview(storeLabel)
        
        cellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        productLabel.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        productLabel.topAnchor.constraint(equalTo: cellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
//        productLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        productLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 20).isActive = true
        
        productcountLabel.rightAnchor.constraint(equalTo: cellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -36).isActive = true
        productcountLabel.topAnchor.constraint(equalTo: cellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
//        productcountLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        productcountLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 20).isActive = true
        
        btnGO.leftAnchor.constraint(equalTo: productcountLabel.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        btnGO.topAnchor.constraint(equalTo: cellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        btnGO.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 10).isActive = true
        btnGO.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
        
        lineLabel.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        lineLabel.bottomAnchor.constraint(equalTo: cellcontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 339).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 1).isActive = true
        
        storecontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        storecontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        storecontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        storecontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        storeProfile.leftAnchor.constraint(equalTo: storecontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        storeProfile.topAnchor.constraint(equalTo: storecontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        storeProfile.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        storeProfile.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        
        storeLabel.leftAnchor.constraint(equalTo: storeProfile.rightAnchor, constant: UIScreen.main.bounds.width/375 * 24).isActive = true
        storeLabel.topAnchor.constraint(equalTo: storecontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
//        storeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        storeLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let cellcontentView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let storecontentView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let productLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    let lineLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.isHidden = true
        return label
    }()
    
    let productcountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.isHidden = true
        return label
    }()
    
    let storeProfile: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    
    let btnGO: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnGO_search"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    let storeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.isHidden = true
        return label
    }()
    
}
