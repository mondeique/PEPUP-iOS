//
//  NickNameVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/04.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class NickNameVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Declare each view programmatically
    
    private let nicknameContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    private let nicknameTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
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
        btn.addTarget(self, action: #selector(update), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 각 Button에 따른 selector action 설정
    
    @objc func update() {
        guard let nicknameText = nicknameTxtField.text else {
            return
        }
        
        // nicknameText 에 있으면 button 활성화
        
        if isValidNickName(nickname: nicknameText) {
            btnCheck.isEnabled = true
            let parameters: [String: String] = [
                "nickname" : nicknameText
            ]
            Alamofire.AF.request("http://mypepup.com/accounts/signup/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                            (response) in switch response.result {
                            case .success(let JSON):
                                print("Success with JSON: \(JSON)")
                                self.changeprofile()
                            case .failure(let error):
                                print("Request failed with error: \(error)")
                            }
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
    
    func changeprofile() {
        let controller = ProfileVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setup() {
        view.backgroundColor = .white
        nicknameContentView.addSubview(nicknameTxtField)
        nicknameContentView.addSubview(btnCheck)
        view.addSubview(nicknameContentView)
        
        nicknameContentViewLayout()
        nicknameTxtFieldLayout()
        btnCheckLayout()
    }
    
    // MARK: Set Layout of each view
    
    func nicknameContentViewLayout() {
        nicknameContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        nicknameContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        nicknameContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        nicknameContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func nicknameTxtFieldLayout() {
        nicknameTxtField.keyboardType = .emailAddress
        nicknameTxtField.placeholder = "아이디를 입력하세요"
        nicknameTxtField.topAnchor.constraint(equalTo:nicknameContentView.topAnchor, constant:100).isActive = true
        nicknameTxtField.leftAnchor.constraint(equalTo:nicknameContentView.leftAnchor, constant:20).isActive = true
        nicknameTxtField.rightAnchor.constraint(equalTo:nicknameContentView.rightAnchor, constant:-20).isActive = true
        nicknameTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    func btnCheckLayout() {
        btnCheck.leftAnchor.constraint(equalTo:nicknameContentView.leftAnchor, constant:20).isActive = true
        btnCheck.rightAnchor.constraint(equalTo:nicknameContentView.rightAnchor, constant:-20).isActive = true
        btnCheck.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnCheck.topAnchor.constraint(equalTo:nicknameTxtField.bottomAnchor, constant:20).isActive = true
    }
}
