//
//  SellCategoryGenderVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/15.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "sellcategorysecondcell"

class SellCategorySecondVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var sellcategorysecondcollectionView: UICollectionView!
    var secondcategoryArray: Array<NSDictionary>! = []
    var Myid : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setup() {
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        self.view.addSubview(navcontentView)
        navcontentView.addSubview(btnBack)
        navcontentView.addSubview(sellLabel)
        navcontentView.addSubview(lineLabel)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        sellLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        sellLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        lineLabel.bottomAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        lineLabel.leftAnchor.constraint(equalTo: navcontentView.leftAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth/defaultWidth * 56)
        layout.scrollDirection = .vertical
        
        sellcategorysecondcollectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: view.frame.width, height: screenHeight), collectionViewLayout: layout)
        sellcategorysecondcollectionView.delegate = self
        sellcategorysecondcollectionView.dataSource = self
        sellcategorysecondcollectionView.register(SellCategorySecondCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        sellcategorysecondcollectionView.backgroundColor = UIColor.white
        sellcategorysecondcollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(sellcategorysecondcollectionView)
        
        sellcategorysecondcollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sellcategorysecondcollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + navBarHeight).isActive = true
        sellcategorysecondcollectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        sellcategorysecondcollectionView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/category/second_category/" + String(Myid) + "/" , method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                for i in 0..<response.count {
                    self.secondcategoryArray.append(response[i])
                }
                DispatchQueue.main.async {
                    self.sellcategorysecondcollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return secondcategoryArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SellCategorySecondCell
        let secondDic = self.secondcategoryArray[indexPath.row] as NSDictionary
        let name = secondDic.object(forKey: "name") as! String
        cell.categoryLabel.text = name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secondDictionary = self.secondcategoryArray[indexPath.row] as NSDictionary
        let name = secondDictionary.object(forKey: "name") as! String
        let nextVC = SellVC()
        nextVC.category = name
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 56)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // line 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
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
    
    let sellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        label.textColor = .black
        label.text = "C A T E G O R Y"
        label.textAlignment = .center
        return label
    }()
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

class SellCategorySecondCell : BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        sellcategorysecondcontentView.addSubview(categoryLabel)
        sellcategorysecondcontentView.addSubview(lineLabel)
        self.addSubview(sellcategorysecondcontentView)

        sellcategorysecondcontentViewLayout()
        categoryLabelLayout()
        lineLabelLayout()
    }
    
    let sellcategorysecondcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func sellcategorysecondcontentViewLayout() {
        sellcategorysecondcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sellcategorysecondcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sellcategorysecondcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        sellcategorysecondcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func categoryLabelLayout() {
        categoryLabel.leftAnchor.constraint(equalTo:sellcategorysecondcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        categoryLabel.topAnchor.constraint(equalTo:sellcategorysecondcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 20).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo:sellcategorysecondcontentView.centerYAnchor).isActive = true
    }
    
    func lineLabelLayout() {
        lineLabel.bottomAnchor.constraint(equalTo:sellcategorysecondcontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 1).isActive = true
    }
}
