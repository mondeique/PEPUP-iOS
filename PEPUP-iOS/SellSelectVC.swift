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

class SellSelectVC: UIViewController {
    
    var collectionView: UICollectionView!
    var scrollView: UIScrollView!
    var allPhotos: PHFetchResult<PHAsset>!
    let imageManager = PHCachingImageManager()
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize.zero
    let nextVC = SellVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateAlert()
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            setup()
        }
        else if PHPhotoLibrary.authorizationStatus() == .denied{
            self.photopermissionAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(-1, forKey: "first_category")
        UserDefaults.standard.set("", forKey: "second_category")
        UserDefaults.standard.set(-1, forKey: "second_category_id")
        UserDefaults.standard.set("", forKey: "size")
        UserDefaults.standard.set(-1, forKey: "size_id")
        UserDefaults.standard.set("", forKey: "brand")
        UserDefaults.standard.set(-1, forKey: "brand_id")
        UserDefaults.standard.set("", forKey: "tag")
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    @objc func photopermissionAlert() {
        view.backgroundColor = .white
        let alertController = UIAlertController(title: "사진 허용이 거부되어 있습니다.", message: "알림을 켜주세요", preferredStyle: .alert)
        let permissionAction = UIAlertAction(title: "확인", style: .default) { (action) in
//            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString) as! URL)
            UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
//            let nextVC = TabBarController()
//            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        alertController.addAction(permissionAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateAlert() {
        let alertController = UIAlertController(title: nil, message: "업데이트 예정입니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            self.navigationController?.pushViewController(TabBarController(), animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setup() {
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIScreen.main.bounds.height/defaultHeight * 20
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        self.view.addSubview(navcontentView)
        navcontentView.addSubview(btnBack)
        navcontentView.addSubview(sellLabel)
        navcontentView.addSubview(btnNext)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        sellLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        sellLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        btnNext.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        btnNext.rightAnchor.constraint(equalTo: navcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        
        scrollView = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: navBarHeight + statusBarHeight), size: CGSize(width: screenWidth, height: screenHeight)))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollView.contentInset = UIEdgeInsets.zero
        view.addSubview(scrollView)
        
        scrollView.addSubview(productImage)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeight + statusBarHeight).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width / 4 , height: self.view.frame.width / 4)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight + view.frame.width, width: view.frame.width, height: screenHeight), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AssetsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(collectionView)
        
        fetchAllPhotos()
        
    }
    
    func fetchAllPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: fetchOptions)
        
        collectionView.reloadData()
        self.thumbnailSize = CGSize(width: 1024 * self.scale, height: 1024 * self.scale)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: thumbnailSize.height)
        
        productImage.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        productImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        productImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
//        scrollView.bottomAnchor.constraint(equalTo: productImage.bottomAnchor).isActive = true
    }
    
    @objc func back() {
        let nextVC = TabBarController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func ok() {
        if nextVC.imageData.count == 0 {
            self.selectAlert()
        }
        else {
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func selectAlert() {
        let alertController = UIAlertController(title: nil, message: "사진을 1장 이상 선택해주세요", preferredStyle: .alert)
        let selectAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(selectAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    let navcontentView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.backgroundColor = .white
       return view
    }()

    let btnBack: UIButton = {
       let btn = UIButton()
       btn.setImage(UIImage(named: "btnBack"), for: .normal)
       btn.translatesAutoresizingMaskIntoConstraints = false
       btn.addTarget(self, action: #selector(back), for: .touchUpInside)
       return btn
    }()
    
    let sellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        label.textColor = .black
        label.text = "SELLING"
        label.textAlignment = .center
        return label
    }()
    
    let btnNext: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "OK"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(ok), for: .touchUpInside)
        return btn
    }()
    
    let productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
}

extension SellSelectVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPhotos.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AssetsCollectionViewCell
        let asset = allPhotos.object(at: indexPath.item)
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: self.thumbnailSize, contentMode: .default, options: nil, resultHandler:
            { image, _ in if cell.representedAssetIdentifier == asset.localIdentifier
            {
                cell.assetImageView.image = image
                if indexPath.row == 0 {
                    self.productImage.image = image
                }
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width / 4, height: self.view.frame.width / 4)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! AssetsCollectionViewCell
        let cell_image = cell.assetImageView.image!
        productImage.image = cell_image
        
        cell.btnSelect.isHidden = false
        if cell.btnSelect.currentImage == UIImage(named: "btnSelect_un") {
            cell.btnSelect.setImage(UIImage(named: "btnSelect"), for: .normal)
            
            nextVC.imageData.append(cell_image)
            cell.tag = nextVC.imageData.count
        }
        else if cell.btnSelect.currentImage == UIImage(named: "btnSelect") {
            cell.btnSelect.setImage(UIImage(named: "btnSelect_un"), for: .normal)
            nextVC.imageData.removeLast()
        }
    }
    
    func cropImage(image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage! // better to write "guard" in realm app
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!)
    }
}

class AssetsCollectionViewCell: BaseCollectionViewCell {
    
    override func setup() {
        backgroundColor = .white
        
        cellcontentView.addSubview(assetImageView)
        cellcontentView.addSubview(btnSelect)
        
        self.addSubview(cellcontentView)
        
        cellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        assetImageView.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor).isActive = true
        assetImageView.topAnchor.constraint(equalTo: cellcontentView.topAnchor).isActive = true
        assetImageView.widthAnchor.constraint(equalTo: cellcontentView.widthAnchor).isActive = true
        assetImageView.heightAnchor.constraint(equalTo: cellcontentView.heightAnchor).isActive = true
        
        btnSelect.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/16 * 3).isActive = true
        btnSelect.topAnchor.constraint(equalTo: cellcontentView.topAnchor).isActive = true
        btnSelect.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 20).isActive = true
        btnSelect.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 20).isActive = true
        
    }
    
    let cellcontentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 4), height: (UIScreen.main.bounds.width / 4)))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let assetImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 4), height: (UIScreen.main.bounds.width / 4)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let btnSelect: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "btnSelect_un"), for: .normal)
        return btn
    }()
    
    fileprivate let imageManager = PHImageManager()
    
    var representedAssetIdentifier: String?
    
    var thumbnailSize: CGSize {
//        let scale = UIScreen.main.scale
        return CGSize(width: (UIScreen.main.bounds.width / 4) , height: (UIScreen.main.bounds.width / 4))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.assetImageView.contentMode = .scaleAspectFill
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(with image: UIImage?) {
        self.assetImageView.image = image
    }
}
