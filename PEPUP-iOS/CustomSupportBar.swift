//
//  CustomSupportBar.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/26.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

protocol CustomSupportBarDelegate: class {
    func customSupportBar(scrollTo index: Int)
}

class CustomSupportBar: UIView {
    
    private let reuseIdentifier = "supportcell"
    
    weak var delegate: CustomSupportBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupCustomTabBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var customTabBarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 44), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    //MARK: Properties
    
    var indicatorViewLeadingConstraint: NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    //MARK: Setup Views
    
    func setupCollectionView(){
        customTabBarCollectionView.delegate = self
        customTabBarCollectionView.dataSource = self
        customTabBarCollectionView.showsHorizontalScrollIndicator = false
        customTabBarCollectionView.register(SupportCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        customTabBarCollectionView.isScrollEnabled = false
        
        let indexPath = IndexPath(item: 0, section: 0)
        customTabBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    func setupCustomTabBar(){
        setupCollectionView()
        self.addSubview(customTabBarCollectionView)
        customTabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        customTabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        customTabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        customTabBarCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 44).isActive = true
        
        self.addSubview(indicatorView)
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 48)
        indicatorViewWidthConstraint.isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 2).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 0)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

//MARK:- UICollectionViewDelegate, DataSource
extension CustomSupportBar: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SupportCell
        if indexPath.row == 0 {
            cell.label.text = "전체"
        }
        else if indexPath.row == 1 {
            cell.label.text = "기능 및 오류"
        }
        else if indexPath.row == 2 {
            cell.label.text = "배송 및 환불"
        }
        else {
            cell.label.text = "기타"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: UIScreen.main.bounds.width/375 * 26 , height: UIScreen.main.bounds.height/667 * 44)
        }
        else if indexPath.row == 1 {
            return CGSize(width: UIScreen.main.bounds.width/375 * 80 , height: UIScreen.main.bounds.height/667 * 44)
        }
        else if indexPath.row == 2 {
            return CGSize(width: UIScreen.main.bounds.width/375 * 80 , height: UIScreen.main.bounds.height/667 * 44)
        }
        else {
            return CGSize(width: UIScreen.main.bounds.width/375 * 26 , height: UIScreen.main.bounds.height/667 * 44)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.customSupportBar(scrollTo: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SupportCell else {return}
        cell.label.textColor = UIColor(rgb: 0xB7B7BF)
    }
}
//MARK:- UICollectionViewDelegateFlowLayout
extension CustomSupportBar: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

