//
//  HomeVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/29.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "homecell"
private let headerId = "headercell"

class HomeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var pagenum: Int = 1
    var productDatas = Array<Dictionary<String, Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData(pagenum: 1)
//        getData(pagenum: "2")
    }
    
    // MARK: collectionView 전체 View setting
    
    fileprivate func setup() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(HomeHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        let notiImage = UIImage(named: "home_selected")
        let cartImage = UIImage(named: "home_selected")
        
        let searchImage = UIImage(named: "home_selected")
        
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapPepupButton))
        let notiButton = UIBarButtonItem(image: notiImage,  style: .plain, target: self, action: #selector(didTapNotiButton))
        let cartButton = UIBarButtonItem(image: cartImage, style: .plain, target: self, action: #selector(didTapCartButton))
        
//        let menuBarItem = UIBarButtonItem(customView: menuBtn)
//        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
//        currWidth?.isActive = true
//        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
//        currHeight?.isActive = true
//        self.navigationItem.leftBarButtonItem = menuBarItem
        
        navigationItem.leftBarButtonItem = searchButton
        navigationItem.rightBarButtonItems = [cartButton, notiButton]
        
    }
    
    @objc func didTapPepupButton(sender: AnyObject) {
        self.navigationController?.pushViewController(SearchVC(), animated: true)
    }
    
    @objc func didTapNotiButton(sender: AnyObject){
        self.navigationController?.pushViewController(NotiVC(), animated: true)
    }
    
    @objc func didTapCartButton(sender: AnyObject){
        self.navigationController?.pushViewController(CartVC(), animated: true)
    }
    
    // MARK: Server 로부터 Main에 뿌릴 Data Alamofire로 받아오기
    
    func getData(pagenum: Int) {
//        self.productDatas = []
        Alamofire.AF.request("\(Config.baseURL)/api/products/?page=" + String(pagenum), method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": Config.token]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let results = response["results"] as! Array<Dictionary<String, Any>>
                for i in 0..<results.count {
                    self.productDatas.append(results[i])
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDatas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCell
        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
        if let productImgArray = productDictionary.object(forKey: "thumbnails") as? Array<Dictionary<String, String>> {
            let productUrlDictionary = productImgArray[0] as NSDictionary
            let imageUrlString = productUrlDictionary.object(forKey: "thumbnail") as! String
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            
            // TODO: - sold 처리

            DispatchQueue.global(qos: .userInitiated).async {
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    cell.productImg.image = image
//                    if is_sold == true {
//                        cell.soldImg.isHidden = false
//                    }
                }
            }
        }
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailVC(), animated: true)
    }
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    // item = cell 마다 space 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // line 마다 space 설정
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.productDatas.count - 1 {
            pagenum = pagenum + 1
            print(pagenum)
            getData(pagenum: pagenum)
        }
    }
}
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

