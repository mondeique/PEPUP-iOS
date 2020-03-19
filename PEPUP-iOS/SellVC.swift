//
//  SellVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/10.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "sellselectcell"

class SellVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var imageData: Array<UIImage?> = []
    var sellproductcollectionView : UICollectionView!
    var scrollView: UIScrollView!
    var keyArray: Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        keyArray = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setinfo()
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
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
        
        scrollView = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: navBarHeight + statusBarHeight), size: CGSize(width: screenWidth, height: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 72)))
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
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 72).isActive = true
        
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight/defaultHeight * 821)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/defaultWidth * 96, height: screenWidth/defaultWidth * 96)
        layout.scrollDirection = .horizontal
        
        sellproductcollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: layout)
        sellproductcollectionView.delegate = self
        sellproductcollectionView.dataSource = self
        sellproductcollectionView.register(SellCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        sellproductcollectionView.backgroundColor = UIColor.white
        sellproductcollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(sellproductcollectionView)
        
        sellproductcollectionView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        sellproductcollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        sellproductcollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        sellproductcollectionView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 128).isActive = true
        
        scrollView.addSubview(productNameLabel)
        scrollView.addSubview(productNametxtView)
        scrollView.addSubview(productPriceLabel)
        scrollView.addSubview(productPricetxtView)
        scrollView.addSubview(productDetailLabel)
        scrollView.addSubview(productDetailtxtView)
        scrollView.addSubview(categoryLabel)
        scrollView.addSubview(categoryRealLabel)
        scrollView.addSubview(btnCategoryGO)
        scrollView.addSubview(lineLabel1)
        scrollView.addSubview(sizeLabel)
        scrollView.addSubview(sizeRealLabel)
        scrollView.addSubview(btnSizeGO)
        scrollView.addSubview(lineLabel2)
        scrollView.addSubview(brandLabel)
        scrollView.addSubview(brandRealLabel)
        scrollView.addSubview(btnBrandGO)
        scrollView.addSubview(lineLabel3)
        scrollView.addSubview(tagLabel)
        scrollView.addSubview(tagtxtView)
        
        productNameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        productNameLabel.topAnchor.constraint(equalTo: sellproductcollectionView.bottomAnchor).isActive = true
//        productNameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        productNameLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        productNametxtView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        productNametxtView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        productNametxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        productNametxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true
        
        productPriceLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        productPriceLabel.topAnchor.constraint(equalTo: productNametxtView.bottomAnchor, constant: screenHeight/defaultHeight * 24).isActive = true
//        productPriceLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        productPriceLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        productPricetxtView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        productPricetxtView.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        productPricetxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        productPricetxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true
        
        productDetailLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        productDetailLabel.topAnchor.constraint(equalTo: productPricetxtView.bottomAnchor, constant: screenHeight/defaultHeight * 24).isActive = true
//        productDetailLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        productDetailLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        productDetailtxtView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        productDetailtxtView.topAnchor.constraint(equalTo: productDetailLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        productDetailtxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        productDetailtxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 80).isActive = true
        
        productNametxtView.delegate = self
        productPricetxtView.delegate = self
        productDetailtxtView.delegate = self
        
        categoryLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: productDetailtxtView.bottomAnchor, constant: screenHeight/defaultHeight * 34).isActive = true
//        categoryLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        categoryRealLabel.rightAnchor.constraint(equalTo: categoryLabel.leftAnchor, constant: screenWidth/defaultWidth * 313).isActive = true
        categoryRealLabel.topAnchor.constraint(equalTo: productDetailtxtView.bottomAnchor, constant: screenHeight/defaultHeight * 34).isActive = true
//        categoryRealLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        categoryRealLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        btnCategoryGO.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 347).isActive = true
        btnCategoryGO.topAnchor.constraint(equalTo: productDetailtxtView.bottomAnchor, constant: screenHeight/defaultHeight * 36).isActive = true
        btnCategoryGO.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnCategoryGO.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        lineLabel1.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        lineLabel1.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: screenHeight/defaultHeight * 18).isActive = true
        lineLabel1.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        lineLabel1.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true
        
        sizeLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        sizeLabel.topAnchor.constraint(equalTo: lineLabel1.bottomAnchor, constant: screenHeight/defaultHeight * 17).isActive = true
//        sizeLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        sizeLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        sizeRealLabel.rightAnchor.constraint(equalTo: sizeLabel.leftAnchor, constant: screenWidth/defaultWidth * 313).isActive = true
        sizeRealLabel.topAnchor.constraint(equalTo: lineLabel1.bottomAnchor, constant: screenHeight/defaultHeight * 17).isActive = true
