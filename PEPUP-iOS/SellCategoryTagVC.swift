//
//  SellCategoryTagVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/17.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

private let cellID = "tablecell"

class SellCategoryTagVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchTableView : UITableView!
    var tag_result = Array<NSDictionary>()
    
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
        let statusBarHeight: CGFloat! = UIScreen.main.bounds.height/defaultHeight * 20
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height

        navcontentView.addSubview(btnBack)
        navcontentView.addSubview(tagLabel)
        navcontentView.addSubview(btnNext)
        
        self.view.addSubview(navcontentView)
        
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        self.view.addSubview(tagView)

        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true

        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        tagLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        tagLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        btnNext.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        btnNext.rightAnchor.constraint(equalTo: navcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: navcontentView.bottomAnchor, constant: screenHeight/defaultHeight * 2).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 40).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        tagView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tagView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tagView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        tagView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        searchTableView = UITableView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: screenWidth, height: screenHeight - statusBarHeight - navBarHeight), style: .plain)
        
        self.view.addSubview(searchTableView)
        
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.separatorStyle = .none

        searchTableView.register(SearchTagCell.self, forCellReuseIdentifier: cellID)
        
        searchTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchTableView.topAnchor.constraint(equalTo: tagView.bottomAnchor).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchTableView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let parameters = [
            "keyword": searchText
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/tag/searching/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                self.tag_result = []
                 for i in 0..<response.count {
                    self.tag_result.append(response[i])
                }
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func addTagLabel() {
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tag_result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SearchTagCell
        let brandDic = tag_result[indexPath.row]
        let tag = brandDic.object(forKey: "tag") as! String
        cell.tagLabel.text = tag
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.addTagLabel()
        let tagDic = tag_result[indexPath.row]
        let name = tagDic.object(forKey: "tag") as! String
        UserDefaults.standard.set(name, forKey: "tag")
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/667 * 56
    }
    
    //MARK: - @objc func
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func ok() {
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        self.navigationController?.popToViewController(controller!, animated: true)
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
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        label.textColor = .black
        label.text = "T A G"
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
    
    let tagView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
}

class SearchTagCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview(cellcontentView)
        
        cellcontentView.addSubview(tagLabel)
//        cellcontentView.addSubview(lineLabel)
        
        cellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        tagLabel.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        tagLabel.topAnchor.constraint(equalTo: cellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
//        tagLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        tagLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 20).isActive = true
        
//        lineLabel.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
//        lineLabel.bottomAnchor.constraint(equalTo: cellcontentView.bottomAnchor).isActive = true
//        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 339).isActive = true
//        lineLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 1).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let cellcontentView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tagLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        return label
    }()
    
//    let lineLabel : UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
//        return label
//    }()
}
