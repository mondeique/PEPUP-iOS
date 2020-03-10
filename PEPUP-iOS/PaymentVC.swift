//
//  PaymentVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/05.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "paymentcell"
private let headerId = "paymentheadercell"
private let footerId = "paymentfootercell"

class PaymentVC: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate{
    
    var paymentcollectionView : UICollectionView!
    var scrollView: UIScrollView!
    var trades : Array<Int>!
    
    var ordertotalDatas : NSDictionary!
    var orderproductDic = Array<NSDictionary>()
    
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
        self.view.backgroundColor = .white
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
        
        let paymentLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "P A Y M E N T"
            label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        
        navcontentView.addSubview(btnClose)
        navcontentView.addSubview(paymentLabel)
        
        self.view.addSubview(navcontentView)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnClose.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnClose.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnClose.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        paymentLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        paymentLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/defaultWidth * 375, height: screenWidth/defaultWidth * 80)
        layout.scrollDirection = .vertical
        
        paymentcollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: layout)
        paymentcollectionView.delegate = self
        paymentcollectionView.dataSource = self
        paymentcollectionView.register(PaymentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        paymentcollectionView.register(PaymentHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        paymentcollectionView.register(PaymentFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        paymentcollectionView.backgroundColor = UIColor.white
        paymentcollectionView.translatesAutoresizingMaskIntoConstraints = false
        paymentcollectionView.isHidden = true
        
        scrollView = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: navBarHeight + statusBarHeight), size: CGSize(width: screenWidth, height: screenHeight-screenHeight/defaultHeight * 106)))
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
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (screenHeight/defaultHeight) * -106.0).isActive = true
        
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight/defaultHeight * 1300)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        let contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            return view
        }()
        
        let btnPayment: UIButton = {
            let btn = UIButton()
            btn.setTitle("결제하기", for: .normal)
            btn.backgroundColor = .black
            btn.setTitleColor(.white, for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.clipsToBounds = true
            btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
            btn.addTarget(self, action: #selector(payment), for: .touchUpInside)
            btn.isHidden = false
            return btn
        }()
        
        self.view.addSubview(contentView)
        
        contentView.addSubview(btnPayment)
        
        contentView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: screenHeight/defaultHeight * -106).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        btnPayment.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnPayment.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        btnPayment.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 56).isActive = true
        btnPayment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: screenHeight/defaultHeight * 18).isActive = true
        btnPayment.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        scrollView.addSubview(orderproductcontentView)
        scrollView.addSubview(paymentcollectionView)
        scrollView.addSubview(userinfocontentView)
        scrollView.addSubview(deliveryinfocontentView)
        scrollView.addSubview(totalpaymentcontentView)
        scrollView.addSubview(paymentagreecontentView)
        
        orderproductcontentView.addSubview(orderproductLabel)
        orderproductcontentView.addSubview(btnCell)
        
        
        orderproductcontentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        orderproductcontentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        orderproductcontentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        orderproductcontentView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 56).isActive = true
        
        orderproductLabel.leftAnchor.constraint(equalTo: orderproductcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        orderproductLabel.topAnchor.constraint(equalTo: orderproductcontentView.topAnchor, constant: screenHeight/defaultHeight * 20).isActive = true
//        orderproductLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        orderproductLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 23).isActive = true
        
        btnCell.rightAnchor.constraint(equalTo: orderproductcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        btnCell.topAnchor.constraint(equalTo: orderproductcontentView.topAnchor, constant: screenHeight/defaultHeight * 24).isActive = true
        btnCell.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        btnCell.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 10).isActive = true
        
        paymentcollectionView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        paymentcollectionView.topAnchor.constraint(equalTo: orderproductcontentView.bottomAnchor).isActive = true
        paymentcollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        paymentcollectionView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 250).isActive = true
        
        if btnCell.tag == 0 {
            paymentcollectionView.isHidden = true
        }
        else if btnCell.tag == 1 {
            paymentcollectionView.isHidden = false
        }
        
        userinfocontentView.addSubview(spaceLabel1)
        userinfocontentView.addSubview(userinfoLabel)
        userinfocontentView.addSubview(usernameLabel)
        userinfocontentView.addSubview(userphonenumLabel)
        userinfocontentView.addSubview(spaceLabel2)
        
        if btnCell.tag == 0 {
            userinfocontentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
            userinfocontentView.topAnchor.constraint(equalTo: orderproductcontentView.bottomAnchor).isActive = true
            userinfocontentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            userinfocontentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 160).isActive = true
        }
        else if btnCell.tag == 1 {
            userinfocontentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
            userinfocontentView.topAnchor.constraint(equalTo: paymentcollectionView.bottomAnchor).isActive = true
            userinfocontentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            userinfocontentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 160).isActive = true
        }
        
        spaceLabel1.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor).isActive = true
        spaceLabel1.topAnchor.constraint(equalTo: userinfocontentView.topAnchor).isActive = true
        spaceLabel1.widthAnchor.constraint(equalTo: userinfocontentView.widthAnchor).isActive = true
        spaceLabel1.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 8).isActive = true
        
        userinfoLabel.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        userinfoLabel.topAnchor.constraint(equalTo: spaceLabel1.bottomAnchor, constant: screenHeight/defaultHeight * 17).isActive = true
