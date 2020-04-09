//
//  PurchasedVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/20.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialBottomSheet

private let reuseIdentifier = "purchasecell"
private let headerId = "purchaseheadercell"

class PurchasedVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var purchaseUid : Int!
    var purchasecollectionView : UICollectionView!
    var scrollView: UIScrollView!
    
    var purchasedtotalDatas : NSDictionary!
    var orderingproductDic : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        getData()
//        setup()
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
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIScreen.main.bounds.height/defaultHeight * 20
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
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
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
        scrollView.topAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight/defaultHeight * 1000)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        scrollView.addSubview(purchasecollectionView)
        scrollView.addSubview(userinfocontentView)
        scrollView.addSubview(totalpaymentcontentView)
        scrollView.addSubview(deliveryinfocontentView)
        
        purchasecollectionView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        purchasecollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        purchasecollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        purchasecollectionView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 250).isActive = true
        
        userinfocontentView.addSubview(lineLabel1)
        userinfocontentView.addSubview(userinfoLabel)
        userinfocontentView.addSubview(usernameLabel)
        userinfocontentView.addSubview(userphonenumLabel)
        userinfocontentView.addSubview(lineLabel2)
        
        userinfocontentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        userinfocontentView.topAnchor.constraint(equalTo: purchasecollectionView.bottomAnchor).isActive = true
        userinfocontentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        userinfocontentView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 158).isActive = true
        
        lineLabel1.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor).isActive = true
        lineLabel1.topAnchor.constraint(equalTo: userinfocontentView.topAnchor).isActive = true
        lineLabel1.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        lineLabel1.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true
        
        userinfoLabel.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        userinfoLabel.topAnchor.constraint(equalTo: userinfocontentView.topAnchor, constant: screenHeight/defaultHeight * 34).isActive = true
//        userinfoLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        userinfoLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 23).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: userinfoLabel.bottomAnchor, constant: screenHeight/defaultHeight * 19).isActive = true
//        usernameLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        userphonenumLabel.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        userphonenumLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: screenHeight/defaultHeight * 10).isActive = true
//        userphonenumLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        userphonenumLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        lineLabel2.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor).isActive = true
        lineLabel2.bottomAnchor.constraint(equalTo: userinfocontentView.bottomAnchor).isActive = true
        lineLabel2.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        lineLabel2.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true
        
        totalpaymentcontentView.addSubview(paymentInfoLabel)
        totalpaymentcontentView.addSubview(paymentmethodLabel)
        totalpaymentcontentView.addSubview(paymentmethodcardLabel)
        totalpaymentcontentView.addSubview(totalproductLabel)
        totalpaymentcontentView.addSubview(totalproductmoneyLabel)
        totalpaymentcontentView.addSubview(totaldeliveryLabel)
        totalpaymentcontentView.addSubview(totaldeliverymoneyLabel)
        totalpaymentcontentView.addSubview(lineLabel3)
        totalpaymentcontentView.addSubview(totalpaymentLabel)
        totalpaymentcontentView.addSubview(totalpaymentmoneyLabel)

        totalpaymentcontentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        totalpaymentcontentView.topAnchor.constraint(equalTo: userinfocontentView.bottomAnchor).isActive = true
        totalpaymentcontentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        totalpaymentcontentView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 232).isActive = true

        paymentInfoLabel.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        paymentInfoLabel.topAnchor.constraint(equalTo: totalpaymentcontentView.topAnchor, constant: screenHeight/defaultHeight * 34).isActive = true
//        paymentInfoLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        paymentInfoLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 23).isActive = true

        paymentmethodLabel.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        paymentmethodLabel.topAnchor.constraint(equalTo: paymentInfoLabel.bottomAnchor, constant: screenHeight/defaultHeight * 19).isActive = true
