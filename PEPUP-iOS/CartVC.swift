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
    var removeidArray : Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
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
        let statusBarHeight: CGFloat! = screenHeight/defaultHeight * 20
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        navcontentView.addSubview(btnClose)
        navcontentView.addSubview(cartLabel)
        navcontentView.addSubview(editButton)
        
        self.view.addSubview(navcontentView)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnClose.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnClose.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnClose.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        cartLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        cartLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        editButton.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        editButton.rightAnchor.constraint(equalTo: navcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 50).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 22).isActive = true
        
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
        cartCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cartCollectionView)
        
        cartCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        cartCollectionView.topAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        cartCollectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        cartCollectionView.heightAnchor.constraint(equalToConstant: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 72).isActive = true
        
        self.view.addSubview(emptyImg)
        self.view.addSubview(emptyLabel)
        
        emptyImg.centerXAnchor.constraint(equalTo:cartCollectionView.centerXAnchor).isActive = true
        emptyImg.topAnchor.constraint(equalTo:cartCollectionView.topAnchor, constant: UIScreen.main.bounds.height/667 * 220).isActive = true
        emptyImg.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 45).isActive = true
        emptyImg.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 42).isActive = true
    
        emptyLabel.centerXAnchor.constraint(equalTo:cartCollectionView.centerXAnchor).isActive = true
        emptyLabel.topAnchor.constraint(equalTo:emptyImg.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
//        emptyLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 40).isActive = true
        emptyLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true
        
        self.view.addSubview(btnPayment)
        self.view.addSubview(btnAllDelete)
        
        btnPayment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:screenWidth/defaultWidth * 18).isActive = true
        btnPayment.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:screenHeight/defaultHeight * -8).isActive = true
        btnPayment.widthAnchor.constraint(equalToConstant:screenWidth/defaultWidth * 339).isActive = true
        btnPayment.heightAnchor.constraint(equalToConstant:screenWidth/defaultWidth * 56).isActive = true
        
        btnAllDelete.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:screenWidth/defaultWidth * 18).isActive = true
        btnAllDelete.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:screenHeight/defaultHeight * -8).isActive = true
        btnAllDelete.widthAnchor.constraint(equalToConstant:screenWidth/defaultWidth * 339).isActive = true
        btnAllDelete.heightAnchor.constraint(equalToConstant:screenWidth/defaultWidth * 56).isActive = true
        
    }
    
    @objc func edit() {
        if editButton.currentTitle == "Edit" {
            editButton.setTitle("Done", for: .normal)
            btnPayment.isHidden = true
            btnAllDelete.isHidden = false
            setup()
        }
        else {
            editButton.setTitle("Edit", for: .normal)
            btnPayment.isHidden = false
            btnAllDelete.isHidden = true
            
            let parameters = [
                "trades" : removeidArray
            ]
            Alamofire.AF.request("\(Config.baseURL)/api/trades/cancel/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
                    print("\(JSON)")

                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
            if productDatas.count == 0 {
                emptyImg.isHidden = false
                emptyLabel.isHidden = false
                btnPayment.setTitle("총 0원 구매하기", for: .normal)
            }
            setup()
        }
    }
    
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
    
    let editButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Edit", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNoe-Regular", size: 16)
        btn.titleLabel?.textAlignment = .right
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(edit), for: .touchUpInside)
        return btn
    }()
    
    let emptyImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "cart_empty")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 담긴 상품이 없어요!"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.alpha = 0.3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
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
    
    let btnAllDelete : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 3
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(deleteallstore), for: .touchUpInside)
        btn.setTitle("전체 스토어 삭제하기", for: .normal)
        btn.isHidden = true
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
                if self.sellerDatas.count == 0 {
                    self.btnPayment.isEnabled = false
                    self.emptyImg.isHidden = false
                    self.emptyLabel.isHidden = false
                }
                else {
                    self.btnPayment.isEnabled = true
                    self.emptyImg.isHidden = true
                    self.emptyLabel.isHidden = true
                }
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
//        var count = productDatas[indexPath.section].count
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartCell
        let sellerDictionary = self.sellerDatas[indexPath.section] as NSDictionary
        let totalproductDatas = sellerDictionary.object(forKey: "products") as! Array<NSDictionary>
        let trade_id = totalproductDatas[indexPath.row].object(forKey: "trade_id") as! Int
        if self.editButton.currentTitle == "Edit" {
            cell.deleteButton.isHidden = true
        }
        else {
            cell.deleteButton.isHidden = false
            cell.deleteButton.tag = (indexPath.section * 1000) + indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteitem(_:)), for: .touchUpInside)
        }