//        userinfoLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        userinfoLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 23).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: userinfoLabel.bottomAnchor, constant: screenHeight/defaultHeight * 32).isActive = true
//        usernameLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        userphonenumLabel.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        userphonenumLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: screenHeight/defaultHeight * 16).isActive = true
//        userphonenumLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        userphonenumLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        spaceLabel2.leftAnchor.constraint(equalTo: userinfocontentView.leftAnchor).isActive = true
        spaceLabel2.bottomAnchor.constraint(equalTo: userinfocontentView.bottomAnchor).isActive = true
        spaceLabel2.widthAnchor.constraint(equalTo: userinfocontentView.widthAnchor).isActive = true
        spaceLabel2.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 8).isActive = true
        
        deliveryinfocontentView.addSubview(deliveryinfoLabel)
        deliveryinfocontentView.addSubview(deliveryusernameLabel)
        deliveryinfocontentView.addSubview(deliveryphonenumLabel)
        deliveryinfocontentView.addSubview(deliveryaddressLabel)
        deliveryinfocontentView.addSubview(lineLabel1)
        deliveryinfocontentView.addSubview(mountainLabel)
        deliveryinfocontentView.addSubview(btnMountain)
        deliveryinfocontentView.addSubview(lineLabel2)
        deliveryinfocontentView.addSubview(deliverymemoLabel)
        deliveryinfocontentView.addSubview(btnMemo)
        deliveryinfocontentView.addSubview(memoTextView)
        deliveryinfocontentView.addSubview(memocountLabel)
        deliveryinfocontentView.addSubview(spaceLabel3)

        deliveryinfocontentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        deliveryinfocontentView.topAnchor.constraint(equalTo: userinfocontentView.bottomAnchor).isActive = true
        deliveryinfocontentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        deliveryinfocontentView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * (56 + 152 + 62 + 221 + 8)).isActive = true

        deliveryinfoLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryinfoLabel.topAnchor.constraint(equalTo: deliveryinfocontentView.topAnchor, constant: screenHeight/defaultHeight * 17).isActive = true
//        deliveryinfoLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        deliveryinfoLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 23).isActive = true

        deliveryusernameLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryusernameLabel.topAnchor.constraint(equalTo: deliveryinfoLabel.bottomAnchor, constant: screenHeight/defaultHeight * 32).isActive = true
        deliveryusernameLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 200).isActive = true
        deliveryusernameLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        deliveryphonenumLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryphonenumLabel.topAnchor.constraint(equalTo: deliveryusernameLabel.bottomAnchor, constant: screenHeight/defaultHeight * 16).isActive = true
        deliveryphonenumLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 200).isActive = true
        deliveryphonenumLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        deliveryaddressLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryaddressLabel.topAnchor.constraint(equalTo: deliveryphonenumLabel.bottomAnchor, constant: screenHeight/defaultHeight * 16).isActive = true
        deliveryaddressLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 300).isActive = true
        deliveryaddressLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 40).isActive = true

        lineLabel1.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        lineLabel1.topAnchor.constraint(equalTo: deliveryaddressLabel.bottomAnchor, constant: screenHeight/defaultHeight * 24).isActive = true
        lineLabel1.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        lineLabel1.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true
        
        mountainLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        mountainLabel.topAnchor.constraint(equalTo: lineLabel1.bottomAnchor, constant: screenHeight/defaultHeight * 23).isActive = true
