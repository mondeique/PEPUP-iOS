//
//  NoticeMainVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/26.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class NoticeMainVC: UIViewController {
    
    var MyId : Int!
    var noticeDatas : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    func setup() {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIScreen.main.bounds.height/defaultHeight * 20
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        self.view.addSubview(navcontentView)
        navcontentView.addSubview(btnBack)
        navcontentView.addSubview(noticeLabel)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        noticeLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        noticeLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(contentLabel)
        
        titleLabel.topAnchor.constraint(equalTo: navcontentView.bottomAnchor, constant: screenHeight/defaultHeight * 40).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
//        titleLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: screenHeight/defaultHeight * 16).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        contentLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        contentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        contexttxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        self.setinfo()
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/notice/" + String(MyId) + "/" , method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                self.noticeDatas = response
                self.setup()
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func setinfo() {
        let title = self.noticeDatas.object(forKey: "title") as! String
        titleLabel.text = title
        let context = self.noticeDatas.object(forKey: "content") as! String
        contentLabel.attributedText = context.htmlToAttributedString
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
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
    
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.text = "공지사항"
        label.textAlignment = .center
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.backgroundColor = .white
        return label
    }()

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
