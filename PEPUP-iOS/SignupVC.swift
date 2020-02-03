//
//  SignupVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/31.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class SignupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Declare each view programmatically 
    
    private let signupContentView: UIView = {
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
    
    private let pwordAgainTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let btnSignup:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Signup", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(signup), for: .touchUpInside)
        return btn
    }()
      
    // MARK: Button Action Selector
    
    @objc func signup() {
        guard let emailText = unameTxtField.text else {
            return
        }
        guard let passwordText = pwordTxtField.text else {
            return
        }
        guard let againpasswordText = pwordAgainTxtField.text else {
            return
        }
        
        // 이메일과 패스워드 형식이 맞는지 확인 후 User 정보 바꾸기
        
        if isValidEmailAddress(email: emailText) && isVaildPassword(password: passwordText) {
            
            // 비밀번호 두 개 서로 맞는지 확인
            
            if isSamePassword(password: passwordText, againpassword: againpasswordText) {
                let parameters: [String: String] = [
                    "password" : passwordText,
                    "email" : emailText,
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
            else {
                self.passwordAlert()
            }
        }
        
            if !isValidEmailAddress(email: emailText) {
                failedAlert(message: "이메일을")
            }

            if !isVaildPassword(password: passwordText) {
                failedAlert(message: "패스워드를")
            }
        }
    
    // MARK: 그 외 함수
    
    func successAlert() {
        let controller = TabBarController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func failedAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: "\(message) 다시 입력해 주세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func passwordAlert() {
        let alertController = UIAlertController(title: nil, message: "두 비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
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
    
    func isSamePassword(password: String, againpassword: String) -> Bool{
        if password == againpassword {
            return true
        }
        else {
            return false
        }
    }

    
    func setup() {
        view.backgroundColor = .red
        signupContentView.addSubview(unameTxtField)
        signupContentView.addSubview(pwordTxtField)
        signupContentView.addSubview(pwordAgainTxtField)
        signupContentView.addSubview(btnSignup)
        view.addSubview(signupContentView)

        signupContentViewLayout()
        unameTxtFieldLayout()
        pwordTxtFieldLayout()
        pwordAgainTxtFieldLayout()
        btnSignupLayout()
    }
    
    // MARK: Set Layout of each view
    
    func signupContentViewLayout() {
        signupContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        signupContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        signupContentView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        signupContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func unameTxtFieldLayout() {
        unameTxtField.keyboardType = .emailAddress
        unameTxtField.placeholder = "아이디를 입력하세요"
        unameTxtField.topAnchor.constraint(equalTo:signupContentView.topAnchor, constant:20).isActive = true
        unameTxtField.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:20).isActive = true
        unameTxtField.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-20).isActive = true
        unameTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
    }

    func pwordTxtFieldLayout() {
        pwordTxtField.placeholder = "패스워드를 입력하세요"
        pwordTxtField.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:20).isActive = true
        pwordTxtField.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-20).isActive = true
        pwordTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
        pwordTxtField.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:20).isActive = true
    }

    func pwordAgainTxtFieldLayout() {
        pwordAgainTxtField.placeholder = "패스워드를 다시 입력하세요"
        pwordAgainTxtField.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:20).isActive = true
        pwordAgainTxtField.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-20).isActive = true
        pwordAgainTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
        pwordAgainTxtField.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:20).isActive = true
    }

    func btnSignupLayout() {
        btnSignup.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:100).isActive = true
        btnSignup.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:20).isActive = true
        btnSignup.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-20).isActive = true
        btnSignup.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
}