//        mountainLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        mountainLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        btnMountain.rightAnchor.constraint(equalTo: deliveryinfocontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        btnMountain.topAnchor.constraint(equalTo: lineLabel1.bottomAnchor, constant: screenHeight/defaultHeight * 14.5).isActive = true
        btnMountain.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 51).isActive = true
        btnMountain.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 31).isActive = true

        lineLabel2.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        lineLabel2.topAnchor.constraint(equalTo: mountainLabel.bottomAnchor, constant: screenHeight/defaultHeight * 18).isActive = true
        lineLabel2.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        lineLabel2.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true

        deliverymemoLabel.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliverymemoLabel.topAnchor.constraint(equalTo: lineLabel2.bottomAnchor, constant: screenHeight/defaultHeight * 28).isActive = true
//        deliverymemoLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        deliverymemoLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        btnMemo.leftAnchor.constraint(equalTo: deliverymemoLabel.rightAnchor, constant: screenWidth/defaultWidth * 16).isActive = true
        btnMemo.topAnchor.constraint(equalTo: lineLabel2.bottomAnchor, constant: screenHeight/defaultHeight * 16).isActive = true
        btnMemo.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 263).isActive = true
        btnMemo.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true

        memoTextView.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        memoTextView.topAnchor.constraint(equalTo: deliverymemoLabel.bottomAnchor, constant: screenHeight/defaultHeight * 27).isActive = true
        memoTextView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        memoTextView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 112).isActive = true
        
        memoTextView.delegate = self

        memocountLabel.rightAnchor.constraint(equalTo: deliveryinfocontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        memocountLabel.topAnchor.constraint(equalTo: memoTextView.bottomAnchor, constant: screenHeight/defaultHeight * 5).isActive = true
//        memocountLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        memocountLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        spaceLabel3.leftAnchor.constraint(equalTo: deliveryinfocontentView.leftAnchor).isActive = true
        spaceLabel3.bottomAnchor.constraint(equalTo: deliveryinfocontentView.bottomAnchor).isActive = true
        spaceLabel3.widthAnchor.constraint(equalTo: deliveryinfocontentView.widthAnchor).isActive = true
        spaceLabel3.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 8).isActive = true

        totalpaymentcontentView.addSubview(paymentMoneyLabel)
        totalpaymentcontentView.addSubview(totalproductLabel)
        totalpaymentcontentView.addSubview(totalproductmoneyLabel)
        totalpaymentcontentView.addSubview(totaldeliveryLabel)
        totalpaymentcontentView.addSubview(totaldeliverymoneyLabel)
        totalpaymentcontentView.addSubview(lineLabel3)
        totalpaymentcontentView.addSubview(totalpaymentLabel)
        totalpaymentcontentView.addSubview(totalpaymentmoneyLabel)
        totalpaymentcontentView.addSubview(spaceLabel4)
        
        totalpaymentcontentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        totalpaymentcontentView.topAnchor.constraint(equalTo: deliveryinfocontentView.bottomAnchor).isActive = true
        totalpaymentcontentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        totalpaymentcontentView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * (56 + 80 + 56 + 8)).isActive = true

        paymentMoneyLabel.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        paymentMoneyLabel.topAnchor.constraint(equalTo: totalpaymentcontentView.topAnchor, constant: screenHeight/defaultHeight * 17).isActive = true
//        paymentMoneyLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        paymentMoneyLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 23).isActive = true

        totalproductLabel.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        totalproductLabel.topAnchor.constraint(equalTo: paymentMoneyLabel.bottomAnchor, constant: screenHeight/defaultHeight * 32).isActive = true
//        totalproductLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        totalproductLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totalproductmoneyLabel.rightAnchor.constraint(equalTo: totalpaymentcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        totalproductmoneyLabel.topAnchor.constraint(equalTo: paymentMoneyLabel.bottomAnchor, constant: screenHeight/defaultHeight * 32).isActive = true
//        totalproductmoneyLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        totalproductmoneyLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totaldeliveryLabel.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        totaldeliveryLabel.topAnchor.constraint(equalTo: totalproductLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
//        totaldeliveryLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        totaldeliveryLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totaldeliverymoneyLabel.rightAnchor.constraint(equalTo: totalpaymentcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        totaldeliverymoneyLabel.topAnchor.constraint(equalTo: totalproductmoneyLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
//        totaldeliverymoneyLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        totaldeliverymoneyLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        lineLabel3.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        lineLabel3.topAnchor.constraint(equalTo: totaldeliverymoneyLabel.bottomAnchor, constant: screenHeight/defaultHeight * 16).isActive = true
        lineLabel3.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        lineLabel3.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true

        totalpaymentLabel.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        totalpaymentLabel.topAnchor.constraint(equalTo: lineLabel3.bottomAnchor, constant: screenHeight/defaultHeight * 18).isActive = true