//        if count > indexPath.row {
        trades[indexPath.section][indexPath.row] = trade_id
//        }
        if let productInfoDic = totalproductDatas[indexPath.row].object(forKey: "product") as? NSDictionary {
//            if count > indexPath.row {
            productDatas[indexPath.section][indexPath.row] = productInfoDic
//            }
            let productName = productInfoDic.object(forKey: "name") as! String
            let productId = productInfoDic.object(forKey: "id") as! Int
            let productPrice = productInfoDic.object(forKey: "discounted_price") as! Int
//            if count > indexPath.row {
            productpriceArray[indexPath.section][indexPath.row] = productPrice
//            totalPrice = totalPrice + productPrice
//            }
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
                let imageUrlString = sellerInfoDic.object(forKey: "profile") as! String
                let sellerID = sellerInfoDic.object(forKey: "id") as! Int
                let imageUrl:NSURL = NSURL(string: imageUrlString)!
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!

                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    headerView.btnsellerProfile.setImage(image, for: .normal)
                    headerView.btnsellerProfile.layer.cornerRadius = headerView.btnsellerProfile.frame.height / 2
                    headerView.btnsellerProfile.layer.borderColor = UIColor.clear.cgColor
                    headerView.btnsellerProfile.layer.borderWidth = 1
                    headerView.btnsellerProfile.clipsToBounds = true
                    headerView.btnsellerName.setTitle(sellerName, for: .normal)
                    headerView.btnsellerProfile.tag = sellerID
                    headerView.btnsellerName.tag = sellerID
                    UserDefaults.standard.set(sellerID, forKey: "sellerId")
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
                    if self.editButton.currentTitle == "Edit" {
                        footerView.btnPayment.setTitle("총 " + String(productPrice + delivery_charge)+"원 구매하기", for: .normal)
    //                    self.totalPrice = self.totalPrice + delivery_charge
                        self.totalPrice = self.settotalprice()
                        self.btnPayment.setTitle("총 \(String(self.totalPrice))원 구매하기", for: .normal)
                        footerView.btnPayment.tag = indexPath.section
                        footerView.btnPayment.addTarget(self, action: #selector(self.payment(_:)), for: .touchUpInside)
                        footerView.btnDelete.isHidden = true
                        footerView.btnPayment.isHidden = false
                    }
                    else {
                        footerView.btnPayment.isHidden = true
                        footerView.btnDelete.isHidden = false
                        footerView.btnDelete.tag = indexPath.section
                        footerView.btnDelete.addTarget(self, action: #selector(self.deletestore(_:)), for: .touchUpInside)
                    }
                }
                return footerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    func settotalprice() -> Int{
        var totalprice = 0
        for i in 0..<sellerDatas.count {
            let payinfoDic = sellerDatas[i].object(forKey: "payinfo") as! NSDictionary
            let total = payinfoDic.object(forKey: "total") as! Int
            let delivery_charge = payinfoDic.object(forKey: "delivery_charge") as! Int
            totalprice = totalprice + total + delivery_charge
        }
        return totalprice
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
    
    @objc func deleteitem(_ sender: UIButton) {
        print(sender.tag)
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        print(row)
        print(section)
//        let removeBaseDic = sellerDatas[section]
//        let removeproductDatas = removeBaseDic.object(forKey: "products") as! Array<NSDictionary>
//        let removeDic = removeproductDatas[row]
//        let removeid = removeDic.object(forKey: "trade_id") as! Int
//        removeidArray.append(removeid)
//        productDatas[section].remove(at: row)
//        productpriceArray[section].remove(at: row)
//        if productDatas[section].count == 0 {
//            sellerDatas.remove(at: section)
//        }
//        cartCollectionView.deleteItems(at: [IndexPath(row: row, section: section)])
//        cartCollectionView.reloadData()
    }
    
    @objc func deletestore(_ sender: UIButton) {
        
        let removeBaseDic = sellerDatas[sender.tag]
        let removeproductDatas = removeBaseDic.object(forKey: "products") as! Array<NSDictionary>
        for i in 0..<removeproductDatas.count {
            let removeDic = removeproductDatas[i]
            let removeid = removeDic.object(forKey: "trade_id") as! Int
            removeidArray.append(removeid)
        }
        sellerDatas.remove(at: sender.tag)
        productDatas.remove(at: sender.tag)
        productpriceArray.remove(at: sender.tag)
        cartCollectionView.deleteSections(NSIndexSet(index: sender.tag) as IndexSet)
        cartCollectionView.reloadData()
    }
    
    @objc func deleteallstore() {
        for i in 0..<sellerDatas.count {
            if i == 0 {
                let removeBaseDic = sellerDatas[i]
                let removeproductDatas = removeBaseDic.object(forKey: "products") as! Array<NSDictionary>
                for i in 0..<removeproductDatas.count {
                    let removeDic = removeproductDatas[i]
                    let removeid = removeDic.object(forKey: "trade_id") as! Int
                    removeidArray.append(removeid)
                }
                sellerDatas.remove(at: i)
                productDatas.remove(at: i)
                productpriceArray.remove(at: i)
                cartCollectionView.deleteSections(NSIndexSet(index: i) as IndexSet)
            }
            else {
                let removeBaseDic = sellerDatas[i-1]
                let removeproductDatas = removeBaseDic.object(forKey: "products") as! Array<NSDictionary>
                for i in 0..<removeproductDatas.count {
                    let removeDic = removeproductDatas[i]
                    let removeid = removeDic.object(forKey: "trade_id") as! Int
                    removeidArray.append(removeid)
                }
                sellerDatas.remove(at: i-1)
                productDatas.remove(at: i-1)
                productpriceArray.remove(at: i-1)
                cartCollectionView.deleteSections(NSIndexSet(index: i-1) as IndexSet)
            }
        }
        cartCollectionView.reloadData()
    }
    
    @objc func totalpayment() {
        let nextVC = PaymentVC()
        for i in 0..<trades.count {
            for j in 0..<trades[i].count {
                nextVC.trades.append(trades[i][j])
            }
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
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
    
//    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//        let removeBaseDic = sellerDatas[indexPath.section]
//        let removeproductDatas = removeBaseDic.object(forKey: "products") as! Array<NSDictionary>
//        let removeDic = removeproductDatas[indexPath.row]
//        let removeid = removeDic.object(forKey: "trade_id") as! Int
//        let parameters = [
//            "trades" : [removeid]
//        ]
//        Alamofire.AF.request("\(Config.baseURL)/api/trades/cancel/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
//            (response) in switch response.result {
//            case .success(let JSON):
//                print("\(JSON)")
//                
//            case .failure(let error):
//                print("Request failed with error: \(error)")
//            }
//        }
//        productDatas[indexPath.section].remove(at: indexPath.row)
//        productpriceArray[indexPath.section].remove(at: indexPath.row)
//        btnPayment.setTitle("총 0원 구매하기", for: .normal)
//        collectionView.deleteItems(at: [IndexPath(row: indexPath.row, section: indexPath.section)])
//        getData()
//    }
}

