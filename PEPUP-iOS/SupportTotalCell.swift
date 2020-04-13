//
//  SupportTotalCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/26.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class SupportTotalCell: BaseCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    private let supportotalcellId = "supportotalcell"
    private let footerId = "supportotalfootercell"
    
    weak var delegate: SupportVC?
    
    var productDatas = Array<NSDictionary>()
    
    let supportotalcollectionView: UICollectionView = {
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
        
        self.addSubview(supportotalcollectionView)

        supportotalcollectionView.delegate = self
        supportotalcollectionView.dataSource = self
        supportotalcollectionView.register(SupportTotalMainCell.self, forCellWithReuseIdentifier: supportotalcellId)
//        supportotalcollectionView.register(SupportTotalMainFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        supportotalcollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        supportotalcollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        supportotalcollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        supportotalcollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        getTotalData()
    }
    
    @objc func down() {
        print("DOWN!")
    }
    
    func getTotalData() {
        Alamofire.AF.request("\(Config.baseURL)/api/faq/?filter=1", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                for i in 0..<response.count {
                    self.productDatas.append(response[i])
                }
                print(response)
                DispatchQueue.main.async {
                    self.supportotalcollectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: supportotalcellId, for: indexPath) as! SupportTotalMainCell
        let supportDic = self.productDatas[indexPath.row]
        let title = supportDic.object(forKey: "title") as! String
        cell.faqtitleLabel.text = title
        cell.btnDown.addTarget(self, action: #selector(down), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TOUCH")
        let supportDic = self.productDatas[indexPath.row]
        let title = supportDic.object(forKey: "title") as! String
        let id  = supportDic.object(forKey: "id") as! Int
        let content = supportDic.object(forKey: "content") as! String
        let nextVC = SupportMainVC()
        nextVC.Mytitle = title
        nextVC.Myid = id
        nextVC.Mycontent = content
        delegate?.navigationController?.pushViewController(nextVC, animated: true)
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

class SupportTotalMainCell: BaseCollectionViewCell {

    let supporttotalmaincellcontentView: UIView = {
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
        supporttotalmaincellcontentView.addSubview(faqtitleLabel)
        supporttotalmaincellcontentView.addSubview(btnDown)
        
        self.addSubview(supporttotalmaincellcontentView)
        supporttotalmaincellcontentViewLayout()
        faqtitleLabelLayout()
        btnDownLayout()
    }

    func supporttotalmaincellcontentViewLayout() {
        supporttotalmaincellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        supporttotalmaincellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        supporttotalmaincellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        supporttotalmaincellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func faqtitleLabelLayout() {
        faqtitleLabel.leftAnchor.constraint(equalTo:supporttotalmaincellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
//        faqtitleLabel.topAnchor.constraint(equalTo:supporttotalmaincellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 12).isActive = true
        faqtitleLabel.centerYAnchor.constraint(equalTo: supporttotalmaincellcontentView.centerYAnchor).isActive = true
//        faqtitleLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 72).isActive = true
        faqtitleLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 20).isActive = true
    }

    func btnDownLayout() {
        btnDown.rightAnchor.constraint(equalTo:supporttotalmaincellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
//        btnDown.topAnchor.constraint(equalTo:supporttotalmaincellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 11).isActive = true
        btnDown.centerYAnchor.constraint(equalTo: supporttotalmaincellcontentView.centerYAnchor).isActive = true
        btnDown.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 16).isActive = true
        btnDown.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 10).isActive = true
    }
}

//class SupportTotalMainFooterCell: BaseCollectionViewCell {
//
//    let supporttotalmainfootercellcontentView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let faqcontentLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .black
//        label.textAlignment = .left
//        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
//        return label
//    }()
//
//    override func setup() {
//        backgroundColor = .white
//        supporttotalmainfootercellcontentView.addSubview(faqcontentLabel)
//
//        self.addSubview(supporttotalmainfootercellcontentView)
//        supporttotalmainfootercellcontentViewLayout()
//        faqcontentLabelLayout()
//    }
//
//    func supporttotalmainfootercellcontentViewLayout() {
//        supporttotalmainfootercellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        supporttotalmainfootercellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        supporttotalmainfootercellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        supporttotalmainfootercellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//    }
//
//    func faqcontentLabelLayout() {
//        faqcontentLabel.leftAnchor.constraint(equalTo:supporttotalmainfootercellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
//        faqcontentLabel.topAnchor.constraint(equalTo:supporttotalmainfootercellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 8).isActive = true
//        faqcontentLabel.centerYAnchor.constraint(equalTo: supporttotalmainfootercellcontentView.centerYAnchor).isActive = true
//        faqcontentLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width).isActive = true
////        faqcontentLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 20).isActive = true
//    }
//}
