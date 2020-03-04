//
//  SearchVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let cellID = "tablecell"

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchTableView : UITableView!
    var name_result : Int!
    var seller_result = Array<Dictionary<String, Any>>()
    var tag_result = Array<Dictionary<String, Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setup() {
        self.view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height

        navcontentView.addSubview(btnBack)
        navcontentView.addSubview(searchBar)
        
        searchBar.delegate = self

        self.view.addSubview(navcontentView)

        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true

        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 2).isActive = true
        searchBar.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 52).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 305).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 40).isActive = true
        
        searchTableView = UITableView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: screenWidth, height: screenHeight - statusBarHeight - navBarHeight), style: .plain)
        
        self.view.addSubview(searchTableView)
        
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.isHidden = true
        searchTableView.separatorStyle = .none

        searchTableView.register(SearchCell.self, forCellReuseIdentifier: cellID)
        
        searchTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchTableView.topAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchTableView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTableView.isHidden = false
        let parameters = [
            "keyword": searchText
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/search/searching/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                self.name_result = 0
                self.seller_result = Array<Dictionary<String, Any>>()
                self.tag_result = Array<Dictionary<String, Any>>()
                print(JSON)
                let response =  JSON as! NSDictionary
                let namecount = response.object(forKey: "name_result") as! Int
                self.name_result = namecount
                let sellerArray = response.object(forKey: "seller_result") as! Array<Dictionary<String, Any>>
                for i in 0..<sellerArray.count {
                    self.seller_result.append(sellerArray[i])
                }
                let tagArray = response.object(forKey: "tag_result") as! Array<Dictionary<String, Any>>
                for i in 0..<tagArray.count {
                    self.tag_result.append(tagArray[i])
                }
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.seller_result.count == 0 || self.tag_result.count == 0 {
            return 2
        }
        else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 && self.seller_result.count == 0{
            return self.tag_result.count
        }
        else if section == 1 && self.tag_result.count == 0 {
            return self.seller_result.count
        }
        else if section == 2 {
            return self.seller_result.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SearchCell
        if indexPath.section == 0 {
            cell.storecontentView.isHidden = true
            cell.cellcontentView.isHidden = false
            cell.productLabel.isHidden = false
            cell.productLabel.text = searchBar.text
            cell.productcountLabel.isHidden = false
            if self.name_result != nil {
                cell.productcountLabel.text = String(self.name_result)
            }
            cell.btnGO.isHidden = false
            cell.lineLabel.isHidden = false
        }
        else if indexPath.section == 1 && self.seller_result.count == 0 {
            let tagResultDic = self.tag_result[indexPath.row] as NSDictionary
            let tag = tagResultDic.object(forKey: "tag") as! String
            cell.cellcontentView.isHidden = false
            cell.productLabel.isHidden = false
            cell.productLabel.text = "#" + tag
            cell.storecontentView.isHidden = true
            cell.productcountLabel.isHidden = true
            cell.btnGO.isHidden = true
        }
        else if indexPath.section == 1 && self.tag_result.count == 0 {
            cell.cellcontentView.isHidden = true
            let sellerDic = self.seller_result[indexPath.row] as NSDictionary
            let profileDic = sellerDic.object(forKey: "profile") as! NSDictionary
            let ImageUrlString = profileDic.object(forKey: "thumbnail_img") as! String
            let imageUrl:NSURL = NSURL(string: ImageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let image = UIImage(data: imageData as Data)
            cell.storecontentView.isHidden = false
            cell.storeProfile.isHidden = false
            cell.storeProfile.image = image
            cell.storeProfile.layer.cornerRadius = cell.storeProfile.frame.height / 2
            cell.storeProfile.layer.borderColor = UIColor.clear.cgColor
            cell.storeProfile.layer.borderWidth = 1
            cell.storeProfile.layer.masksToBounds = false
            cell.storeProfile.clipsToBounds = true
            let nickname = sellerDic.object(forKey: "nickname") as! String
            cell.storeLabel.isHidden = false
            cell.storeLabel.text = nickname
            cell.btnGO.isHidden = true
            cell.productcountLabel.isHidden = true
        }
        else if indexPath.section == 2{
            cell.cellcontentView.isHidden = true
            let sellerDic = self.seller_result[indexPath.row] as NSDictionary
            let profileDic = sellerDic.object(forKey: "profile") as! NSDictionary
            let ImageUrlString = profileDic.object(forKey: "thumbnail_img") as! String
            let imageUrl:NSURL = NSURL(string: ImageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let image = UIImage(data: imageData as Data)
            cell.storecontentView.isHidden = false
            cell.storeProfile.isHidden = false
            cell.storeProfile.image = image
            cell.storeProfile.layer.cornerRadius = cell.storeProfile.frame.height / 2
            cell.storeProfile.layer.borderColor = UIColor.clear.cgColor
            cell.storeProfile.layer.borderWidth = 1
            cell.storeProfile.layer.masksToBounds = false
            cell.storeProfile.clipsToBounds = true
            let nickname = sellerDic.object(forKey: "nickname") as! String
            cell.storeLabel.isHidden = false
            cell.storeLabel.text = nickname
            cell.btnGO.isHidden = true
            cell.productcountLabel.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let nextVC = SearchResultVC()
            nextVC.searchName = searchBar.text
            nextVC.searchCount = self.name_result
            navigationController?.pushViewController(nextVC, animated: true)
        }
        else if indexPath.section == 1 {
            let nextVC = TagVC()
            let tagDic = self.tag_result[indexPath.row] as NSDictionary
            let tagID = tagDic.object(forKey: "id") as! Int
            let tagName = tagDic.object(forKey: "tag") as! String
            nextVC.TagID = tagID
            nextVC.TagName = tagName
            navigationController?.pushViewController(nextVC, animated: true)
        }
        else if indexPath.section == 2 {
            let nextVC = TestStoreVC()
            let sellerDic = self.seller_result[indexPath.row] as NSDictionary
            let sellerID = sellerDic.object(forKey: "id") as! Int
            nextVC.SellerID = sellerID
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/667 * 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: UIScreen.main.bounds.height/667 * 44))
        headerView.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect.init(x: UIScreen.main.bounds.width/375 * 18, y: UIScreen.main.bounds.height/667 * 24, width: headerView.frame.width, height: UIScreen.main.bounds.height/667 * 16)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        label.textColor = .black
        
        if section == 0 {
            label.text = "PRODUCTS"
        }
        else if self.seller_result.count == 0 && self.tag_result.count == 0 {
            label.text = ""
        }
        else if section == 1 && self.seller_result.count == 0 {
            label.text = "TAG"
        }
        else if section == 1 && self.tag_result.count == 0 {
            label.text = "STORE"
        }
        else if section == 2 {
            label.text = "STORE"
        }

        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height/667 * 44
    }
    
    //MARK: - @objc func
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Outlets
    
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
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 22
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.masksToBounds = false
        searchBar.clipsToBounds = true
        return searchBar
    }()

}
