//
//  SupportDeliveryCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/27.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class SupportDeliveryCell: BaseCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let supportdeliverycellId = "supportdeliverycell"
//    private let footerId = "supporotherfootercell"
    
    weak var delegate: SupportVC?
    
    var productDatas = Array<NSDictionary>()
    
    let supportdeliverycollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/667 * 56)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isHidden = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(supportdeliverycollectionView)

        supportdeliverycollectionView.delegate = self
        supportdeliverycollectionView.dataSource = self
        supportdeliverycollectionView.register(SupportDeliveryMainCell.self, forCellWithReuseIdentifier: supportdeliverycellId)
//        supportotalcollectionView.register(SupportTotalMainFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        supportdeliverycollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        supportdeliverycollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        supportdeliverycollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        supportdeliverycollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        getDeliveryData()
    }
    
    @objc func down() {
        print("DOWN!")
    }
    
    func getDeliveryData() {
        Alamofire.AF.request("\(Config.baseURL)/api/faq/?filter=3", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                for i in 0..<response.count {
                    self.productDatas.append(response[i])
                }
                print(response)
                DispatchQueue.main.async {
                    self.supportdeliverycollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return self.productDatas.count
//    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: supportdeliverycellId, for: indexPath) as! SupportDeliveryMainCell
        let supportDic = self.productDatas[indexPath.row]
        let title = supportDic.object(forKey: "title") as! String
        cell.faqtitleLabel.text = title
        cell.btnDown.addTarget(self, action: #selector(down), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TOUCH")
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        switch kind {
//
//            case UICollectionView.elementKindSectionFooter:
//
//                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! SupportTotalMainFooterCell
//                return footerView
//
//            default:
//                assert(false, "Unexpected element kind")
//        }
//    }

}

class SupportDeliveryMainCell: BaseCollectionViewCell {

    let supportdeliverymaincellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let faqtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        return label
    }()
    
    let btnDown: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "disclosure_indicator_faq"), for: .normal)
        btn.isHidden = false
        return btn
    }()
    
    let faqcontentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.isHidden = true
        return label
    }()

    override func setup() {
        backgroundColor = .white
        supportdeliverymaincellcontentView.addSubview(faqtitleLabel)
        supportdeliverymaincellcontentView.addSubview(btnDown)
        
        self.addSubview(supportdeliverymaincellcontentView)
        supportdeliverymaincellcontentViewLayout()
        faqtitleLabelLayout()
        btnDownLayout()
    }

    func supportdeliverymaincellcontentViewLayout() {
        supportdeliverymaincellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        supportdeliverymaincellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        supportdeliverymaincellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        supportdeliverymaincellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func faqtitleLabelLayout() {
        faqtitleLabel.leftAnchor.constraint(equalTo:supportdeliverymaincellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
//        faqtitleLabel.topAnchor.constraint(equalTo:supporttotalmaincellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 12).isActive = true
        faqtitleLabel.centerYAnchor.constraint(equalTo: supportdeliverymaincellcontentView.centerYAnchor).isActive = true
//        faqtitleLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 72).isActive = true
        faqtitleLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 20).isActive = true
    }

    func btnDownLayout() {
        btnDown.rightAnchor.constraint(equalTo:supportdeliverymaincellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
//        btnDown.topAnchor.constraint(equalTo:supporttotalmaincellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 11).isActive = true
        btnDown.centerYAnchor.constraint(equalTo: supportdeliverymaincellcontentView.centerYAnchor).isActive = true
        btnDown.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 16).isActive = true
        btnDown.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 10).isActive = true
    }
}

