//
//  NotiActivityCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/19.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class NotiActivityCell: BaseCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let notiactivitycellId = "notipurchasecell"
    
    var pagenum : Int = 1
    
    weak var delegate: NotiVC?
    
    var productDatas = Array<NSDictionary>()
    
    let activitycollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 72)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isHidden = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let emptyImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "activity_empty")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "아무 소식도 없어요"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.alpha = 0.3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(activitycollectionView)
        self.addSubview(emptyImg)
        self.addSubview(emptyLabel)

        activitycollectionView.delegate = self
        activitycollectionView.dataSource = self
        activitycollectionView.register(ActivityCell.self, forCellWithReuseIdentifier: notiactivitycellId)
        
        activitycollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        activitycollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        activitycollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        activitycollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        emptyImg.centerXAnchor.constraint(equalTo:activitycollectionView.centerXAnchor).isActive = true
        emptyImg.topAnchor.constraint(equalTo:activitycollectionView.topAnchor, constant: UIScreen.main.bounds.height/667 * 228).isActive = true
        emptyImg.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 50).isActive = true
        emptyImg.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 34).isActive = true
    
        emptyLabel.centerXAnchor.constraint(equalTo:activitycollectionView.centerXAnchor).isActive = true
        emptyLabel.topAnchor.constraint(equalTo:emptyImg.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 24).isActive = true
