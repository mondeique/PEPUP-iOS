//
//  PurchasedVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/20.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "purchasecell"
private let headerId = "purchaseheadercell"

class PurchasedVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var purchaseUid : Int!
    var purchasecollectionView : UICollectionView!
    var scrollView: UIScrollView!
    
    var purchasedtotalDatas : NSDictionary!
    var purchasedproductDic = Array<NSDictionary>()
    
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
        navcontentView.addSubview(purchasedLabel)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        purchasedLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        purchasedLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth/defaultWidth * 80)
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: screenWidth, height: UIScreen.main.bounds.height/667 * 60)
        
        purchasecollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: layout)
        purchasecollectionView.delegate = self
        purchasecollectionView.dataSource = self
        purchasecollectionView.register(PurchasedMainCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        purchasecollectionView.register(PurchasedMainHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        purchasecollectionView.backgroundColor = UIColor.white
        purchasecollectionView.translatesAutoresizingMaskIntoConstraints = false
        purchasecollectionView.isHidden = false
        
        scrollView = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: navBarHeight + statusBarHeight), size: CGSize(width: screenWidth, height: screenHeight)))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollView.contentInset = UIEdgeInsets.zero
        self.view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeight + statusBarHeight).isActive = true
        
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight/defaultHeight * 1000)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/purchased/" + String(purchaseUid) + "/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                
                print(response)
//                DispatchQueue.main.async {
//                    self.purchasedcollectionView.reloadData()
//                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return purchasedproductDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sellerDic = self.purchasedproductDic[section] as NSDictionary
        let productArray = sellerDic.object(forKey: "products") as! Array<Dictionary<String, Any>>
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PurchasedMainCell
//        let sellerDictionary = self.orderproductDic[indexPath.section] as NSDictionary
//        let totalproductDatas = sellerDictionary.object(forKey: "products") as! Array<NSDictionary>
//        if let productInfoDic = totalproductDatas[indexPath.row].object(forKey: "product") as? NSDictionary {
//            let productName = productInfoDic.object(forKey: "name") as! String
//            let productPrice = productInfoDic.object(forKey: "discounted_price") as! Int
//            let productSize = productInfoDic.object(forKey: "size") as! String
//            let productImgDic = productInfoDic.object(forKey: "thumbnails") as! NSDictionary
//            let imageUrlString = productImgDic.object(forKey: "thumbnail") as! String
//            let imageUrl:NSURL = NSURL(string: imageUrlString)!
//            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
//            DispatchQueue.main.async {
//                let image = UIImage(data: imageData as Data)
//                cell.productImage.setImage(image, for: .normal)
//                cell.productNameLabel.text = productName
//                cell.productPriceLabel.text = String(productPrice) + "원"
//                cell.productSizeLabel.text = productSize
//            }
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PurchasedMainHeaderCell
//                let DataDic = orderproductDic[indexPath.section] as NSDictionary
//                let sellerInfoDic = DataDic.object(forKey: "seller") as! NSDictionary
//                let sellerName = sellerInfoDic.object(forKey: "nickname") as! String
//                let sellerprofileDic = sellerInfoDic.object(forKey: "profile") as! NSDictionary
//                let imageUrlString = sellerprofileDic.object(forKey: "thumbnail_img") as! String
//                let imageUrl:NSURL = NSURL(string: imageUrlString)!
//                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
//
//                DispatchQueue.main.async {
//                    let image = UIImage(data: imageData as Data)
//                    headerView.btnsellerProfile.setImage(image, for: .normal)
//                    headerView.btnsellerProfile.layer.cornerRadius = headerView.btnsellerProfile.frame.height / 2
//                    headerView.btnsellerProfile.layer.borderColor = UIColor.clear.cgColor
//                    headerView.btnsellerProfile.layer.borderWidth = 1
//                    headerView.btnsellerProfile.layer.masksToBounds = false
//                    headerView.btnsellerProfile.clipsToBounds = true
//                    headerView.btnsellerName.setTitle(sellerName, for: .normal)
//                }
                
                return headerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 80)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
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
    
    let purchasedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        label.textColor = .black
        label.text = "P U R C H A S E D"
        label.textAlignment = .center
        return label
    }()
}

class PurchasedMainCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        paymentcellContentView.addSubview(productImage)
        paymentcellContentView.addSubview(productNameLabel)
        paymentcellContentView.addSubview(productSizeLabel)
        paymentcellContentView.addSubview(productPriceLabel)
        self.addSubview(paymentcellContentView)

        paymentcellContentViewLayout()
        productImageLayout()
        productNameLabelLayout()
        productSizeLabelLayout()
        productPriceLabelLayout()

    }
    
    let paymentcellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let productImage: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/375 * 60, height: UIScreen.main.bounds.width/375 * 60))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        return btn
    }()

    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.backgroundColor = .white
        return label
    }()

    func paymentcellContentViewLayout() {
        paymentcellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        paymentcellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        paymentcellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        paymentcellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productImageLayout() {
        productImage.leftAnchor.constraint(equalTo:paymentcellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productImage.topAnchor.constraint(equalTo:paymentcellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
        productImage.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 60).isActive = true
        productImage.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 60).isActive = true
    }

    func productNameLabelLayout() {
        productNameLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        productNameLabel.topAnchor.constraint(equalTo:paymentcellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 10).isActive = true
//        productNameLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 150).isActive = true
        productNameLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true
    }

    func productSizeLabelLayout() {
        productSizeLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        productSizeLabel.topAnchor.constraint(equalTo:productNameLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 4).isActive = true
//        productSizeLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
        productSizeLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true
    }

    func productPriceLabelLayout() {
        productPriceLabel.rightAnchor.constraint(equalTo:paymentcellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productPriceLabel.topAnchor.constraint(equalTo:paymentcellContentView.topAnchor, constant:10).isActive = true
//        productPriceLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
        productPriceLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 20).isActive = true
    }
}

class PurchasedMainHeaderCell: BaseCollectionViewCell {
    override func setup() {
        backgroundColor = .white
        paymentheadercellContentView.addSubview(btnsellerProfile)
        paymentheadercellContentView.addSubview(btnsellerName)
        self.addSubview(paymentheadercellContentView)

        paymentheadercellContentViewLayout()
        btnsellerProfileLayout()
        btnsellerNameLayout()
    }
    
    let paymentheadercellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let btnsellerProfile:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let btnsellerName: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.setTitleColor(.black, for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    func paymentheadercellContentViewLayout() {
        paymentheadercellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        paymentheadercellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        paymentheadercellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        paymentheadercellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func btnsellerProfileLayout() {
        btnsellerProfile.leftAnchor.constraint(equalTo:paymentheadercellContentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        btnsellerProfile.topAnchor.constraint(equalTo:paymentheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 10).isActive = true
        btnsellerProfile.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnsellerProfile.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 40).isActive = true
        btnsellerProfile.centerYAnchor.constraint(equalTo:paymentheadercellContentView.centerYAnchor).isActive = true
    }
    
    func btnsellerNameLayout() {
        btnsellerName.leftAnchor.constraint(equalTo:btnsellerProfile.rightAnchor, constant: UIScreen.main.bounds.width/375 * 10).isActive = true
        btnsellerName.topAnchor.constraint(equalTo:paymentheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        btnsellerName.centerYAnchor.constraint(equalTo:paymentheadercellContentView.centerYAnchor).isActive = true
    }
}