//        sizeRealLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        sizeRealLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        btnSizeGO.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 347).isActive = true
        btnSizeGO.topAnchor.constraint(equalTo: lineLabel1.bottomAnchor, constant: screenHeight/defaultHeight * 20).isActive = true
        btnSizeGO.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnSizeGO.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        lineLabel2.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        lineLabel2.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: screenHeight/defaultHeight * 18).isActive = true
        lineLabel2.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        lineLabel2.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true
        
        brandLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        brandLabel.topAnchor.constraint(equalTo: lineLabel2.bottomAnchor, constant: screenHeight/defaultHeight * 17).isActive = true
//        brandLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        brandLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        brandRealLabel.rightAnchor.constraint(equalTo: brandLabel.leftAnchor, constant: screenWidth/defaultWidth * 313).isActive = true
        brandRealLabel.topAnchor.constraint(equalTo: lineLabel2.bottomAnchor, constant: screenHeight/defaultHeight * 17).isActive = true
//        brandRealLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        brandRealLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        btnBrandGO.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 347).isActive = true
        btnBrandGO.topAnchor.constraint(equalTo: lineLabel2.bottomAnchor, constant: screenHeight/defaultHeight * 20).isActive = true
        btnBrandGO.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBrandGO.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        lineLabel3.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        lineLabel3.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: screenHeight/defaultHeight * 18).isActive = true
        lineLabel3.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        lineLabel3.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true
        
        tagLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        tagLabel.topAnchor.constraint(equalTo: lineLabel3.bottomAnchor, constant: screenHeight/defaultHeight * 32).isActive = true
