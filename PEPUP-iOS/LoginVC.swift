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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Declare each view programmatically 
    
    private let loginContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 25, y: 104, width: 78, height: 35))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "로그인"
        label.textColor = .black
        label.font = .systemFont(ofSize: 29)
        label.backgroundColor = .white
        return label
    }()
    
    private let unameTxtField:UITextField = {
        let txtField = UITextField(frame: CGRect(x: 25, y: 179, width: 325, height: 44))
        txtField.placeholder = " 아이디 또는 이메일"
        txtField.backgroundColor = .white
//        txtField.layer.cornerRadius = 3.0
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let pwordTxtField:UITextField = {
        let txtField = UITextField(frame: CGRect(x: 25, y: 240, width: 325, height: 44))
        txtField.placeholder = " 비밀번호"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    let btnLogin:UIButton = {
        let btn = UIButton(frame: CGRect(x: 25, y: 312, width: 325, height: 56))
        btn.backgroundColor = .black
        btn.setTitle("Login", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 3
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    
    let btnFindID:UIButton = {
        let btn = UIButton(frame: CGRect(x: 44, y: 398, width: 62, height: 16))
        btn.backgroundColor = .white
        btn.setTitle("아이디찾기", for: .normal)
        btn.setTitleColor(UIColor(rgb: 0x6B6A6E), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(findid), for: .touchUpInside)
        return btn
    }()
    
    private let lineLabel1: UILabel = {
        let label = UILabel(frame: CGRect(x: 127, y: 388, width: 1, height: 35))
        label.backgroundColor = UIColor(rgb: 0x6B6A6E)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnFindPwd:UIButton = {
        let btn = UIButton(frame: CGRect(x: 150, y: 398, width: 78, height: 16))
        btn.backgroundColor = .white
        btn.setTitle("비밀번호 찾기", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(UIColor(rgb: 0x6B6A6E), for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(findpwd), for: .touchUpInside)
        return btn
    }()
    
    private let lineLabel2: UILabel = {
        let label = UILabel(frame: CGRect(x: 250, y: 388, width: 1, height: 35))
        label.backgroundColor = UIColor(rgb: 0x6B6A6E)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnSignup:UIButton = {
        let btn = UIButton(frame: CGRect(x: 273, y: 398, width: 48, height: 16))
        btn.backgroundColor = .white
        btn.setTitle("회원가입", for: .normal)
        btn.setTitleColor(UIColor(rgb: 0x6B6A6E), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(phoneconfirm), for: .touchUpInside)
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
        loginContentView.addSubview(loginLabel)
        loginContentView.addSubview(unameTxtField)
        loginContentView.addSubview(pwordTxtField)
        loginContentView.addSubview(btnLogin)
        loginContentView.addSubview(btnFindID)
        loginContentView.addSubview(lineLabel1)
        loginContentView.addSubview(btnFindPwd)
        loginContentView.addSubview(lineLabel2)
        loginContentView.addSubview(btnSignup)
        view.addSubview(loginContentView)
        
        loginContentViewLayout()
        loginLabelLayout()
        unameTxtFieldLayout()
        pwordTxtFieldLayout()
        btnLoginLayout()
        btnSignupLayout()
        lineLabel1Layout()
        btnFindIdLayout()
        lineLabel2Layout()
        btnFindPwdLayout()
    }
    
    // MARK: Set Layout of each view
    
    func loginContentViewLayout() {
        loginContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        loginContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        loginContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        loginContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func loginLabelLayout() {
        loginLabel.topAnchor.constraint(equalTo:loginContentView.topAnchor, constant:104).isActive = true
        loginLabel.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:25).isActive = true
        loginLabel.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-272).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant:35).isActive = true
    }
    
    func unameTxtFieldLayout() {
        unameTxtField.keyboardType = .emailAddress
        unameTxtField.topAnchor.constraint(equalTo:loginLabel.bottomAnchor, constant:40).isActive = true
        unameTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:25).isActive = true
        unameTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-25).isActive = true
        unameTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
    }
    
    func pwordTxtFieldLayout() {
        pwordTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:25).isActive = true
        pwordTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-25).isActive = true
        pwordTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
        pwordTxtField.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:17).isActive = true
    }
    
    func btnLoginLayout() {
        btnLogin.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:25).isActive = true
        btnLogin.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-25).isActive = true
        btnLogin.heightAnchor.constraint(equalToConstant:56).isActive = true
        btnLogin.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:27).isActive = true
    }
    
    func btnFindIdLayout() {
        btnFindID.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:44).isActive = true
        btnFindID.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-269).isActive = true
        btnFindID.heightAnchor.constraint(equalToConstant:16).isActive = true
        btnFindID.topAnchor.constraint(equalTo:btnLogin.bottomAnchor, constant:30).isActive = true
    }
    
    func lineLabel1Layout() {
        lineLabel1.leftAnchor.constraint(equalTo:btnFindID.rightAnchor, constant:21).isActive = true
        lineLabel1.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-247).isActive = true
        lineLabel1.heightAnchor.constraint(equalToConstant:35).isActive = true
        lineLabel1.topAnchor.constraint(equalTo:btnLogin.bottomAnchor, constant:20).isActive = true
    }
    
    func btnFindPwdLayout() {
        btnFindPwd.leftAnchor.constraint(equalTo:lineLabel1.rightAnchor, constant:22).isActive = true
        btnFindPwd.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-147).isActive = true
        btnFindPwd.heightAnchor.constraint(equalToConstant:16).isActive = true
        btnFindPwd.topAnchor.constraint(equalTo:btnLogin.bottomAnchor, constant:30).isActive = true
    }
    
    func lineLabel2Layout() {
        lineLabel2.leftAnchor.constraint(equalTo:btnFindPwd.rightAnchor, constant:22).isActive = true
        lineLabel2.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-124).isActive = true
        lineLabel2.heightAnchor.constraint(equalToConstant:35).isActive = true
        lineLabel2.topAnchor.constraint(equalTo:btnLogin.bottomAnchor, constant:20).isActive = true
    }
    
    func btnSignupLayout() {
        btnSignup.leftAnchor.constraint(equalTo:lineLabel2.rightAnchor, constant:22).isActive = true
        btnSignup.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-54).isActive = true
        btnSignup.heightAnchor.constraint(equalToConstant:16).isActive = true
        btnSignup.topAnchor.constraint(equalTo:btnLogin.bottomAnchor, constant:30).isActive = true
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
