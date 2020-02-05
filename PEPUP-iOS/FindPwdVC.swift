//
//  FindPwdVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/03.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class FindPwdVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Declare each view programmatically 
    
    private let findpwdContentView: UIView = {
               let view = UIView()
               view.translatesAutoresizingMaskIntoConstraints = false
               view.backgroundColor = .gray
               return view
           }()
    
    private let btnBack:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: "btnBack"), for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    
    private let resetpwdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "비밀번호 변경"
        label.textColor = .black
        label.font = .systemFont(ofSize: 29)
        label.backgroundColor = .white
        return label
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이메일 아이디 확인 및 본인인증을 통해 /n 비밀번호를 변경하실 수 있습니다."
        label.textColor = UIColor(rgb: 0x6B6A6E)
        label.font = .systemFont(ofSize: 15)
        label.backgroundColor = .white
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아이디"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.backgroundColor = .white
        return label
    }()
    
    private let unameTxtField:UITextField = {
        let txtField = UITextField()
        txtField.placeholder = " 아이디 또는 이메일"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let btnNext:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("다음", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.layer.cornerRadius = 3
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.addTarget(self, action: #selector(next), for: .touchUpInside)
        return btn
    }()
    
    // TODO: - 비밀번호 찾기는 아이디까지 같이 확인한 다음 주는 것인가?
    
    // MARK: Button Action Selector
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func next() {
        guard let unameTxt = unameTxtField.text else {
            return
        }
        let parameters = [
            "username": unameTxt,
        ]
        Alamofire.AF.request("http://mypepup.com/accounts/reset_password/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                               (response) in switch response.result {
                               case .success(let JSON):
                                print("Success with JSON: \(JSON)")
                                self.findpwdphone()
                               case .failure(let error):
                                print("Request failed with error: \(error)")
                               }
        }
    }
    
    // MARK: 그 외 함수
    
    func findpwdphone() {
        let controller = FindPwdPhoneVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setup() {
        view.backgroundColor = .purple
        findpwdContentView.addSubview(btnBack)
        findpwdContentView.addSubview(resetpwdLabel)
        findpwdContentView.addSubview(explainLabel)
        findpwdContentView.addSubview(emailLabel)
        findpwdContentView.addSubview(unameTxtField)
        findpwdContentView.addSubview(btnNext)
        view.addSubview(findpwdContentView)

        findpwdContentViewLayout()
        btnBackLayout()
        resetpwdLabelLayout()
        explainLabelLayout()
        emailLabelLayout()
        unameTxtFieldLayout()
        btnNextLayout()
    }
    
    // MARK: Set Layout of each view
    
    func findpwdContentViewLayout() {
        findpwdContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        findpwdContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        findpwdContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        findpwdContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func btnBackLayout() {
        btnBack.topAnchor.constraint(equalTo:findpwdContentView.topAnchor, constant:34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:18).isActive = true
    }
    
    func resetpwdLabelLayout() {
        resetpwdLabel.topAnchor.constraint(equalTo:findpwdContentView.topAnchor, constant:104).isActive = true
        resetpwdLabel.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:25).isActive = true
        resetpwdLabel.widthAnchor.constraint(equalToConstant:165).isActive = true
        resetpwdLabel.heightAnchor.constraint(equalToConstant:35).isActive = true
    }
    
    func explainLabelLayout() {
        explainLabel.topAnchor.constraint(equalTo:resetpwdLabel.bottomAnchor, constant:16).isActive = true
        explainLabel.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:25).isActive = true
        explainLabel.widthAnchor.constraint(equalToConstant:235).isActive = true
        explainLabel.heightAnchor.constraint(equalToConstant:38).isActive = true
    }
    
    func emailLabelLayout() {
        emailLabel.topAnchor.constraint(equalTo:explainLabel.bottomAnchor, constant:50).isActive = true
        emailLabel.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:25).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant:45).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant:20).isActive = true
    }
    
    func unameTxtFieldLayout() {
        unameTxtField.topAnchor.constraint(equalTo:emailLabel.bottomAnchor, constant:8).isActive = true
        unameTxtField.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:25).isActive = true
        unameTxtField.widthAnchor.constraint(equalToConstant:325).isActive = true
        unameTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
    }
    
    func btnNextLayout() {
        btnNext.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:44).isActive = true
        btnNext.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:25).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant:325).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant:48).isActive = true
    }

}

