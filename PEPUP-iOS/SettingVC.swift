//
//  SettingVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/04.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

private let reuseIdentifier = "settingcell"
private let headerId = "settingheadercell"

class SettingVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var settingcollectionView: UICollectionView!
    let settingheaderArray = ["SERVICE", "SUPPORT", "ACCOUNT"]
    let serviceArray = ["공지사항", "스토어 설정"]
    let supportArray = ["고객문의", "정책"]
    let accountArray = ["개인정보변경", "알림설정", "로그아웃", "버전정보"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        navcontentView.addSubview(settingLabel)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        settingLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        settingLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth/defaultWidth * 56)
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: screenWidth, height: UIScreen.main.bounds.height/667 * 57)
        
        settingcollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: layout)
        settingcollectionView.delegate = self
        settingcollectionView.dataSource = self
        settingcollectionView.register(SettingCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        settingcollectionView.register(SettingHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        settingcollectionView.backgroundColor = UIColor.white
        settingcollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(settingcollectionView)
        
        settingcollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        settingcollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + navBarHeight).isActive = true
        settingcollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        settingcollectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        settingcollectionView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gogo() {
        print("GOGO")
    }
    
    @objc func notice() {
        let nextVC = NoticeVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func storesetting() {
        let nextVC = StoreSettingVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func support() {
        let nextVC = SupportVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func policy() {
        let nextVC = PolicyVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func account() {
        let nextVC = AccountVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func alertsetting() {
        let nextVC = AlertSettingVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func logout() {
        let nextVC = LoginVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.serviceArray.count
        }
        else if section == 1 {
            return self.supportArray.count
        }
        else {
            return self.accountArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SettingCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.btnGO.addTarget(self, action: #selector(notice), for: .touchUpInside)
            }
            else {
                cell.btnGO.addTarget(self, action: #selector(storesetting), for: .touchUpInside)
            }
            cell.settingLabel.text = serviceArray[indexPath.row]
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.btnGO.addTarget(self, action: #selector(support), for: .touchUpInside)
            }
            else {
                cell.btnGO.addTarget(self, action: #selector(policy), for: .touchUpInside)
            }
            cell.settingLabel.text = supportArray[indexPath.row]
        }
        else {
            if indexPath.row == 0 {
                cell.btnGO.addTarget(self, action: #selector(account), for: .touchUpInside)
            }
            else if indexPath.row == 1 {
                cell.btnGO.addTarget(self, action: #selector(alertsetting), for: .touchUpInside)
            }
            else if indexPath.row == 2 {
                cell.btnGO.addTarget(self, action: #selector(logout), for: .touchUpInside)
            }
            else {
                cell.btnGO.isHidden = true
            }
            cell.settingLabel.text = accountArray[indexPath.row]
        }
        cell.btnGO.addTarget(self, action: #selector(gogo), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SettingHeaderCell
                headerView.settingheaderLabel.text = settingheaderArray[indexPath.section]
                return headerView

            default:
                assert(false, "Unexpected element kind")
        }
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
    
    let settingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        label.textColor = .black
        label.text = "S E T T I N G"
        label.textAlignment = .center
        return label
    }()

}
