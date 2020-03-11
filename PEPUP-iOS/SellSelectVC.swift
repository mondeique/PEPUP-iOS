//
//  SellSelectVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/12.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "sellselectcell"

import UIKit
import Photos

class SellSelectVC: UIViewController {
    
    var collectionView: UICollectionView!
    var allMedia: PHFetchResult<PHAsset>?
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        layout.itemSize = CGSize(width: 1024 * self.scale, height: 1024 * self.scale)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: view.frame.width, height: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 72), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AssetsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        
        
        // MAKR: - 특정 타입(PHAssetMediaType) 미디어만 가져오는 메소드
        let fetchOptions = PHFetchOptions()
//        self.allMedia = PHAsset.fetchAssets(with: .unknown, options: fetchOptions)
        
        // MAKR: - 모든 미디어 가져오는 메소드
        self.allMedia = PHAsset.fetchAssets(with: nil)
        
        self.collectionView.reloadData()
        self.thumbnailSize = CGSize(width: 1024 * self.scale, height: 1024 * self.scale)
    }
}

extension SellSelectVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMedia?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AssetsCollectionViewCell
        let asset = self.allMedia?[indexPath.item]
        LocalImageManager.shared.requestIamge(with: asset, thumbnailSize: self.thumbnailSize) { (image) in
            cell.configure(with: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width / 3, height: 100)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class AssetsCollectionViewCell: UICollectionViewCell {
    
    var assetImageView: UIImageView!
    fileprivate let imageManager = PHImageManager()
    
    var representedAssetIdentifier: String?
    
    var thumbnailSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: (UIScreen.main.bounds.width / 3) * scale, height: 100 * scale)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.assetImageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with image: UIImage?) {
        self.assetImageView.image = image
    }
}

final class LocalImageManager {
    
    static var shared = LocalImageManager()
    
    fileprivate let imageManager = PHImageManager()
    
    var representedAssetIdentifier: String?
    
    func requestIamge(with asset: PHAsset?, thumbnailSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        guard let asset = asset else {
            completion(nil)
            return
        }
        self.representedAssetIdentifier = asset.localIdentifier
        self.imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, info in
            // UIKit may have recycled this cell by the handler's activation time.
            //  print(info?["PHImageResultIsDegradedKey"])
            // Set the cell's thumbnail image only if it's still showing the same asset.
            if self.representedAssetIdentifier == asset.localIdentifier {
                completion(image)
            }
        })
    }
}
