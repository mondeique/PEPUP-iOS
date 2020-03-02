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
    var productDatas = Array<NSDictionary>()
    var productpriceArray: Array<Array<Int>> = []
    var totalprice: Array<Int> = [0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
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
        layout.itemSize = CGSize(width: screenWidth/defaultWidth * 375, height: 100)
        
        cartCollectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: view.frame.width, height: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 130), collectionViewLayout: layout)
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        cartCollectionView.register(CartCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cartCollectionView.register(CartHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        cartCollectionView.register(CartFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        cartCollectionView.backgroundColor = UIColor.white
        
        let btnPayment : UIButton = {
            let btn = UIButton()
            btn.backgroundColor = .black
            btn.layer.cornerRadius = 3
            btn.clipsToBounds = true
            btn.setTitle("총 " + String(totalprice[0]) + "원 구매하기", for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.layer.cornerRadius = 3
            btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
            btn.setTitleColor(.white, for: .normal)
            btn.addTarget(self, action: #selector(totalpayment), for: .touchUpInside)
            return btn
        }()
        
        self.view.addSubview(btnPayment)
        self.view.addSubview(cartCollectionView)
        
        btnPayment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:screenWidth/defaultWidth * 18).isActive = true
        btnPayment.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:screenHeight/defaultHeight * -5).isActive = true
        btnPayment.widthAnchor.constraint(equalToConstant:screenWidth/defaultWidth * 339).isActive = true
        btnPayment.heightAnchor.constraint(equalToConstant:screenWidth/defaultWidth * 56).isActive = true
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/trades/cart/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                for i in 0..<response.count {
                    self.sellerDatas.append(response[i])
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
        // #warning Incomplete implementation, return the number of sections
        return self.sellerDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sellerDic = self.sellerDatas[section] as NSDictionary
        let productArray = sellerDic.object(forKey: "products") as! Array<Dictionary<String, Any>>
        return productArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartCell
        let sellerDictionary = self.sellerDatas[indexPath.section] as NSDictionary
        productDatas = sellerDictionary.object(forKey: "products") as! Array<NSDictionary>
        let productDic = productDatas[indexPath.row] as NSDictionary
        productDatas.append(productDic)
        if let productInfoDic = productDatas[indexPath.row].object(forKey: "product") as? NSDictionary {
            let productName = productInfoDic.object(forKey: "name") as! String
            let productId = productInfoDic.object(forKey: "id") as! Int
            let productPrice = productInfoDic.object(forKey: "price") as! Int
            productpriceArray.append([])
            productpriceArray[indexPath.section].append(productPrice)
            totalprice.append(productPrice)
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
                let imageUrlString = sellerprofileDic.object(forKey: "thumbnail_img") as! String
                let imageUrl:NSURL = NSURL(string: imageUrlString)!
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!

                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    headerView.btnsellerProfile.setImage(image, for: .normal)
                    headerView.btnsellerName.setTitle(sellerName, for: .normal)
                    headerView.btnsellerProfile.addTarget(self, action: #selector(self.sellerstore), for: .touchUpInside)
                    headerView.btnsellerName.addTarget(self, action: #selector(self.sellerstore), for: .touchUpInside)
                }
                return headerView

            case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! CartFooterCell
                let sellerDictionary = self.sellerDatas[indexPath.section] as NSDictionary
                var productDatas = Array<NSDictionary>()
                productDatas = sellerDictionary.object(forKey: "products") as! Array<NSDictionary>
                let payinfoDic = sellerDictionary.object(forKey: "payinfo") as! NSDictionary
                let productDic = productDatas[indexPath.row] as NSDictionary
                let productInfoDic = productDic.object(forKey: "product") as! NSDictionary
                let productPrice = productInfoDic.object(forKey: "price") as! Int
                var totalproductPrice: Int = 0
                for i in 0..<productpriceArray[indexPath.section].count {
                    totalproductPrice = totalproductPrice + productpriceArray[indexPath.section][i]
                }
                let delivery_charge = payinfoDic.object(forKey: "delivery_charge") as! Int

                DispatchQueue.main.async {
                    footerView.productpriceInfoLabel.text = String(totalproductPrice) + "원"
                    footerView.productdeliveryInfoLabel.text = String(delivery_charge) + "원"
                    footerView.btnPayment.setTitle("총 " + String(totalproductPrice + delivery_charge)+"원 구매하기", for: .normal)
                    footerView.btnPayment.addTarget(self, action: #selector(self.payment), for: .touchUpInside)
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
    
    @objc func sellerstore() {
        print("GO SELLER STORE!")
    }
    
    @objc func payment() {
        print("TOUCH ASDLSKD")
    }
    
    @objc func totalpayment() {
        print("TOUCH TOTAL PAYMENT")
    }
    
    // MARK: UICollectionViewDelegate
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
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
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    */
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        productDatas.remove(at: indexPath.row)
        cartCollectionView.deleteItems(at: [indexPath])
    }
}