//        tagLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        tagLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        tagtxtView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        tagtxtView.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        tagtxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        tagtxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 84).isActive = true
        
        let tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(taggo))
        
        tagtxtView.addGestureRecognizer(tapOutTextField)
        
        self.view.addSubview(bottomcontentView)
        
        bottomcontentView.addSubview(btnUpload)
        
        bottomcontentView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        bottomcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        bottomcontentView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 72).isActive = true
        
        btnUpload.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 325).isActive = true
        btnUpload.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 56).isActive = true
        btnUpload.centerXAnchor.constraint(equalTo: bottomcontentView.centerXAnchor).isActive = true
        btnUpload.centerYAnchor.constraint(equalTo: bottomcontentView.centerYAnchor).isActive = true
    }
    
    func setinfo() {
        if UserDefaults.standard.object(forKey: "second_category") != nil {
            categoryRealLabel.text = UserDefaults.standard.object(forKey: "second_category") as? String
        }
        
        if UserDefaults.standard.object(forKey: "size") != nil {
            sizeRealLabel.text = UserDefaults.standard.object(forKey: "size") as? String
        }
        
        if UserDefaults.standard.object(forKey: "brand") != nil {
            brandRealLabel.text = UserDefaults.standard.object(forKey: "brand") as? String
        }
        if UserDefaults.standard.object(forKey: "tag") != nil {
            tagtxtView.text = UserDefaults.standard.object(forKey: "tag") as? String
        }
    }
    
    @objc func back() {
        imageData = []
        sellproductcollectionView.reloadData()
        let nextVC = SellSelectVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func categorygo() {
        let nextVC = SellCategoryGenderVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func sizego() {
        let nextVC = SellCategorySizeVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func brandgo() {
        let nextVC = SellCategoryBrandVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func taggo() {
        let nextVC = SellCategoryTagVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func upload() {
        for i in 0..<imageData.count {
            Alamofire.AF.request("\(Config.baseURL)/api/s3/temp_key/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
                    print("SUCESS TEMP KEY! \(JSON)")
                    let response = JSON as! NSDictionary
                    let url = response.object(forKey: "url") as! String
                    let image_key = response.object(forKey: "image_key") as! String
                    let key = response.object(forKey: "key") as! String
                    print("KEY IS \(key)")
                    self.keyArray.append(key)
                    print(self.keyArray)
                    let content_type = response.object(forKey: "content_type") as! String
                    if let upload_image = self.imageData[i]?.jpegData(compressionQuality: 1){
                        let parameters = [
                            "key": image_key,
                            "content_type" : content_type
                        ]
                        AF.upload(multipartFormData: { (multipartFormData) in
                            for(key,value) in parameters{
                                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                            }
                            multipartFormData.append(upload_image, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
                        }, to: url, method: .post).responseString { (response) in
                            debugPrint("RESPONSE: \(response)")
                        }
                    }

                case .failure(let error):
                    print("HERE!")
                    print("Request failed with error: \(error)")
                }
            }
        }
        print("KEYARRAY \(self.keyArray)")
        let seconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            guard let key_Array = self.keyArray else {
                return
            }
            guard let name = self.productNametxtView.text else {
                return
            }
            guard let price = self.productPricetxtView.text else {
                return
            }
            guard let content = self.productDetailtxtView.text else {
                return
            }
            guard let first_category = UserDefaults.standard.object(forKey: "first_category") else {
                return
            }
            guard let second_category = UserDefaults.standard.object(forKey: "second_category_id") else {
                return
            }
            guard let size = UserDefaults.standard.object(forKey: "size_id") else {
                return
            }
            guard let brand = UserDefaults.standard.object(forKey: "brand_id") else {
                return
            }
            guard let tag = UserDefaults.standard.object(forKey: "tag") else {
                return
            }
            print("ALSKDALSDKASLDK")
            print(key_Array)
            print(name)
            print(price)
            print(content)
            print(first_category)
            print(second_category)
            print(size)
            print(brand)
            print(tag)
            print("EIXT")
            if key_Array.count == self.imageData.count {
                let parameters = [
                    "image_key" : key_Array,
                    "name" : name,
                    "price" : Int(price),
                    "content" : content,
                    "first_category" : first_category,
                    "second_category" : second_category,
                    "size" : size,
                    "brand" : brand,
                    "tag" : [tag]
                ]
                Alamofire.AF.request("\(Config.baseURL)/api/products/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                    (response) in switch response.result {
                    case .success(let JSON):
                        print("SUCESS UPLOAD! \(JSON)")
                        let nextVC = TabBarController()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    case .failure(let error):
                        print("THERE!")
                        print("Request failed with error: \(error)")
                        
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SellCell
        cell.productImageView.image = imageData[indexPath.row]!
        return cell
    }
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/375 * 96, height: UIScreen.main.bounds.width/375 * 96)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width/375 * 8.0
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
        label.text = "SELLING"
        label.textAlignment = .center
        return label
    }()
    
    let productNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이름"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let productNametxtView : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "상품명을 입력해주세요"
        return txtView
    }()
    
    let productPriceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "가격"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let productPricetxtView : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "가격을 입력해주세요(원 단위)"
        return txtView
    }()
    
    let productDetailLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "상세설명"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let productDetailtxtView : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "상세설명을 입력해주세요"
        return txtView
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "분류"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let categoryRealLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .right
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let btnCategoryGO : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnGO"), for: .normal)
        btn.addTarget(self, action: #selector(categorygo), for: .touchUpInside)
        return btn
    }()
    
    let lineLabel1 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let sizeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "사이즈"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let sizeRealLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .right
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let btnSizeGO : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnGO"), for: .normal)
        btn.addTarget(self, action: #selector(sizego), for: .touchUpInside)
        return btn
    }()
    
    let lineLabel2 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let brandLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "브랜드"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let brandRealLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .right
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let btnBrandGO : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnGO"), for: .normal)
        btn.addTarget(self, action: #selector(brandgo), for: .touchUpInside)
        return btn
    }()
    
    let lineLabel3 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let tagLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "태그"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let tagtxtView : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.textColor = .black
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        return txtView
    }()
    
    let bottomcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnUpload: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 3
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("업로드 하기", for: .normal)
        btn.backgroundColor = .black
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.addTarget(self, action: #selector(upload), for: .touchUpInside)
        return btn
    }()
}

extension SellVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TOUCHME")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewSetupView() {
        if productNametxtView.text == "상품명을 입력해주세요" {
            productNametxtView.text = ""
            productNametxtView.textColor = UIColor.black
        }
        else if productNametxtView.text == "" {
            productNametxtView.text = "상품명을 입력해주세요"
            productNametxtView.textColor = UIColor(rgb: 0xEBEBF6)
        }
        if productPricetxtView.text == "가격을 입력해주세요(원 단위)" {
            productPricetxtView.text = ""
            productPricetxtView.textColor = UIColor.black
        }
        else if productPricetxtView.text == "" {
            productPricetxtView.text = "가격을 입력해주세요(원 단위)"
            productPricetxtView.textColor = UIColor(rgb: 0xEBEBF6)
        }
        if productDetailtxtView.text == "상세설명을 입력해주세요" {
            productDetailtxtView.text = ""
            productDetailtxtView.textColor = UIColor.black
        }
        else if productDetailtxtView.text == "" {
            productDetailtxtView.text = "상세설명을 입력해주세요"
            productDetailtxtView.textColor = UIColor(rgb: 0xEBEBF6)
        }
    }
}

class SellCell: BaseCollectionViewCell {
    
    override func setup() {
        backgroundColor = .red
        
        cellcontentView.addSubview(productImageView)

        self.addSubview(cellcontentView)

        cellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        productImageView.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor).isActive = true
        productImageView.topAnchor.constraint(equalTo: cellcontentView.topAnchor).isActive = true
        productImageView.widthAnchor.constraint(equalTo: cellcontentView.widthAnchor).isActive = true
        productImageView.heightAnchor.constraint(equalTo: cellcontentView.heightAnchor).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    let cellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let productImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
}
