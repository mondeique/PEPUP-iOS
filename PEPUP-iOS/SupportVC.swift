//
//  SupportVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/25.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

private let supporttotalIdentifier = "supporttotalcell"
private let supportotherIdentifier = "supportothercell"
private let supporterrorIdentifier = "supporterrorcell"
private let supportdeliveryIdentifier = "supportdeliverycell"

class SupportVC: UIViewController, CustomSupportBarDelegate {
    
    var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var customSupportBar = CustomSupportBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCustomTabBar()
        setupPageCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    //MARK: Setup view
    func setupCustomTabBar(){
        self.view.addSubview(customSupportBar)
        customSupportBar.delegate = self
        customSupportBar.translatesAutoresizingMaskIntoConstraints = false
        customSupportBar.indicatorViewWidthConstraint.constant = UIScreen.main.bounds.width/375 * 48
        customSupportBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        customSupportBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customSupportBar.topAnchor.constraint(equalTo: faqlabel.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 16).isActive = true
        customSupportBar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 39).isActive = true
    }
    
    func customSupportBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupPageCollectionView() {
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.backgroundColor = .white
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.register(SupportTotalCell.self, forCellWithReuseIdentifier: supporttotalIdentifier)
        pageCollectionView.register(SupportOtherCell.self, forCellWithReuseIdentifier: supportotherIdentifier)
        pageCollectionView.register(SupportErrorCell.self, forCellWithReuseIdentifier: supporterrorIdentifier)
        pageCollectionView.register(SupportDeliveryCell.self, forCellWithReuseIdentifier: supportdeliveryIdentifier)
        self.view.addSubview(pageCollectionView)
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: self.customSupportBar.bottomAnchor).isActive = true
    }
    
    func setup() {
        self.view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        self.view.addSubview(navcontentView)
        navcontentView.addSubview(btnBack)
        navcontentView.addSubview(supportLabel)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        supportLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        supportLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        self.view.addSubview(faqlabel)
        
        faqlabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        faqlabel.topAnchor.constraint(equalTo: navcontentView.bottomAnchor, constant: screenHeight/defaultHeight * 40).isActive = true
        faqlabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 25).isActive = true
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    let navcontentView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.backgroundColor = .white
       return view
    }()

    let btnBack: UIButton = {
       let btn = UIButton()
       btn.setImage(UIImage(named: "btnBack"), for: .normal)
       btn.translatesAutoresizingMaskIntoConstraints = false
       btn.addTarget(self, action: #selector(back), for: .touchUpInside)
       return btn
    }()
    
    let supportLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.text = "고객문의"
        label.textAlignment = .center
        return label
    }()
    
    let faqlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 21)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .white
        label.text = "자주 묻는 FAQ"
        return label
    }()

}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource

extension SupportVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: supporttotalIdentifier, for: indexPath) as! SupportTotalCell
            cell.delegate = self
            if indexPath.row == 0 {
                cell.supportotalcollectionView.isHidden = false
            }
            else {
                cell.supportotalcollectionView.isHidden = true
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: supporterrorIdentifier, for: indexPath) as! SupportErrorCell
            cell.delegate = self
            if indexPath.row == 1 {
                cell.supporterrorcollectionView.isHidden = false
            }
            else {
                cell.supporterrorcollectionView.isHidden = true
            }
            return cell
        }
        else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: supportdeliveryIdentifier, for: indexPath) as! SupportDeliveryCell
            cell.delegate = self
            if indexPath.row == 0 {
                cell.supportdeliverycollectionView.isHidden = false
            }
            else {
                cell.supportdeliverycollectionView.isHidden = true
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: supportotherIdentifier, for: indexPath) as! SupportOtherCell
            cell.delegate = self
            if indexPath.row == 3 {
                cell.supportothercollectionView.isHidden = false
            }
            else {
                cell.supportothercollectionView.isHidden = true
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customSupportBar.indicatorViewLeadingConstraint.constant = UIScreen.main.bounds.width/375 * 16 + scrollView.contentOffset.x / 375 * 50
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        customSupportBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}
//MARK:- UICollectionViewDelegateFlowLayout
extension SupportVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

