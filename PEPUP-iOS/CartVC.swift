//
//  CartVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/13.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "cartcell"
private let headerId = "cartheadercell"
private let footerId = "cartfootercell"

var cartCollectionView: UICollectionView!

class CartVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var sellerDatas = Array<NSDictionary>()
    var productDatas = Array<Array<NSDictionary>>()
    var productpriceArray: Array<Array<Int>> = []
    var totalPrice: Int = 0
    var trades : Array<Array<Int>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
        getData()
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

        let btnClose: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(named: "btnClose"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.addTarget(self, action: #selector(back), for: .touchUpInside)
            return btn
        }()
        
        let cartLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "C A R T"
            label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        
        navcontentView.addSubview(btnClose)
        navcontentView.addSubview(cartLabel)
        
        self.view.addSubview(navcontentView)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnClose.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnClose.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnClose.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        cartLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        cartLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/defaultWidth * 375, height: screenHeight/defaultHeight * 100)
        
        cartCollectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: view.frame.width, height: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 72), collectionViewLayout: layout)
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        cartCollectionView.register(CartCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cartCollectionView.register(CartHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        cartCollectionView.register(CartFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        cartCollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(btnPayment)
        self.view.addSubview(cartCollectionView)
        
        btnPayment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:screenWidth/defaultWidth * 18).isActive = true
        btnPayment.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:screenHeight/defaultHeight * -8).isActive = true
        btnPayment.widthAnchor.constraint(equalToConstant:screenWidth/defaultWidth * 339).isActive = true
        btnPayment.heightAnchor.constraint(equalToConstant:screenWidth/defaultWidth * 56).isActive = true
    }
    
    let btnPayment : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 3
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(totalpayment), for: .touchUpInside)
        btn.setTitle("총 0원 구매하기", for: .normal)
        return btn
    }()
    
    
    func getData() {
        sellerDatas = Array<NSDictionary>()
        productDatas = Array<Array<NSDictionary>>()
        productpriceArray = []
        trades = []
        Alamofire.AF.request("\(Config.baseURL)/api/trades/cart/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                for i in 0..<response.count {
                    self.sellerDatas.append(response[i])
                }
                print(self.sellerDatas)
                for i in 0..<self.sellerDatas.count {
                    self.productpriceArray.append([])
                    self.productDatas.append([])
                    self.trades.append([])
                    let sellerDic = self.sellerDatas[i] as NSDictionary
                    let productArray = sellerDic.object(forKey: "products") as! Array<Dictionary<String, Any>>
                    for j in 0..<productArray.count {
                        self.productDatas[i].append(NSDictionary())
                        self.productpriceArray[i].append(0)
                        self.trades[i].append(0)
                    }
                }
                DispatchQueue.main.async {
                    cartCollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sellerDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sellerDic = self.sellerDatas[section] as NSDictionary
        let productArray = sellerDic.object(forKey: "products") as! Array<Dictionary<String, Any>>
        return productArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var count = productDatas[indexPath.section].count
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartCell
        let sellerDictionary = self.sellerDatas[indexPath.section] as NSDictionary
        let totalproductDatas = sellerDictionary.object(forKey: "products") as! Array<NSDictionary>
        let trade_id = totalproductDatas[indexPath.row].object(forKey: "trade_id") as! Int
        if count > indexPath.row {
            trades[indexPath.section][indexPath.row] = trade_id
        }
        if let productInfoDic = totalproductDatas[indexPath.row].object(forKey: "product") as? NSDictionary {
            if count > indexPath.row {
                productDatas[indexPath.section][indexPath.row] = productInfoDic
            }
            let productName = productInfoDic.object(forKey: "name") as! String
            let productId = productInfoDic.object(forKey: "id") as! Int
            let productPrice = productInfoDic.object(forKey: "discounted_price") as! Int
            if count > indexPath.row {
                productpriceArray[indexPath.section][indexPath.row] = productPrice
                totalPrice = totalPrice + productPrice
            }
            let productSize = productInfoDic.object(forKey: "size") as! String
            let productImgDic = productInfoDic.object(forKey: "thumbnails") as! NSDictionary
            let imageUrlString = productImgDic.object(forKey: "thumbnail") as! String
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                cell.productImage.setImage(image, for: .normal)
                cell.productImage.tag = productId
                cell.productImage.addTarget(self, action: #selector(self.detail(_:)), for: .touchUpInside)
                cell.productNameLabel.text = productName
                cell.productPriceLabel.text = String(productPrice) + "원"
                cell.productSizeLabel.text = productSize
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CartHeaderCell
                let sellerDictionary = self.sellerDatas[indexPath.section] as NSDictionary
                let sellerInfoDic = sellerDictionary.object(forKey: "seller") as! NSDictionary
                let sellerName = sellerInfoDic.object(forKey: "nickname") as! String
                let sellerprofileDic = sellerInfoDic.object(forKey: "profile") as! NSDictionary
                let sellerID = sellerInfoDic.object(forKey: "id") as! Int
                let imageUrlString = sellerprofileDic.object(forKey: "thumbnail_img") as! String
                let imageUrl:NSURL = NSURL(string: imageUrlString)!
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!

                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    headerView.btnsellerProfile.setImage(image, for: .normal)
                    headerView.btnsellerProfile.layer.cornerRadius = headerView.btnsellerProfile.frame.height / 2
                    headerView.btnsellerProfile.layer.borderColor = UIColor.clear.cgColor
                    headerView.btnsellerProfile.layer.borderWidth = 1
                    headerView.btnsellerProfile.layer.masksToBounds = false
                    headerView.btnsellerProfile.clipsToBounds = true
                    headerView.btnsellerName.setTitle(sellerName, for: .normal)
                    headerView.btnsellerProfile.tag = sellerID
                    headerView.btnsellerName.tag = sellerID
                    headerView.btnsellerProfile.addTarget(self, action: #selector(self.sellerstore(_:)), for: .touchUpInside)
                    headerView.btnsellerName.addTarget(self, action: #selector(self.sellerstore(_:)), for: .touchUpInside)
                }
                return headerView

            case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! CartFooterCell
                let sellerDictionary = self.sellerDatas[indexPath.section] as NSDictionary
                let payinfoDic = sellerDictionary.object(forKey: "payinfo") as! NSDictionary
                let productPrice = payinfoDic.object(forKey: "total") as! Int
                let delivery_charge = payinfoDic.object(forKey: "delivery_charge") as! Int
                DispatchQueue.main.async {
                    footerView.productpriceInfoLabel.text = String(productPrice) + "원"
                    footerView.productdeliveryInfoLabel.text = String(delivery_charge) + "원"
                    footerView.btnPayment.setTitle("총 " + String(productPrice + delivery_charge)+"원 구매하기", for: .normal)
                    // TODO :- 배송비 더하기~
                    self.totalPrice = self.totalPrice + delivery_charge
                    self.btnPayment.setTitle("총 \(String(self.totalPrice))원 구매하기", for: .normal)
                    footerView.btnPayment.tag = indexPath.section
                    footerView.btnPayment.addTarget(self, action: #selector(self.payment(_:)), for: .touchUpInside)
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
    
    @objc func sellerstore(_ sender: UIButton) {
        let nextVC = StoreVC()
        nextVC.SellerID = sender.tag
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func payment(_ sender: UIButton) {
        let nextVC = PaymentVC()
        nextVC.trades = trades[sender.tag]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func totalpayment() {
        print("TOUCH TOTAL PAYMENT")
    }
    
    // MARK: UICollectionViewDelegate
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 100)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // line 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 56)
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 164.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let removeBaseDic = sellerDatas[indexPath.section]
        let removeproductDatas = removeBaseDic.object(forKey: "products") as! Array<NSDictionary>
        let removeDic = removeproductDatas[indexPath.row]
        let removeid = removeDic.object(forKey: "trade_id") as! Int
        let parameters = [
            "trades" : [removeid]
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/trades/cancel/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print("SUCCESS")
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        productDatas[indexPath.section].remove(at: indexPath.row)
        productpriceArray[indexPath.section].remove(at: indexPath.row)
        collectionView.deleteItems(at: [IndexPath(row: indexPath.row, section: indexPath.section)])
        getData()
    }
}

