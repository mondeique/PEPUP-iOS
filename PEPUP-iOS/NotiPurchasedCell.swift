//
//  NotiPurchasedCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/19.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialBottomSheet
import Cosmos

class NotiPurchasedCell: BaseCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let notipurchasecellId = "notipurchasecell"
    private let notipurhcaseheaderId = "notipurchaseheadercell"
    
    weak var delegate: NotiVC?
    
    var productDatas = Array<NSDictionary>()
    
    let purchasedcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 96)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 63)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isHidden = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(purchasedcollectionView)

        purchasedcollectionView.delegate = self
        purchasedcollectionView.dataSource = self
        purchasedcollectionView.register(PurchasedCell.self, forCellWithReuseIdentifier: notipurchasecellId)
        purchasedcollectionView.register(PurchasedHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: notipurhcaseheaderId)
        
        purchasedcollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        purchasedcollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        purchasedcollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        purchasedcollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        getPurchasedData()
    }
    
    func getPurchasedData() {
        Alamofire.AF.request("\(Config.baseURL)/api/purchased/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                for i in 0..<response.count {
                    self.productDatas.append(response[i])
                }
                print(response)
                DispatchQueue.main.async {
                    self.purchasedcollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    @objc func rating(_ sender: UIButton) {
        // View controller the bottom sheet will hold
        let nextVC = RatingBottomSheetVC()
        nextVC.MyId = sender.tag
        // Initialize the bottom sheet with the view controller just created
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: nextVC)
        bottomSheet.dismissOnDraggingDownSheet = true
        bottomSheet.dismissOnBackgroundTap = true
        bottomSheet.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 277)
        // Present the bottom sheet
        delegate?.navigationController?.present(bottomSheet, animated: true, completion: nil)
    }
    
    @objc func review(_ sender: UIButton) {
        let nextVC = ReviewVC()
        UserDefaults.standard.set(sender.tag, forKey: "purchaseUid")
        delegate?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let resultDic = productDatas[section]
        let resultArray = resultDic.object(forKey: "result") as! Array<NSDictionary>
        return resultArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notipurchasecellId, for: indexPath) as! PurchasedCell
        let resultDic = self.productDatas[indexPath.section]
        let resultArray = resultDic.object(forKey: "result") as! Array<NSDictionary>
        let itemDic = resultArray[indexPath.row]
        let status = itemDic.object(forKey: "status") as! String
        let name = itemDic.object(forKey: "name") as! String
        let total = itemDic.object(forKey: "total") as! Int
        let imageUrlString = itemDic.object(forKey: "thumbnail") as! String
        let imageUrl:NSURL = NSURL(string: imageUrlString)!
        let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
        let condition = itemDic.object(forKey: "condition") as! Int
        let id = itemDic.object(forKey: "id") as! Int

        DispatchQueue.main.async {
            let image = UIImage(data: imageData as Data)
            cell.productImg.image = image
            cell.statusLabel.text = status
            cell.productNameLabel.text = name
            cell.productPriceLabel.text = String(total) + "원"
            if condition == 0 {
                cell.btnConfirm.isHidden = false
                cell.btnConfirm.addTarget(self, action: #selector(self.rating(_:)), for: .touchUpInside)
                cell.btnConfirm.tag = id
                cell.btnReview.isHidden = true
            }
            else if condition == 1 {
                cell.btnConfirm.isHidden = true
                cell.btnReview.isHidden = false
                cell.btnReview.tag = id
                cell.btnReview.addTarget(self, action: #selector(self.review(_:)), for: .touchUpInside)
            }
            else {
                cell.btnConfirm.isHidden = true
                cell.btnReview.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: notipurhcaseheaderId, for: indexPath) as! PurchasedHeaderCell
                let resultDic = self.productDatas[indexPath.section]
                let date = resultDic.object(forKey: "date") as! String
                headerView.dateLabel.text = date
                return headerView

            default:
                assert(false, "Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultDic = self.productDatas[indexPath.section]
        let resultArray = resultDic.object(forKey: "result") as! Array<NSDictionary>
        let itemDic = resultArray[indexPath.row]
        let id = itemDic.object(forKey: "id") as! Int
        let nextVC = PurchasedVC()
        nextVC.purchaseUid = id
        delegate?.navigationController?.pushViewController(nextVC, animated: true)
    }

}

class PurchasedCell: BaseCollectionViewCell {

    let noticellcontentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 96))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let productImg: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        return label
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        return label
    }()
    
    let btnConfirm: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.red, for: .normal)
        btn.setTitle("수령 확인", for: .normal)
        btn.layer.borderColor = UIColor.red.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        return btn
    }()
    
    let btnReview: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("리뷰 작성", for: .normal)
        btn.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        return btn
    }()

    override func setup() {
        backgroundColor = .white
        noticellcontentView.addSubview(productImg)
        noticellcontentView.addSubview(statusLabel)
        noticellcontentView.addSubview(productNameLabel)
        noticellcontentView.addSubview(productPriceLabel)
        noticellcontentView.addSubview(btnReview)
        noticellcontentView.addSubview(btnConfirm)
        
        self.addSubview(noticellcontentView)

        noticellcontentViewLayout()
        productImgLayout()
        statusLabelLayout()
        productNameLabelLayout()
        productPriceLabelLayout()
        btnReviewLayout()
        btnConfirmLayout()
        
    }

    func noticellcontentViewLayout() {
        noticellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        noticellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        noticellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        noticellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productImgLayout() {
        productImg.leftAnchor.constraint(equalTo:noticellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        productImg.topAnchor.constraint(equalTo:noticellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 12).isActive = true
        productImg.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 72).isActive = true
        productImg.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 72).isActive = true
    }

    func statusLabelLayout() {
        statusLabel.leftAnchor.constraint(equalTo:productImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        statusLabel.topAnchor.constraint(equalTo:noticellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 11).isActive = true
//        statusLabel.widthAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true
    }
    
    func productNameLabelLayout() {
        productNameLabel.leftAnchor.constraint(equalTo:productImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        productNameLabel.topAnchor.constraint(equalTo:statusLabel.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 12).isActive = true
//        productNameLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 72).isActive = true
        productNameLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true
    }
    
    func productPriceLabelLayout() {
        productPriceLabel.leftAnchor.constraint(equalTo:productImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        productPriceLabel.topAnchor.constraint(equalTo:productNameLabel.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
//        productPriceLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 72).isActive = true
        productPriceLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true
    }
    
    func btnReviewLayout() {
        btnReview.rightAnchor.constraint(equalTo:noticellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        btnReview.topAnchor.constraint(equalTo:noticellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 11).isActive = true
        btnReview.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 96).isActive = true
        btnReview.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 32).isActive = true
    }
    
    func btnConfirmLayout() {
        btnConfirm.rightAnchor.constraint(equalTo:noticellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        btnConfirm.topAnchor.constraint(equalTo:noticellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 11).isActive = true
        btnConfirm.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 96).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 32).isActive = true
    }
}

class PurchasedHeaderCell: BaseCollectionViewCell {

    let notiheaderontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        return label
    }()

    override func setup() {
        backgroundColor = .white
        notiheaderontentView.addSubview(dateLabel)
        self.addSubview(notiheaderontentView)

        notiheaderontentViewLayout()
        dateLabelLayout()
    }

    func notiheaderontentViewLayout() {
        notiheaderontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        notiheaderontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        notiheaderontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        notiheaderontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func dateLabelLayout() {
        dateLabel.leftAnchor.constraint(equalTo:notiheaderontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        dateLabel.topAnchor.constraint(equalTo:notiheaderontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 32).isActive = true
//        dateLabel.widthAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 23).isActive = true
    }
}

class RatingBottomSheetVC : UIViewController {
    
    var MyId : Int!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
//        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
//        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        self.view.addSubview(text1)
        self.view.addSubview(text2)
        self.view.addSubview(cosmosView)
        self.view.addSubview(btnReview)
        self.view.addSubview(btnRating)
        
        text1.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * 40).isActive = true
        text1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 30).isActive = true
        text1.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 250).isActive = true
        text1.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        text2.topAnchor.constraint(equalTo: text1.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        text2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 30).isActive = true
        text2.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 277).isActive = true
        text2.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 25).isActive = true
        
        cosmosView.topAnchor.constraint(equalTo: text2.bottomAnchor, constant: screenHeight/defaultHeight * 30).isActive = true
        cosmosView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 80).isActive = true
        cosmosView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 277).isActive = true
        cosmosView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 40).isActive = true
        cosmosView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        btnReview.topAnchor.constraint(equalTo: text2.bottomAnchor, constant: screenHeight/defaultHeight * 120).isActive = true
        btnReview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 30).isActive = true
        btnReview.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 152).isActive = true
        btnReview.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 48).isActive = true
        
        btnRating.topAnchor.constraint(equalTo: text2.bottomAnchor, constant: screenHeight/defaultHeight * 120).isActive = true
        btnRating.rightAnchor.constraint(equalTo: view.rightAnchor, constant: screenWidth/defaultWidth * -31).isActive = true
        btnRating.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 152).isActive = true
        btnRating.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 48).isActive = true
        
    }
    
    @objc func review() {
        print("REVIEW")
    }
    
    @objc func rating() {
        let rate = cosmosView.rating
        let paramters = [
            "satisfaction" : Float(rate)
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/purchased/leave_review/" + String(MyId) + "/", method: .post, parameters: paramters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print(JSON)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        print("RATING")
    }
    
    let text1 : UILabel = {
        let label = UILabel()
        label.text = "구매하신 상품은 어떠셨나요?"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .black
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let text2 : UILabel = {
        let label = UILabel()
        label.text = "스토어에 대한 별점을 남겨주세요!"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 21)
        label.textColor = .black
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cosmosView : CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = StarFillMode(rawValue: 1)!
        view.settings.updateOnTouch = true
        view.settings.starSize = 40
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnReview : UIButton = {
        let btn = UIButton()
        btn.setTitle("리뷰 쓰기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 3
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.5
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(review), for: .touchUpInside)
        return btn
    }()
    
    let btnRating : UIButton = {
        let btn = UIButton()
        btn.setTitle("별점 남기기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 3
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(rating), for: .touchUpInside)
        return btn
    }()
}