//        emptyLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 40).isActive = true
        emptyLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true

        getActivityData(pagenum: pagenum)
    }
    
    func getActivityData(pagenum: Int) {
        Alamofire.AF.request("\(Config.baseURL)/api/activity/?page=" + String(pagenum), method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let results = response.object(forKey: "results") as! Array<NSDictionary>
                for i in 0..<results.count {
                    self.productDatas.append(results[i])
                }
                if self.productDatas.count == 0 {
                    self.emptyImg.isHidden = false
                    self.emptyLabel.isHidden = false
                }
                else {
                    self.emptyImg.isHidden = true
                    self.emptyLabel.isHidden = true
                }
                DispatchQueue.main.async {
                    self.activitycollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    @objc func review(_ sender: UIButton) {
        let nextVC = ReviewVC()
        UserDefaults.standard.set(sender.tag, forKey: "purchaseUid")
        delegate?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func confirm(_ sender: UIButton) {
        print("CONFIRM")
    }
    
    @objc func delivery(_ sender: UIButton) {
        let nextVC = DeliveryVC()
        nextVC.Myid = sender.tag
        delegate?.navigationController?.pushViewController(nextVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notiactivitycellId, for: indexPath) as! ActivityCell
        let resultDic = self.productDatas[indexPath.row]
        let content = resultDic.object(forKey: "content") as! String
        let timestamp = resultDic.object(forKey: "age") as! String
        if let imageUrlString = resultDic.object(forKey: "big_image_url") as? String {
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let image = UIImage(data: imageData as Data)
            cell.activityImg.image = image
            // TODO: - circle image 안바뀜..
            cell.activityImg.layer.cornerRadius = cell.activityImg.frame.height / 2
            cell.activityImg.layer.borderColor = UIColor.clear.cgColor
            cell.activityImg.layer.borderWidth = 1
            cell.activityImg.layer.masksToBounds = false
            cell.activityImg.clipsToBounds = true
        }
        if let productImgArray = resultDic.object(forKey: "product_image_url") as? Array<NSDictionary> {
            if productImgArray.count == 1 {
                let productDic = productImgArray[0]
                let productUrl = productDic.object(forKey: "image_url") as! String
                let imageUrl:NSURL = NSURL(string: productUrl)!
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                let image = UIImage(data: imageData as Data)
                cell.productImg1.image = image
            }
            else if productImgArray.count == 2 {
                let productDic = productImgArray[0]
                let productUrl = productDic.object(forKey: "image_url") as! String
                let imageUrl:NSURL = NSURL(string: productUrl)!
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                let image = UIImage(data: imageData as Data)
                cell.productImg1.image = image
                let productDic2 = productImgArray[1]
                let productUrl2 = productDic2.object(forKey: "image_url") as! String
                let imageUrl2:NSURL = NSURL(string: productUrl2)!
                let imageData2:NSData = NSData(contentsOf: imageUrl2 as URL)!
                let image2 = UIImage(data: imageData2 as Data)
                cell.productImg2.image = image2
            }
            else if productImgArray.count == 3{
                let productDic = productImgArray[0]
                let productUrl = productDic.object(forKey: "image_url") as! String
                let imageUrl:NSURL = NSURL(string: productUrl)!
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                let image = UIImage(data: imageData as Data)
                cell.productImg1.image = image
                let productDic2 = productImgArray[1]
                let productUrl2 = productDic2.object(forKey: "image_url") as! String
                let imageUrl2:NSURL = NSURL(string: productUrl2)!
                let imageData2:NSData = NSData(contentsOf: imageUrl2 as URL)!
                let image2 = UIImage(data: imageData2 as Data)
                cell.productImg2.image = image2
                let productDic3 = productImgArray[2]
                let productUrl3 = productDic2.object(forKey: "image_url") as! String
                let imageUrl3:NSURL = NSURL(string: productUrl3)!
                let imageData3:NSData = NSData(contentsOf: imageUrl3 as URL)!
                let image3 = UIImage(data: imageData3 as Data)
                cell.productImg3.image = image3
            }
        }
        let condition = resultDic.object(forKey: "condition") as! Int
        let redirectable = resultDic.object(forKey: "redirectable") as! Bool
        if let redirect_id = resultDic.object(forKey: "redirect_id") as? Int {
            print("YES!")
        }
        if let obj_id = resultDic.object(forKey: "obj_id") as? Int {
            cell.btnConfirm.tag = obj_id
            cell.btnDelivery.tag = obj_id
            cell.btnReview.tag = obj_id
        }
        DispatchQueue.main.async {
            cell.timestampLabel.text = timestamp
            cell.contentLabel.text = content
            if condition == 0 {
                cell.btnDelivery.isHidden = true
                cell.btnReview.isHidden = true
                cell.btnConfirm.isHidden = true
            }
            else if condition == 1 {
                cell.btnDelivery.isHidden = true
                cell.btnReview.isHidden = false
                cell.btnReview.setTitleColor(UIColor(rgb: 0xb7b7bf), for: .normal)
                cell.btnReview.isEnabled = false
                cell.btnConfirm.isHidden = true
            }
            else if condition == 2 {
                cell.btnDelivery.isHidden = false
                cell.btnDelivery.setTitleColor(.white, for: .normal)
                cell.btnDelivery.setTitle("운송장 완료", for: .normal)
                cell.btnDelivery.isEnabled = false
                cell.btnReview.isHidden = true
                cell.btnConfirm.isHidden = true
            }
            else if condition == 3 {
                cell.btnDelivery.isHidden = false
                cell.btnDelivery.isEnabled = true
                cell.btnDelivery.addTarget(self, action: #selector(self.delivery(_:)), for: .touchUpInside)
                cell.btnReview.isHidden = true
                cell.btnConfirm.isHidden = true
            }
            else if condition == 10 {
                cell.btnDelivery.isHidden = true
                cell.btnReview.isHidden = true
                cell.btnConfirm.isHidden = false
                cell.btnConfirm.addTarget(self, action: #selector(self.confirm(_:)), for: .touchUpInside)
            }
            else if condition == 11 {
                cell.btnDelivery.isHidden = true
                cell.btnReview.isHidden = false
                cell.btnReview.setTitleColor(.black, for: .normal)
                cell.btnReview.addTarget(self, action: #selector(self.review(_:)), for: .touchUpInside)
                cell.btnConfirm.isHidden = true
            }
            if redirectable == true {
                cell.btnDelivery.isEnabled = true
                cell.btnReview.isEnabled = true
                cell.btnConfirm.isEnabled = true
            }
            else {
                cell.btnDelivery.isEnabled = false
                cell.btnReview.isEnabled = false
                cell.btnConfirm.isEnabled = false
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // product_image_url count 에 따라서 height 바뀌도록 해야함!
        let resultDic = self.productDatas[indexPath.row]
        let condition = resultDic.object(forKey: "condition") as! Int
        if let productImgArray = resultDic.object(forKey: "product_image_url") as? Array<NSDictionary> {
            if condition == 0 {
                return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 151)
            }
            else {
                return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 183)
            }
        }
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.productDatas.count - 1 {
            pagenum = pagenum + 1
            getActivityData(pagenum: pagenum)
        }
    }
    
}

class ActivityCell: BaseCollectionViewCell {

    let noticellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let activityImg: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0xB7B7BF)
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 11)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let productImg1: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let productImg2: UIImageView = {
       let image = UIImageView()
       image.translatesAutoresizingMaskIntoConstraints = false
       return image
   }()
    
    let productImg3: UIImageView = {
       let image = UIImageView()
       image.translatesAutoresizingMaskIntoConstraints = false
       return image
   }()
    
    let btnConfirm: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.setTitle("수령 확인", for: .normal)
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
        btn.backgroundColor = .white
        btn.setTitle("리뷰 작성", for: .normal)
        btn.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        return btn
    }()
    
    let btnDelivery: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.setTitle("운송장 입력", for: .normal)
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        return btn
    }()
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setup() {
        backgroundColor = .white
        noticellcontentView.addSubview(activityImg)
        noticellcontentView.addSubview(timestampLabel)
        noticellcontentView.addSubview(contentLabel)
        noticellcontentView.addSubview(productImg1)
        noticellcontentView.addSubview(productImg2)
        noticellcontentView.addSubview(productImg3)
        noticellcontentView.addSubview(btnReview)
        noticellcontentView.addSubview(btnConfirm)
        noticellcontentView.addSubview(btnDelivery)
        noticellcontentView.addSubview(lineLabel)
        
        self.addSubview(noticellcontentView)

        noticellcontentViewLayout()
        activityImgLayout()
        timestampLabelLayout()
        contentLabelLayout()
        productImg1Layout()
        productImg2Layout()
        productImg3Layout()
        btnReviewLayout()
        btnConfirmLayout()
        btnDeliveryLayout()
        lineLabelLayout()
        
    }

    func noticellcontentViewLayout() {
        noticellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        noticellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        noticellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        noticellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func activityImgLayout() {
        activityImg.leftAnchor.constraint(equalTo:noticellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        activityImg.topAnchor.constraint(equalTo:noticellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 16).isActive = true
        activityImg.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 40).isActive = true
        activityImg.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 40).isActive = true
    }

    func timestampLabelLayout() {
        timestampLabel.leftAnchor.constraint(equalTo:activityImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        timestampLabel.topAnchor.constraint(equalTo:noticellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 16).isActive = true
//        statusLabel.widthAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
        timestampLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 13).isActive = true
    }
    
    func contentLabelLayout() {
        contentLabel.leftAnchor.constraint(equalTo:activityImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        contentLabel.topAnchor.constraint(equalTo:timestampLabel.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 4).isActive = true
        contentLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 232).isActive = true
//        contentLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 19).isActive = true
    }
    
    func productImg1Layout() {
        productImg1.leftAnchor.constraint(equalTo:activityImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        productImg1.topAnchor.constraint(equalTo:contentLabel.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        productImg1.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 48).isActive = true
        productImg1.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 48).isActive = true
    }
    
    func productImg2Layout() {
        productImg2.leftAnchor.constraint(equalTo:productImg1.rightAnchor, constant: UIScreen.main.bounds.width/375 * 4).isActive = true
        productImg2.topAnchor.constraint(equalTo:contentLabel.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        productImg2.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 48).isActive = true
        productImg2.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 48).isActive = true
    }
    
    func productImg3Layout() {
        productImg3.leftAnchor.constraint(equalTo:productImg2.rightAnchor, constant: UIScreen.main.bounds.width/375 * 4).isActive = true
        productImg3.topAnchor.constraint(equalTo:contentLabel.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        productImg3.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 48).isActive = true
        productImg3.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 48).isActive = true
    }
    
    func btnReviewLayout() {
        btnReview.leftAnchor.constraint(equalTo:activityImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        btnReview.topAnchor.constraint(equalTo:productImg1.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        btnReview.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 96).isActive = true
        btnReview.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 32).isActive = true
    }
    
    func btnConfirmLayout() {
        btnConfirm.leftAnchor.constraint(equalTo:activityImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        btnConfirm.topAnchor.constraint(equalTo:productImg1.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        btnConfirm.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 96).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 32).isActive = true
    }
    
    func btnDeliveryLayout() {
        btnDelivery.leftAnchor.constraint(equalTo:activityImg.rightAnchor, constant: UIScreen.main.bounds.width/375 * 8).isActive = true
        btnDelivery.topAnchor.constraint(equalTo:productImg1.bottomAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
        btnDelivery.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 96).isActive = true
        btnDelivery.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 32).isActive = true
    }
    
    func lineLabelLayout() {
        lineLabel.bottomAnchor.constraint(equalTo: noticellcontentView.bottomAnchor).isActive = true
        lineLabel.centerXAnchor.constraint(equalTo: noticellcontentView.centerXAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 339).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 1).isActive = true
    }
}