//        totalpaymentLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        totalpaymentLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        totalpaymentmoneyLabel.rightAnchor.constraint(equalTo: totalpaymentcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        totalpaymentmoneyLabel.topAnchor.constraint(equalTo: lineLabel3.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
//        totalpaymentmoneyLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        totalpaymentmoneyLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true

        spaceLabel4.leftAnchor.constraint(equalTo: totalpaymentcontentView.leftAnchor).isActive = true
        spaceLabel4.bottomAnchor.constraint(equalTo: totalpaymentcontentView.bottomAnchor).isActive = true
        spaceLabel4.widthAnchor.constraint(equalTo: totalpaymentcontentView.widthAnchor).isActive = true
        spaceLabel4.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 8).isActive = true

        paymentagreecontentView.addSubview(btnAgree)
        paymentagreecontentView.addSubview(paymentagreeLabel)
        paymentagreecontentView.addSubview(btnPaymentAgree)
//        paymentagreecontentView.addSubview(paymentagreeTextLabel)
        
        paymentagreecontentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        paymentagreecontentView.topAnchor.constraint(equalTo: totalpaymentcontentView.bottomAnchor).isActive = true
        paymentagreecontentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        paymentagreecontentView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 56).isActive = true

        btnAgree.leftAnchor.constraint(equalTo: paymentagreecontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnAgree.topAnchor.constraint(equalTo: paymentagreecontentView.topAnchor, constant: screenHeight/defaultHeight * 28).isActive = true
        btnAgree.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 26).isActive = true
        btnAgree.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 26).isActive = true

        paymentagreeLabel.leftAnchor.constraint(equalTo: btnAgree.rightAnchor, constant: screenWidth/defaultWidth * 10).isActive = true
