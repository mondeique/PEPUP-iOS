//
//  NotiPurchasedCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/19.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class NotiPurchasedCell: BaseCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let notipurchasecellId = "notipurchasecell"
    private let notipurhcaseheaderId = "notipurchaseheadercell"
    
    
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

        DispatchQueue.main.async {
            let image = UIImage(data: imageData as Data)
            cell.productImg.image = image
            cell.statusLabel.text = status
            cell.productNameLabel.text = name
            cell.productPriceLabel.text = String(total) + "원"
            if condition == 0 {
                cell.btnConfirm.isHidden = false
                cell.btnReview.isHidden = true
            }
            else if condition == 1 {
                cell.btnConfirm.isHidden = true
                cell.btnReview.isHidden = false
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
        print(id)
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
