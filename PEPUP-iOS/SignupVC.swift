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
        btn.addTarget(self, action: #selector(phoneconfirm), for: .touchUpInside)
        return btn
    }()
        
    @objc func phoneconfirm() {
        guard let emailText = unameTxtField.text else {
            return
        }
        guard let passwordText = pwordTxtField.text else {
            return
        }
        if isValidEmailAddress(email: emailText) && isVaildPassword(password: passwordText) {
            let parameters: [String: String] = [
                "password" : passwordText,
                "email" : emailText,
            ]
            Alamofire.AF.request("http://mypepup.com/accounts/signup/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                        (response) in switch response.result {
                        case .success(let JSON):
                            print("Success with JSON: \(JSON)")
//                            let JSONDic = JSON as! NSDictionary
//                            let token_name = "Token "
//                            let token_ = JSONDic.object(forKey: "token") as! String
//                            let token = token_name + token_
//                            self.setCurrentLoginToken(token)
//                            self.successAlert()
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                        }
                                        }
        
        
    //            if emailText == "test@test.com" && passwordText == "abc123123" {
    //                print("Good!")
    //            } else {
    //                joinAlert()
    //            }
            }

            if !isValidEmailAddress(email: emailText) {
                failedAlert(message: "이메일을")
            }

            if !isVaildPassword(password: passwordText) {
                failedAlert(message: "패스워드를")
            }
        }

        func failedAlert(message: String) {
            let alertController = UIAlertController(title: nil, message: "\(message) 다시 입력해 주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }

        func successAlert() {
            let controller = PhoneConfirmVC()
            self.navigationController?.pushViewController(controller, animated: true)
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
            view.backgroundColor = .red
            loginContentView.addSubview(unameTxtField)
            loginContentView.addSubview(pwordTxtField)
            loginContentView.addSubview(pwordAgainTxtField)
            loginContentView.addSubview(btnSignup)
            view.addSubview(loginContentView)

            loginContentViewLayout()
            unameTxtFieldLayout()
            pwordTxtFieldLayout()
            pwordAgainTxtFieldLayout()
            btnSignupLayout()
        }
//
        func loginContentViewLayout() {
            loginContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
            loginContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
            loginContentView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
            loginContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }

        func unameTxtFieldLayout() {
            unameTxtField.keyboardType = .emailAddress
            unameTxtField.placeholder = "아이디를 입력하세요"
            unameTxtField.topAnchor.constraint(equalTo:loginContentView.topAnchor, constant:20).isActive = true
            unameTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
            unameTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
            unameTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
        }

        func pwordTxtFieldLayout() {
            pwordTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
            pwordTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
            pwordTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
            pwordTxtField.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:20).isActive = true
        }
    
        func pwordAgainTxtFieldLayout() {
            pwordAgainTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
            pwordAgainTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
            pwordAgainTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
            pwordAgainTxtField.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:20).isActive = true
        }

        func btnSignupLayout() {
            btnSignup.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:100).isActive = true
            btnSignup.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
            btnSignup.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
            btnSignup.heightAnchor.constraint(equalToConstant:50).isActive = true
        }
}
