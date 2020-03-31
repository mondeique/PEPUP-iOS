//
//  NoticeVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/25.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class NoticeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "noticecell"
    var pagenum: Int = 1
    
    var noticollectionView: UICollectionView!
    var noticeDatas : NSDictionary!

    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        getData(pagenum: 1)
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
        navcontentView.addSubview(noticeLabel)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        noticeLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        noticeLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth/defaultWidth * 56)
        layout.scrollDirection = .vertical
        
        noticollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: layout)
        noticollectionView.delegate = self
        noticollectionView.dataSource = self
        noticollectionView.register(NoticeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        noticollectionView.backgroundColor = UIColor.white
        noticollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(noticollectionView)
        
        noticollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        noticollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + navBarHeight).isActive = true
        noticollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        noticollectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        noticollectionView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
    }
    
    func getData(pagenum: Int) {
        Alamofire.AF.request("\(Config.baseURL)/api/notice/?page=" + String(pagenum) , method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                self.noticeDatas = response
                DispatchQueue.main.async {
                    self.noticollectionView.reloadData()
                }
                self.setup()
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let resultsArray = self.noticeDatas.object(forKey: "results") as! Array<NSDictionary>
        return resultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NoticeCell
        let resultsArray = self.noticeDatas.object(forKey: "results") as! Array<NSDictionary>
        let resultsDic = resultsArray[indexPath.row]
        let title = resultsDic.object(forKey: "title") as! String
        cell.noticeLabel.text = title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultsArray = noticeDatas.object(forKey: "results") as! Array<NSDictionary>
        let resultsDic = resultsArray[indexPath.row]
        let id = resultsDic.object(forKey: "id") as! Int
        let nextVC = NoticeMainVC()
        nextVC.MyId = id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let resultsArray = noticeDatas.object(forKey: "results") as! Array<NSDictionary>
        if indexPath.row == resultsArray.count - 1 {
            pagenum = pagenum + 1
            getData(pagenum: pagenum)
        }
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
    
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.text = "공지사항"
        label.textAlignment = .center
        return label
    }()

}
