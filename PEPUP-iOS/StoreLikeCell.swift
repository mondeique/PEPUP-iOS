//
//  OhterCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/04.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class StoreLikeCell: BaseCollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private let likecellId = "likecell"
    private let likeheaderId = "likeheadercell"
    
    var pagenum : Int = 1
    
    weak var delegate : StoreVC?
    
    var SellerID = UserDefaults.standard.object(forKey: "sellerId") as! Int
    var sellerInfoDatas = NSDictionary()
    var productDatas = Array<NSDictionary>()
    
    let likecollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isHidden = false
        return collectionView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getLikeData(pagenum: 1)
        refreshControl.endRefreshing()
    }
    
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(likecollectionView)
        
        likecollectionView.delegate = self
        likecollectionView.dataSource = self
        likecollectionView.register(LikeCell.self, forCellWithReuseIdentifier: likecellId)
        
        getLikeData(pagenum: 1)
        
        likecollectionView.addSubview(refreshControl)
    }
    
    func getLikeData(pagenum: Int) {
        Alamofire.AF.request("\(Config.baseURL)/api/store/like/" + String(SellerID) + "/?page=" + String(pagenum), method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                self.productDatas = response.object(forKey: "results") as! Array<NSDictionary>
                DispatchQueue.main.async {
                    self.likecollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: likecellId, for: indexPath) as! LikeCell
        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
        let is_sold = productDictionary.object(forKey: "sold") as! Bool
        if let productImgDic = productDictionary.object(forKey: "thumbnails") as? NSDictionary {
            let imageUrlString = productImgDic.object(forKey: "thumbnail") as! String
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                cell.productImg.image = image
                if is_sold == true {
                    cell.soldLabel.isHidden = false
                }
                else {
                    cell.soldLabel.isHidden = true
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
        let productId = productDictionary.object(forKey: "id") as! Int
        let nextVC = DetailVC()
        nextVC.Myid = productId
        delegate?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.productDatas.count - 1 {
            pagenum = pagenum + 1
            getLikeData(pagenum: pagenum)
        }
    }
}

class LikeCell: BaseCollectionViewCell {

    let likecellcontentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var productImg: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1))

    let soldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S O L D"
        label.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

    override func setup() {
        backgroundColor = .white
        likecellcontentView.addSubview(productImg)
        likecellcontentView.addSubview(soldLabel)
        self.addSubview(likecellcontentView)

        likecellcontentViewLayout()
        productImgLayout()
        soldLabelLayout()
    }

    func likecellcontentViewLayout() {
        likecellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        likecellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        likecellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        likecellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productImgLayout() {
        productImg.leftAnchor.constraint(equalTo:likecellcontentView.leftAnchor).isActive = true
        productImg.topAnchor.constraint(equalTo:likecellcontentView.topAnchor).isActive = true
//        productImg.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productImg.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func soldLabelLayout() {
        soldLabel.leftAnchor.constraint(equalTo:likecellcontentView.leftAnchor).isActive = true
        soldLabel.topAnchor.constraint(equalTo:likecellcontentView.topAnchor).isActive = true
        soldLabel.widthAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
        soldLabel.heightAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width / 3) - 1).isActive = true
    }
}