//        paymentmethodLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        paymentmethodLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        paymentmethodcardLabel.rightAnchor.constraint(equalTo: totalpaymentcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        paymentmethodcardLabel.topAnchor.constraint(equalTo: paymentInfoLabel.bottomAnchor, constant: screenHeight/defaultHeight * 19).isActive = true
//        paymentmethodcardLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        paymentmethodcardLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totalproductLabel.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        totalproductLabel.topAnchor.constraint(equalTo: paymentmethodLabel.bottomAnchor, constant: screenHeight/defaultHeight * 10).isActive = true
//        totalproductLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        totalproductLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totalproductmoneyLabel.rightAnchor.constraint(equalTo: totalpaymentcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        totalproductmoneyLabel.topAnchor.constraint(equalTo: paymentmethodcardLabel.bottomAnchor, constant: screenHeight/defaultHeight * 10).isActive = true
//        totalproductmoneyLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        totalproductmoneyLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totaldeliveryLabel.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        totaldeliveryLabel.topAnchor.constraint(equalTo: totalproductLabel.bottomAnchor, constant: screenHeight/defaultHeight * 10).isActive = true
//        totaldeliveryLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        totaldeliveryLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totaldeliverymoneyLabel.rightAnchor.constraint(equalTo: totalpaymentcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        totaldeliverymoneyLabel.topAnchor.constraint(equalTo: totalproductmoneyLabel.bottomAnchor, constant: screenHeight/defaultHeight * 10).isActive = true
//        totaldeliverymoneyLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        totaldeliverymoneyLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totalpaymentLabel.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        totalpaymentLabel.topAnchor.constraint(equalTo: totaldeliveryLabel.bottomAnchor, constant: screenHeight/defaultHeight * 24).isActive = true
//        totalpaymentLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        totalpaymentLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totalpaymentmoneyLabel.rightAnchor.constraint(equalTo: totalpaymentcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        totalpaymentmoneyLabel.topAnchor.constraint(equalTo: totaldeliverymoneyLabel.bottomAnchor, constant: screenHeight/defaultHeight * 24).isActive = true
//        totalpaymentmoneyLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        totalpaymentmoneyLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        lineLabel3.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        lineLabel3.topAnchor.constraint(equalTo: totalpaymentLabel.bottomAnchor, constant: screenHeight/defaultHeight * 32).isActive = true
        lineLabel3.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        lineLabel3.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true

        deliveryinfocontentView.addSubview(deliveryinfoLabel)
        deliveryinfocontentView.addSubview(deliveryusernameLabel)
        deliveryinfocontentView.addSubview(deliveryphonenumLabel)
        deliveryinfocontentView.addSubview(deliveryaddressLabel)

        deliveryinfocontentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        deliveryinfocontentView.topAnchor.constraint(equalTo: totalpaymentcontentView.bottomAnchor).isActive = true
        deliveryinfocontentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        deliveryinfocontentView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 206).isActive = true

        deliveryinfoLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryinfoLabel.topAnchor.constraint(equalTo: deliveryinfocontentView.topAnchor, constant: screenHeight/defaultHeight * 34).isActive = true
//        deliveryinfoLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        deliveryinfoLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 23).isActive = true

        deliveryusernameLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryusernameLabel.topAnchor.constraint(equalTo: deliveryinfoLabel.bottomAnchor, constant: screenHeight/defaultHeight * 19).isActive = true
        deliveryusernameLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 200).isActive = true
        deliveryusernameLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        deliveryphonenumLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryphonenumLabel.topAnchor.constraint(equalTo: deliveryusernameLabel.bottomAnchor, constant: screenHeight/defaultHeight * 10).isActive = true
        deliveryphonenumLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 200).isActive = true
        deliveryphonenumLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        deliveryaddressLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryaddressLabel.topAnchor.constraint(equalTo: deliveryphonenumLabel.bottomAnchor, constant: screenHeight/defaultHeight * 10).isActive = true
        deliveryaddressLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 162).isActive = true
