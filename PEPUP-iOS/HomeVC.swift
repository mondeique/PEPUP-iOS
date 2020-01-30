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
    
    var productDatas = Array<Dictionary<String, Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        getData()
        // Do any additional setup after loading the view.
    }
    
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
        let cartImage = UIImage(named: "home_unselected")
        
        let pepupImage = UIImage(named: "home_selected")
        
        let pepupButton = UIBarButtonItem(image: pepupImage,  style: .plain, target: self, action: #selector(didTapNotiButton))
        let notiButton = UIBarButtonItem(image: notiImage,  style: .plain, target: self, action: #selector(didTapNotiButton))
        let cartButton = UIBarButtonItem(image: cartImage,  style: .plain, target: self, action: #selector(didTapCartButton))
        
        navigationItem.leftBarButtonItem = pepupButton
        navigationItem.rightBarButtonItems = [cartButton, notiButton]
    }
    
    @objc func didTapNotiButton(sender: AnyObject){
        self.navigationController?.pushViewController(NotiVC(), animated: true)
    }

    @objc func didTapCartButton(sender: AnyObject){
        self.navigationController?.pushViewController(CartVC(), animated: true)
    }
    
    func getData() {
            Alamofire.AF.request("http://54.180.150.167/api/products/?page=1", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Token fd05a1d4c9d3d6dfdae7cf7249cee0043a8db04e"]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
//                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    let results = response["results"] as! Array<Dictionary<String, Any>>
                    self.productDatas = results
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

            let is_sold = productDictionary.object(forKey: "sold") as! Bool

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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HomeHeaderCell
            
            headerView.tag = indexPath.section
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
            
            headerView.addGestureRecognizer(tapGestureRecognizer)
            return headerView
        }
        fatalError()
    }
    
    @objc func tapDetected(sender: UITapGestureRecognizer) {
        self.navigationController?.pushViewController(SearchVC(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailVC(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
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

}
