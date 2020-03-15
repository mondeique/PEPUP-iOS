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

class SellCategoryBrandVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchTableView : UITableView!
    var brand_result = Array<NSDictionary>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
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
        searchTableView.separatorStyle = .none

        searchTableView.register(SearchBrandCell.self, forCellReuseIdentifier: cellID)
        
        searchTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchTableView.topAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchTableView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/brand/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                for i in 0..<response.count {
                    self.brand_result.append(response[i])
                }
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let parameters = [
            "keyword": searchText
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/brand/searching/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                self.brand_result = []
                 for i in 0..<response.count {
                    self.brand_result.append(response[i])
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brand_result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SearchBrandCell
        let brandDic = brand_result[indexPath.row]
        let name = brandDic.object(forKey: "name") as! String
        cell.brandLabel.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = SellVC()
        let brandDic = brand_result[indexPath.row]
        let name = brandDic.object(forKey: "name") as! String
        nextVC.brand = name
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/667 * 56
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

class SearchBrandCell: UITableViewCell {

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
        
        cellcontentView.addSubview(brandLabel)
        cellcontentView.addSubview(lineLabel)
        
        cellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        brandLabel.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        brandLabel.topAnchor.constraint(equalTo: cellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
//        brandLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        brandLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 20).isActive = true
        
        lineLabel.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        lineLabel.bottomAnchor.constraint(equalTo: cellcontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 339).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 1).isActive = true
        
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
    
    let brandLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        return label
    }()
    
    let lineLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
}
    