//        deliveryaddressLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 40).isActive = true
        
        self.setinfo()
    }
    
    func setinfo() {
        let userinfoDic = self.purchasedtotalDatas.object(forKey: "user_info") as! NSDictionary
        let nickname = userinfoDic.object(forKey: "nickname") as! String
        let phone = userinfoDic.object(forKey: "phone") as! String
        usernameLabel.text = nickname
        userphonenumLabel.text = phone
        
        let payinfoDic = self.purchasedtotalDatas.object(forKey: "pay_info") as! NSDictionary
        let price = payinfoDic.object(forKey: "price") as! Int
        let delivery_charge = payinfoDic.object(forKey: "delivery_charge") as! Int
        let total = payinfoDic.object(forKey: "total") as! Int
        totalproductmoneyLabel.text = String(price) + "원"
        totaldeliverymoneyLabel.text = String(delivery_charge) + "원"
        totalpaymentmoneyLabel.text = String(total) + "원"
        
        let addressDic = self.purchasedtotalDatas.object(forKey: "address") as! NSDictionary
        let addressname = addressDic.object(forKey: "name") as! String
        let addressphone = addressDic.object(forKey: "phone") as! String
        let address = addressDic.object(forKey: "Addr") as! String
        deliveryusernameLabel.text = addressname
        deliveryphonenumLabel.text = addressphone
        deliveryaddressLabel.text = address
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/purchased/" + String(purchaseUid) + "/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                self.purchasedtotalDatas = response
                if let ordering = self.purchasedtotalDatas.object(forKey: "ordering_product") as? NSDictionary {
                    self.orderingproductDic = ordering
                }
                self.setup()
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    @objc func rating() {
        // View controller the bottom sheet will hold
        let viewController: UIViewController = RatingBottomSheetVC()
        
        // Initialize the bottom sheet with the view controller just created
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        bottomSheet.dismissOnDraggingDownSheet = true
        bottomSheet.dismissOnBackgroundTap = true
        bottomSheet.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 277)
        // Present the bottom sheet
        present(bottomSheet, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let productArray = self.orderingproductDic.object(forKey: "products") as! Array<NSDictionary>
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PurchasedMainCell
        let productArray = self.orderingproductDic.object(forKey: "products") as! Array<NSDictionary>
        let productInfoDic = productArray[indexPath.row]
        let productDic = productInfoDic.object(forKey: "product") as! NSDictionary
        let productName = productDic.object(forKey: "name") as! String
        let productPrice = productDic.object(forKey: "discounted_price") as! Int
        let productSize = productDic.object(forKey: "size") as! String
        let productImgDic = productDic.object(forKey: "thumbnails") as! NSDictionary
        let imageUrlString = productImgDic.object(forKey: "thumbnail") as! String
        let imageUrl:NSURL = NSURL(string: imageUrlString)!
        let imageData:NSData = NSData(contentsOf: imageUrl as URL)!

        DispatchQueue.main.async {
            let image = UIImage(data: imageData as Data)
            cell.productImage.image = image
            cell.productNameLabel.text = productName
            cell.productPriceLabel.text = String(productPrice) + "원"
            cell.productSizeLabel.text = productSize
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PurchasedMainHeaderCell
                let orderingproductDic = self.purchasedtotalDatas.object(forKey: "ordering_product") as! NSDictionary
                let condition = self.purchasedtotalDatas.object(forKey: "condition") as! Int
                let sellerInfoDic = orderingproductDic.object(forKey: "seller") as! NSDictionary
                let sellerName = sellerInfoDic.object(forKey: "nickname") as! String
                let sellerprofileDic = sellerInfoDic.object(forKey: "profile") as! NSDictionary
                let imageUrlString = sellerprofileDic.object(forKey: "thumbnail_img") as! String
                let imageUrl:NSURL = NSURL(string: imageUrlString)!
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!

                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    headerView.sellerProfileImg.image = image
                    headerView.sellerProfileImg.layer.cornerRadius = headerView.sellerProfileImg.frame.height / 2
                    headerView.sellerProfileImg.layer.borderColor = UIColor.clear.cgColor
                    headerView.sellerProfileImg.layer.borderWidth = 1
                    headerView.sellerProfileImg.layer.masksToBounds = false
                    headerView.sellerProfileImg.clipsToBounds = true
                    headerView.sellerNameLabel.text = sellerName
                    if condition == 0 {
                        headerView.btnConfirm.isHidden = false
                        headerView.btnConfirm.addTarget(self, action: #selector(self.rating), for: .touchUpInside)
                        headerView.btnReview.isHidden = true
                    }
                    else if condition == 1 {
                        headerView.btnConfirm.isHidden = true
                        headerView.btnReview.isHidden = false
                    }
                    else {
                        headerView.btnConfirm.isHidden = true
                        headerView.btnReview.isHidden = true
                    }
                }
                
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
    
    let lineLabel1 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let userinfocontentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userinfoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "주문자 정보"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let userphonenumLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let lineLabel2 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let totalpaymentcontentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let paymentInfoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "결제정보"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let paymentmethodLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "결제 방법"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let paymentmethodcardLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let totalproductLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "총 상품금액"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let totalproductmoneyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let totaldeliveryLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "총 배송비"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let totaldeliverymoneyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let totalpaymentLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "총 결제금액"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let totalpaymentmoneyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()

    let lineLabel3 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let deliveryinfocontentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let deliveryinfoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "배송지 정보"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let deliveryusernameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    let deliveryphonenumLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    let deliveryaddressLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.textColor = .black
        label.backgroundColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
}



