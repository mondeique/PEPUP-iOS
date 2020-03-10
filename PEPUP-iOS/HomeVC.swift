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
private let headerId = "homeheadercell"

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var pagenum: Int = 1
    var productDatas = Array<Dictionary<String, Any>>()
    
    var homecollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData(pagenum: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: collectionView 전체 View setting
    
    fileprivate func setup() {
        self.view.backgroundColor = .white
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
        
        homecollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: screenHeight - statusBarHeight - screenHeight/defaultHeight * 49), collectionViewLayout: layout)
        homecollectionView.backgroundColor = .white
        homecollectionView.alwaysBounceVertical = true
        homecollectionView.showsVerticalScrollIndicator = false
        homecollectionView.keyboardDismissMode = .onDrag
        homecollectionView.delegate = self
        homecollectionView.dataSource = self
        homecollectionView.register(HomeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        homecollectionView.register(HomeHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        self.view.addSubview(homecontentView)
        
        homecontentView.addSubview(homecollectionView)
        homecontentView.addSubview(btnFilter)
        
        homecontentView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        homecontentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        homecontentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        homecollectionView.leftAnchor.constraint(equalTo: homecontentView.leftAnchor).isActive = true
        homecollectionView.topAnchor.constraint(equalTo: homecontentView.topAnchor).isActive = true
        homecollectionView.widthAnchor.constraint(equalTo: homecontentView.widthAnchor).isActive = true
        homecollectionView.heightAnchor.constraint(equalTo: homecontentView.heightAnchor).isActive = true
        
        btnFilter.rightAnchor.constraint(equalTo: homecontentView.rightAnchor, constant: screenWidth/defaultWidth * -16).isActive = true
        btnFilter.bottomAnchor.constraint(equalTo: homecontentView.bottomAnchor, constant: screenWidth/defaultWidth * -16).isActive = true
        btnFilter.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 48).isActive = true
        btnFilter.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 48).isActive = true
    }
    
    let homecontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnFilter: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnFilter"), for: .normal)
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btn.layer.shadowOpacity = 5.0
        btn.layer.shadowRadius = 6.0
        btn.layer.masksToBounds = false
        btn.addTarget(self, action: #selector(didTapfilterButton), for: .touchUpInside)
        return btn
    }()
    
    @objc func didTapfilterButton() {
        self.navigationController?.pushViewController(FilterVC(), animated: true)
    }
    
    @objc func didTapSearchBar(sender: AnyObject) {
        self.navigationController?.pushViewController(SearchVC(), animated: true)
    }
    
    @objc func didTapMessageButton(sender: AnyObject){
        self.navigationController?.pushViewController(MessageVC(), animated: true)
    }
    
    @objc func didTapCartButton(sender: AnyObject){
        self.navigationController?.pushViewController(CartVC(), animated: true)
    }
    
    // MARK: Server 로부터 Main에 뿌릴 Data Alamofire로 받아오기
    
    func getData(pagenum: Int) {
        Alamofire.AF.request("\(Config.baseURL)/api/products/?page=" + String(pagenum), method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let results = response["results"] as! Array<Dictionary<String, Any>>
                for i in 0..<results.count {
                    self.productDatas.append(results[i])
                }
                DispatchQueue.main.async {
                    self.homecollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCell
        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
        let is_sold = productDictionary.object(forKey: "sold") as! Bool
        if let productImgDic = productDictionary.object(forKey: "thumbnails") as? NSDictionary {
            let imageUrlString = productImgDic.object(forKey: "thumbnail") as! String
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            DispatchQueue.global(qos: .userInitiated).async {
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
        }
        let is_refundable = productDictionary.object(forKey: "is_refundable") as! Bool
        if is_refundable == true {
            cell.pepuptag.isHidden = false
        }
        else {
            cell.pepuptag.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {

            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HomeHeaderCell
                headerView.btnSearchBar.addTarget(self, action: #selector(didTapSearchBar(sender:)), for: .touchUpInside)
                headerView.btnCart.addTarget(self, action: #selector(didTapCartButton(sender:)), for: .touchUpInside)
                headerView.btnDirect.addTarget(self, action: #selector(didTapMessageButton(sender:)), for: .touchUpInside)
                return headerView

            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
    
    // MARK: UICollectionViewDelegate
    
    // 해당 cell 선택 시 DetailVC로 넘어감
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDictionary = self.productDatas[indexPath.row] as NSDictionary
        let productId = productDictionary.object(forKey: "id") as! Int
        let nextVC = DetailVC()
        nextVC.Myid = productId
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.productDatas.count - 1 {
            pagenum = pagenum + 1
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
