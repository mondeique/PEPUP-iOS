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
private let headerId = "headercell"

class TagVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
//    var pagenum: Int = 1
//    var productDatas = Array<Dictionary<String, Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setup()
//        getData(pagenum: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
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
        
        let tagCollectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: view.frame.width, height: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 72), collectionViewLayout: layout)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.showsVerticalScrollIndicator = false
        tagCollectionView.keyboardDismissMode = .onDrag
        tagCollectionView.alwaysBounceVertical = true
        tagCollectionView.register(TagCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        tagCollectionView.register(CartHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        tagCollectionView.backgroundColor = UIColor.white
        
        
    }
    
    
    // MARK: Server 로부터 Main에 뿌릴 Data Alamofire로 받아오기
    
//    func getData(pagenum: Int) {
//        Alamofire.AF.request("\(Config.baseURL)/api/products/?page=" + String(pagenum), method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
//            (response) in switch response.result {
//            case .success(let JSON):
//                let response = JSON as! NSDictionary
////                }
////                DispatchQueue.main.async {
////                    self.collectionView.reloadData()
////                }
//            case .failure(let error):
//                print("Request failed with error: \(error)")
//            }
//        }
//    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TagCell
        
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HomeHeaderCell
//
//            headerView.tag = indexPath.section
//
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
//
//            headerView.addGestureRecognizer(tapGestureRecognizer)
//            return headerView
//        }
//        fatalError()
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 60)
//    }
    
//    @objc func tapDetected(sender: UITapGestureRecognizer) {
//        self.navigationController?.pushViewController(SearchVC(), animated: true)
//    }
    
    
    // MARK: UICollectionViewDelegate
    
    // 해당 cell 선택 시 DetailVC로 넘어감
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
//        let productId = productDictionary.object(forKey: "id") as! Int
//        let nextVC = DetailVC()
//        nextVC.Myid = productId
//        navigationController?.pushViewController(nextVC, animated: true)
//    }
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // line 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == self.productDatas.count - 1 {
//            pagenum = pagenum + 1
//            print(pagenum)
//            getData(pagenum: pagenum)
//        }
//    }
}