//        paymentagreeLabel.topAnchor.constraint(equalTo: paymentagreecontentView.topAnchor, constant: screenHeight/defaultHeight * 23).isActive = true
//        paymentagreeLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        paymentagreeLabel.centerYAnchor.constraint(equalTo: btnAgree.centerYAnchor).isActive = true
        paymentagreeLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 19).isActive = true

        btnPaymentAgree.rightAnchor.constraint(equalTo: paymentagreecontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        btnPaymentAgree.topAnchor.constraint(equalTo: paymentagreecontentView.topAnchor, constant: screenHeight/defaultHeight * 28).isActive = true
        btnPaymentAgree.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 22).isActive = true
        btnPaymentAgree.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 10).isActive = true
        
    }
    
    func setinfo() {
        if let user_info = ordertotalDatas.object(forKey: "user_info") as? NSDictionary {
            let nickname = user_info.object(forKey: "nickname") as! String
            let phonenum = user_info.object(forKey: "phone") as! String
            usernameLabel.text = nickname
            userphonenumLabel.text = phonenum
        }
        if let price = ordertotalDatas.object(forKey: "price") as? NSDictionary {
            let total_price = price.object(forKey: "total_price") as! Int
            let total_delivery_charge = price.object(forKey: "total_delivery_charge") as! Int
            totalproductmoneyLabel.text = String(total_price)
            totaldeliverymoneyLabel.text = String(total_delivery_charge)
            totalpaymentmoneyLabel.text = String(total_price + total_delivery_charge)
        }
    }
    
    func getData() {
        let parameters = [
            "trades" : trades
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/trades/payform/" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                self.ordertotalDatas = response as NSDictionary
                if let orderDatas = response.object(forKey: "ordering_product") as? Array<NSDictionary> {
                    for i in 0..<orderDatas.count {
                        self.orderproductDic.append(orderDatas[i])
                    }
                }

                self.setinfo()
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return orderproductDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sellerDic = self.orderproductDic[section] as NSDictionary
        let productArray = sellerDic.object(forKey: "products") as! Array<Dictionary<String, Any>>
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PaymentCell
        let sellerDictionary = self.orderproductDic[indexPath.section] as NSDictionary
        let totalproductDatas = sellerDictionary.object(forKey: "products") as! Array<NSDictionary>
        if let productInfoDic = totalproductDatas[indexPath.row].object(forKey: "product") as? NSDictionary {
            let productName = productInfoDic.object(forKey: "name") as! String
            let productPrice = productInfoDic.object(forKey: "discounted_price") as! Int
            let productSize = productInfoDic.object(forKey: "size") as! String
            let productImgDic = productInfoDic.object(forKey: "thumbnails") as! NSDictionary
            let imageUrlString = productImgDic.object(forKey: "thumbnail") as! String
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                cell.productImage.setImage(image, for: .normal)
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

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PaymentHeaderCell
                let DataDic = orderproductDic[indexPath.section] as NSDictionary
                let sellerInfoDic = DataDic.object(forKey: "seller") as! NSDictionary
                let sellerName = sellerInfoDic.object(forKey: "nickname") as! String
                let sellerprofileDic = sellerInfoDic.object(forKey: "profile") as! NSDictionary
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
                }
                
                return headerView
            
        case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! PaymentFooterCell
//                let sellerDictionary = self.sellerDatas[indexPath.section] as NSDictionary
//                let delivery_charge = payinfoDic.object(forKey: "delivery_charge") as! Int
//                DispatchQueue.main.async {
//                    footerView.productdeliveryInfoLabel.text = String(delivery_charge) + "원"
//                }
                return footerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 100)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 62)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
     
        return changedText.count <= 50
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        memocountLabel.text = String(count) + "/50"
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func payment() {
        print("TOUCH PAYMENT")
    }
    
    @objc func cellopen(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
        }
        else if sender.tag == 1 {
            sender.tag = 0
        }
        setup()
    }
    
    @objc func switchonoff() {
        print("SWITCH ON!!")
    }
    
    @objc func checkbox() {
        if btnAgree.currentImage == UIImage(named: "un_checkbox") {
            btnAgree.setImage(UIImage(named: "checkbox"), for: .normal)
        }
        else if btnAgree.currentImage == UIImage(named: "checkbox") {
            btnAgree.setImage(UIImage(named: "un_checkbox"), for: .normal)
        }
    }
    
    @objc func paymentagreeopen(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
        }
        else if sender.tag == 1 {
            sender.tag = 0
        }
        setup()
    }
    
    let orderproductcontentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let orderproductLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "주문 상품"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let btnCell : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "disclosure_indicator"), for: .normal)
        btn.tag = 0
        btn.addTarget(self, action: #selector(cellopen(_:)), for: .touchUpInside)
        return btn
    }()
    
    let spaceLabel1 : UILabel = {
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
    
    let spaceLabel2 : UILabel = {
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
    
    let deliveryusernameLabel : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.isEditable = true
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.textColor = .black
        return txtView
    }()
    
    let deliveryphonenumLabel : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.isEditable = true
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.textColor = .black
        return txtView
    }()
    
    let deliveryaddressLabel : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.isEditable = true
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.textColor = .black
        return txtView
    }()
    
    let lineLabel1 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let mountainLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "도서산간지역"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let btnMountain : UISwitch = {
        let btn = UISwitch()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isOn = false
        btn.addTarget(self, action: #selector(switchonoff), for: .touchUpInside)
        return btn
    }()
    
    let lineLabel2 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let deliverymemoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "배송메모"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let btnMemo : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("MEMODLALSDKALDKJ", for: .normal)
        btn.backgroundColor = .red
        return btn
    }()
    
    let memoTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 3
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        return textView
    }()
    
    let memocountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let spaceLabel3 : UILabel = {
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
    
    let paymentMoneyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "결제 금액"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
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
    
    let lineLabel3 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
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
    
    let spaceLabel4 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let paymentagreecontentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnAgree : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "un_checkbox"), for: .normal)
        btn.addTarget(self, action: #selector(checkbox), for: .touchUpInside)
        return btn
    }()
    
    let paymentagreeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "결제동의하기"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    let btnPaymentAgree : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "disclosure_indicator"), for: .normal)
        btn.addTarget(self, action: #selector(paymentagreeopen), for: .touchUpInside)
        btn.tag = 0
        return btn
    }()
    
    let paymentagreeTextLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

}
