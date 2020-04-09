//
//  SellCategorySizeVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/15.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "sellsizecell"

class SellCategorySizeVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var sellsizecollectionView: UICollectionView!
    var sizeArray: Array<NSDictionary>! = []
    var Myid : Int! = UserDefaults.standard.object(forKey: "first_category") as? Int

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
        let statusBarHeight: CGFloat! = UIScreen.main.bounds.height/defaultHeight * 20
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
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
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
        
        sellsizecollectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: view.frame.width, height: screenHeight), collectionViewLayout: layout)
        sellsizecollectionView.delegate = self
        sellsizecollectionView.dataSource = self
        sellsizecollectionView.register(SellSizeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        sellsizecollectionView.backgroundColor = UIColor.white
        sellsizecollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(sellsizecollectionView)
        
        sellsizecollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sellsizecollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + navBarHeight).isActive = true
        sellsizecollectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        sellsizecollectionView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/category/size/" + String(Myid) + "/" , method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                for i in 0..<response.count {
                    self.sizeArray.append(response[i])
                }
                DispatchQueue.main.async {
                    self.sellsizecollectionView.reloadData()
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
        return sizeArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SellSizeCell
        let sizeDic = self.sizeArray[indexPath.row] as NSDictionary
        let name = sizeDic.object(forKey: "name") as! String
        cell.sizeLabel.text = name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sizeDictionary = self.sizeArray[indexPath.row] as NSDictionary
        let name = sizeDictionary.object(forKey: "name") as! String
        let id = sizeDictionary.object(forKey: "id") as! Int
        UserDefaults.standard.set(name, forKey: "size")
        UserDefaults.standard.set(id, forKey: "size_id")
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        self.navigationController?.popToViewController(controller!, animated: true)
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
        label.text = "S I Z E"
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

class SellSizeCell : BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        sellsizecontentView.addSubview(sizeLabel)
        sellsizecontentView.addSubview(lineLabel)
        self.addSubview(sellsizecontentView)

        sellsizecontentViewLayout()
        sizeLabelLayout()
        lineLabelLayout()
    }
    
    let sellsizecontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let sizeLabel: UILabel = {
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

    func sellsizecontentViewLayout() {
        sellsizecontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sellsizecontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sellsizecontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        sellsizecontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func sizeLabelLayout() {
        sizeLabel.leftAnchor.constraint(equalTo:sellsizecontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        sizeLabel.topAnchor.constraint(equalTo:sellsizecontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
        sizeLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 20).isActive = true
        sizeLabel.centerYAnchor.constraint(equalTo:sellsizecontentView.centerYAnchor).isActive = true
    }
    
    func lineLabelLayout() {
        lineLabel.bottomAnchor.constraint(equalTo:sellsizecontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 1).isActive = true
    }
}
