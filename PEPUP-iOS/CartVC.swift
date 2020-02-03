//
//  CartVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/03.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class CartVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let cellId = "CellId"
    var colView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 111, height: 111)

        colView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        colView.delegate   = self
        colView.dataSource = self
        colView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        colView.backgroundColor = UIColor.white

        self.view.addSubview(colView)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.orange
        return cell
    }
    
}
    
