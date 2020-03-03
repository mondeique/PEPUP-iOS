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
private let footerId = "searchresultfootercell"

var resultCollectionView: UICollectionView!

class SearchResultVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var searchName : String!
    var searchCount : Int!
    var productDatas = Array<NSDictionary>()
    var pagenum: Int = 1
    
    var resultCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setup()
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
        layout.itemSize = CGSize(width: screenWidth/defaultWidth * 170, height: screenWidth/defaultWidth * 170)
        
        resultCollectionView = UICollectionView(frame: CGRect(x: screenWidth/defaultWidth * 12, y: statusBarHeight + navBarHeight + screenWidth/defaultWidth * 40, width: view.frame.width - screenWidth/defaultWidth * 24, height: screenHeight - statusBarHeight - navBarHeight), collectionViewLayout: layout)
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        resultCollectionView.register(SearchResultFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        resultCollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(resultCollectionView)
        
    }
    
    func getData() {
        let parameters: [String: String] = [
            "keyword" : searchName
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/search/product_search/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                print(response)
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
        return productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultCell
        let productDic = self.productDatas[indexPath.section] as NSDictionary
        let imageDic = productDic.object(forKey: "images") as! NSDictionary
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {

            case UICollectionView.elementKindSectionFooter:

                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! SearchResultFooterCell
                DispatchQueue.main.async {
                    let productDic = self.productDatas[indexPath.section] as NSDictionary
                    let product_name = productDic.object(forKey: "name") as! String
                    let product_price = productDic.object(forKey: "price") as! Int
                    let product_size = productDic.object(forKey: "size") as! String
                    footerView.productName.text = product_name
                    footerView.productPrice.text = String(product_price)
                    footerView.productSize.text = product_size
                }
                return footerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func detail(_ sender: UIButton) {
        let nextVC = DetailVC()
        nextVC.Myid = sender.tag
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: UICollectionViewDelegate
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/375 * 170, height: UIScreen.main.bounds.width/375 * 170)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    // line 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 80.0)
    }
}
