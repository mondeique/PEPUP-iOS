//
//  TagVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/24.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "tagcell"
private let headerId = "followheadercell"

class TagVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var productDatas = Array<Dictionary<String, Any>>()
    var TagID : Int!
    var TagName : String!
    var tagCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData(pagenum: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: collectionView 전체 View setting
    
    fileprivate func setup() {
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3 - 1, height: screenWidth/3 - 1)
        
        let navcontentView : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let btnBack: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(named: "btnBack"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.addTarget(self, action: #selector(back), for: .touchUpInside)
            return btn
        }()
        
        let TagLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
            label.text = "#" + self.TagName
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        
        navcontentView.addSubview(btnBack)
        navcontentView.addSubview(TagLabel)
        
        self.view.addSubview(navcontentView)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        TagLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        TagLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        tagCollectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: view.frame.width, height: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 49), collectionViewLayout: layout)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.showsVerticalScrollIndicator = false
        tagCollectionView.keyboardDismissMode = .onDrag
        tagCollectionView.alwaysBounceVertical = true
        tagCollectionView.register(TagCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        tagCollectionView.register(TagHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        tagCollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(navcontentView)
        self.view.addSubview(tagCollectionView)
        
    }
    
    // MARK: Server 로부터 Main에 뿌릴 Data Alamofire로 받아오기
    
    func getData(pagenum: Int) {
        Alamofire.AF.request("\(Config.baseURL)/api/search/tag_search/" + String(TagID) + "/?page=" + String(pagenum), method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let results = response.object(forKey: "results") as! Array<Dictionary<String, Any>>
                for i in 0..<results.count {
                    self.productDatas.append(results[i])
                }
                DispatchQueue.main.async {
                    self.tagCollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    @objc func follow(_ sender: UIButton) {
        let parameters: [String: Int] = [
            "tag" : TagID
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/follow/following/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                print(response)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TagCell
        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
        if let productImgDic = productDictionary.object(forKey: "images") as? NSDictionary {
            let imageUrlString = productImgDic.object(forKey: "image") as! String
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    cell.productImg.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! TagHeaderCell
            headerView.followButton.addTarget(self, action: #selector(follow(_:)), for: .touchUpInside)
            return headerView

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 60)
//    }
    
//    @objc func tapDetected(sender: UITapGestureRecognizer) {
//        self.navigationController?.pushViewController(SearchVC(), animated: true)
//    }
    
    
    // MARK: UICollectionViewDelegate
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // line 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height/667 * 72)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == self.productDatas.count - 1 {
//            pagenum = pagenum + 1
//            print(pagenum)
//            getData(pagenum: pagenum)
//        }
//    }
}
