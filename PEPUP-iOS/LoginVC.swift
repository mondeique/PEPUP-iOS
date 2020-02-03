//
//  LoginVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Declare each view programmatically 
    
    private let loginContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    private let unameTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let pwordTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    let btnLogin:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Login", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    
    let btnSignup:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Signup", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(phoneconfirm), for: .touchUpInside)
        return btn
    }()
    
    let btnFindID:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Find ID", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(findid), for: .touchUpInside)
        return btn
    }()
    
    let btnFindPwd:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Find Pwd", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(findpwd), for: .touchUpInside)
        return btn
    }()

    // MARK: 각 Button에 따른 selector action 설정
    
    @objc func login() {
        guard let emailText = unameTxtField.text else {
            return
        }
        guard let passwordText = pwordTxtField.text else {
            return
        }
        
        // Email과 Password 형식 확인 후 login 진행
        
        if isValidEmailAddress(email: emailText) && isVaildPassword(password: passwordText) {
            let parameters: [String: String] = [
                "password" : passwordText,
                "email" : emailText,
            ]
            Alamofire.AF.request("http://mypepup.com/accounts/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                            (response) in switch response.result {
                            case .success(let JSON):
                                print("Success with JSON: \(JSON)")
                                // 만료되지 않은 token이 저장되어 있을 경우
                                if (UserDefaults.standard.object(forKey: "token") as! String) != nil {
                                    self.successAlert()
                                }
                                else {
                                    let JSONDic = JSON as! NSDictionary
                                    let token_name = "Token "
                                    let token_ = JSONDic.object(forKey: "token") as! String
                                    let token = token_name + token_
                                    print(token)
                                    self.setCurrentLoginToken(token)
                                    self.successAlert()
                                }
                            case .failure(let error):
                                print("Request failed with error: \(error)")
                                self.joinAlert()
                            }
            }
        }
        
        if !isValidEmailAddress(email: emailText) {
            failedAlert(message: "이메일을")
        }
        
        if !isVaildPassword(password: passwordText) {
            failedAlert(message: "패스워드를")
        }
    }
    
    @objc func phoneconfirm() {
        let controller = PhoneConfirmVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func findid() {
        let controller = FindIdVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func findpwd() {
        let controller = FindPwdVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: 그 외 함수
    
    func setCurrentLoginToken(_ struserid: String) {
        UserDefaults.standard.set(struserid, forKey: "token")
    }
    
    func successAlert() {
           let controller = TabBarController()
           self.navigationController?.pushViewController(controller, animated: true)
       }
       
    
    func failedAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: "\(message) 다시 입력해 주세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
   
    func joinAlert() {
        let alertController = UIAlertController(title: nil, message: "입력하신 내용으로 회원가입을 해주세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isVaildPassword(password: String) -> Bool {
        let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func setup() {
        view.backgroundColor = .white
        loginContentView.addSubview(unameTxtField)
        loginContentView.addSubview(pwordTxtField)
        loginContentView.addSubview(btnLogin)
        loginContentView.addSubview(btnSignup)
        loginContentView.addSubview(btnFindID)
        loginContentView.addSubview(btnFindPwd)
        view.addSubview(loginContentView)
        
        loginContentViewLayout()
        unameTxtFieldLayout()
        pwordTxtFieldLayout()
        btnLoginLayout()
        btnSignupLayout()
        btnFindIdLayout()
        btnFindPwdLayout()
    }
    
    // MARK: Set Layout of each view
    
    func loginContentViewLayout() {
        loginContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        loginContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        loginContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        loginContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func unameTxtFieldLayout() {
        unameTxtField.keyboardType = .emailAddress
        unameTxtField.placeholder = "아이디를 입력하세요"
        unameTxtField.topAnchor.constraint(equalTo:loginContentView.topAnchor, constant:100).isActive = true
        unameTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        unameTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        unameTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    func pwordTxtFieldLayout() {
        pwordTxtField.placeholder = "패스워드를 입력하세요"
        pwordTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        pwordTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        pwordTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
        pwordTxtField.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:20).isActive = true
    }
    
    func btnLoginLayout() {
        btnLogin.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        btnLogin.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        btnLogin.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnLogin.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:20).isActive = true
    }
    
    func btnSignupLayout() {
        btnSignup.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        btnSignup.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        btnSignup.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnSignup.topAnchor.constraint(equalTo:btnLogin.bottomAnchor, constant:20).isActive = true
    }
    
    func btnFindIdLayout() {
        btnFindID.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        btnFindID.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        btnFindID.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnFindID.topAnchor.constraint(equalTo:btnSignup.bottomAnchor, constant:20).isActive = true
    }

    func btnFindPwdLayout() {
        btnFindPwd.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        btnFindPwd.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        btnFindPwd.heightAnchor.constraint(equalToConstant:50).isActive = true
        btnFindPwd.topAnchor.constraint(equalTo:btnFindID.bottomAnchor, constant:20).isActive = true
    }
}
