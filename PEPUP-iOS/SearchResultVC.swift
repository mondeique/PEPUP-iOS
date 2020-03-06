//
//  SearchResultVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/03.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "resultcell"

var resultCollectionView: UICollectionView!

class SearchResultVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var searchName : String!
    var searchCount : Int!
    var productDatas = Array<NSDictionary>()
    var pagenum: Int = 1
    
    var resultCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData(pagenum: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
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
        
        let productNameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
            label.textColor = .black
            label.text = searchName
            label.textAlignment = .center
            return label
        }()
        
        let productCountLabel : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "AppleSDGothicNeo-Reular", size: 15)
            label.textColor = UIColor(rgb: 0x6B6A6E)
            label.textAlignment = .left
            label.text = String(self.searchCount) + "개의 상품"
            return label
        }()
        
        navcontentView.addSubview(btnBack)
        navcontentView.addSubview(productNameLabel)
        
        self.view.addSubview(productCountLabel)
        self.view.addSubview(navcontentView)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        productNameLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        productNameLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        productCountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: screenHeight/defaultHeight * -18).isActive = true
        productCountLabel.topAnchor.constraint(equalTo: navcontentView.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
//        productCountLabel.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        productCountLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 19).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/defaultWidth * 170, height: screenWidth/defaultWidth * 226)
        
        resultCollectionView = UICollectionView(frame: CGRect(x: screenWidth/defaultWidth * 12, y: statusBarHeight + navBarHeight + screenWidth/defaultWidth * 40, width: view.frame.width - screenWidth/defaultWidth * 24, height: screenHeight - statusBarHeight - navBarHeight), collectionViewLayout: layout)
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.showsVerticalScrollIndicator = false
        resultCollectionView.keyboardDismissMode = .onDrag
        resultCollectionView.alwaysBounceVertical = true
        resultCollectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        resultCollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(resultCollectionView)
        
        resultCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: screenWidth/defaultWidth * 12).isActive = true
        resultCollectionView.topAnchor.constraint(equalTo: productCountLabel.bottomAnchor, constant: screenHeight/defaultHeight * 13).isActive = true
        resultCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        resultCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
    }
    
    func getData(pagenum : Int) {
        let parameters: [String: String] = [
            "keyword" : searchName
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/search/product_search/?page=" + String(pagenum), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let results = response.object(forKey: "results") as! Array<Dictionary<String, Any>>
                for i in 0..<results.count {
                    self.productDatas.append(results[i] as NSDictionary)
                }
                DispatchQueue.main.async {
                    self.resultCollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
        let productDic = self.productDatas[indexPath.row] as NSDictionary
        let imageDic = productDic.object(forKey: "images") as! NSDictionary
        let imageID = productDic.object(forKey: "id") as! Int
        let ImageUrlString = imageDic.object(forKey: "image") as! String
        let imageUrl:NSURL = NSURL(string: ImageUrlString)!
        let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
        let image = UIImage(data: imageData as Data)
        let refundable = productDic.object(forKey: "is_refundable") as! Bool
        if refundable == true {
            cell.pepupImage.isHidden = false
        }
        else {
            cell.pepupImage.isHidden = true
        }
        cell.productImage.image = image
        let product_name = productDic.object(forKey: "name") as! String
        let product_price = productDic.object(forKey: "price") as! Int
        let product_size = productDic.object(forKey: "size") as! String
        cell.productName.text = product_name
        cell.productPrice.text = String(product_price)
        cell.productSize.text = product_size
//        cell.btnDetail.tag = imageID
//        cell.btnDetail.addTarget(self, action: #selector(detail(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
//    @objc func detail(_ sender: UIButton) {
//        let nextVC = DetailVC()
//        nextVC.Myid = sender.tag
//        navigationController?.pushViewController(nextVC, animated: true)
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.productDatas.count - 1 {
            pagenum = pagenum + 1
            getData(pagenum: pagenum)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
        let productId = productDictionary.object(forKey: "id") as! Int
        let nextVC = DetailVC()
        nextVC.Myid = productId
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: UICollectionViewDelegate
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/375 * 170, height: UIScreen.main.bounds.width/375 * 226)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    // line 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}
