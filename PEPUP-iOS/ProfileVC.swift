//
//  ProfileVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/04.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Declare each view programmatically
    
    private let profileContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    // TODO: - imageView 뭐 들어가야하는지 알아보기
    
    private let profileImage:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let btnCheck:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Check", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(signup), for: .touchUpInside)
        return btn
    }()
    
    let btnLater:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Later", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(signup), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 각 Button에 따른 selector action 설정
    
    @objc func signup() {
        guard let profile = profileImage.image else {
            return
        }
        let parameters: [String: [UIImage]?] = [
            "thumbnail" : profile.images
        ]
        Alamofire.AF.request("http://mypepup.com/accounts/signup/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                        (response) in switch response.result {
                        case .success(let JSON):
                            print("Success with JSON: \(JSON)")
                            self.successAlert()
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                        }
        }
    }
    
    func isValidNickName(nickname: String) -> Bool {
        if nickname.count > 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func successAlert() {
        let controller = TabBarController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setup() {
        view.backgroundColor = .white
        profileContentView.addSubview(profileImage)
        profileContentView.addSubview(btnCheck)
        view.addSubview(profileContentView)
        
        profileContentViewLayout()
        profileImageLayout()
        btnCheckLayout()
        btnLaterLayout()
    }
    
    // MARK: Set Layout of each view
    
    func profileContentViewLayout() {
        profileContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        profileContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        profileContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        profileContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func profileImageLayout() {
        profileImage.topAnchor.constraint(equalTo:profileContentView.topAnchor, constant:100).isActive = true
        profileImage.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:20).isActive = true
        profileImage.rightAnchor.constraint(equalTo:profileContentView.rightAnchor, constant:-20).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    func btnCheckLayout() {
        btnCheck.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:20).isActive = true
        btnCheck.rightAnchor.constraint(equalTo:profileContentView.rightAnchor, constant:-20).isActive = true
        btnCheck.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnCheck.topAnchor.constraint(equalTo:profileImage.bottomAnchor, constant:20).isActive = true
    }
    
    func btnLaterLayout() {
        btnLater.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:20).isActive = true
        btnLater.rightAnchor.constraint(equalTo:profileContentView.rightAnchor, constant:-20).isActive = true
        btnLater.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnLater.topAnchor.constraint(equalTo:btnCheck.bottomAnchor, constant:20).isActive = true
    }
    

}
