//
//  CartVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/13.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "cartcell"
private let headerId = "cartheadercell"
private let footerId = "cartfootercell"

var cartCollectionView: UICollectionView!

class CartVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
    }

    func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 375, height: 100)
        
        cartCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cartCollectionView.backgroundColor = .white
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        cartCollectionView.register(CartCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cartCollectionView.register(CartHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        cartCollectionView.register(CartFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        cartCollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(cartCollectionView)
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/trades/cart/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Token 3d9876c19e72c859b9f82cb3c36706a3de4dad95"]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                print(response)
//                let results = response["results"] as! Array<Dictionary<String, Any>>
//                for i in 0..<results.count {
//                    self.productDatas.append(results[i])
//                }
                DispatchQueue.main.async {
                    cartCollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartCell
    
        // Configure the cell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

            case UICollectionView.elementKindSectionHeader:

                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CartHeaderCell

                return headerView

            case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! CartFooterCell

                return footerView

        default:

            assert(false, "Unexpected element kind")
        }
    }
    // MARK: UICollectionViewDelegate
    
    // cell size 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375, height: 100)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 56.0)
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 156.0)
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
