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
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Declare each view programmatically 
    
    private let signupContentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            return view
        }()
    
    private let signupLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 25, y: 104, width: 104, height: 35))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "회원가입"
        label.textColor = .black
        label.font = .systemFont(ofSize: 29)
        label.backgroundColor = .white
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 25, y: 169, width: 45, height: 20))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이메일"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.backgroundColor = .white
        return label
    }()

    private let unameTxtField:UITextField = {
        let txtField = UITextField(frame: CGRect(x: 25, y: 197, width: 325, height: 45))
        txtField.placeholder = " 이메일을 입력해주세요"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 25, y: 287, width: 60, height: 20))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "비밀번호"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.backgroundColor = .white
        return label
    }()

    private let pwordTxtField:UITextField = {
        let txtField = UITextField(frame: CGRect(x: 25, y: 315, width: 325, height: 45))
        txtField.placeholder = " 비밀번호 8자 이상"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let pwordAgainTxtField:UITextField = {
        let txtField = UITextField(frame: CGRect(x: 25, y: 368, width: 325, height: 45))
        txtField.placeholder = " 비밀번호를 다시 입력해 주세요"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let btnSignup:UIButton = {
        let btn = UIButton(frame: CGRect(x: 25, y: 623, width: 3250, height: 56))
        btn.backgroundColor = .black
        btn.setTitle("가입하기", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.tintColor = .white
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
        let controller = NickNameVC()
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
        signupContentView.addSubview(signupLabel)
        signupContentView.addSubview(emailLabel)
        signupContentView.addSubview(unameTxtField)
        signupContentView.addSubview(passwordLabel)
        signupContentView.addSubview(pwordTxtField)
        signupContentView.addSubview(pwordAgainTxtField)
        signupContentView.addSubview(btnSignup)
        view.addSubview(signupContentView)

        signupContentViewLayout()
        signupLabelLayout()
        emailLabelLayout()
        unameTxtFieldLayout()
        passwordLabelLayout()
        pwordTxtFieldLayout()
        pwordAgainTxtFieldLayout()
        btnSignupLayout()
    }
    
    // MARK: Set Layout of each view
    
    func signupContentViewLayout() {
        signupContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        signupContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        signupContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        signupContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func signupLabelLayout() {
        signupLabel.topAnchor.constraint(equalTo:signupContentView.topAnchor, constant:104).isActive = true
        signupLabel.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        signupLabel.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-246).isActive = true
        signupLabel.heightAnchor.constraint(equalToConstant:35).isActive = true
    }
    
    func emailLabelLayout() {
        emailLabel.topAnchor.constraint(equalTo:signupLabel.bottomAnchor, constant:30).isActive = true
        emailLabel.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        emailLabel.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-305).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant:20).isActive = true
    }
    
    func unameTxtFieldLayout() {
        unameTxtField.keyboardType = .emailAddress
        unameTxtField.topAnchor.constraint(equalTo:emailLabel.bottomAnchor, constant:8).isActive = true
        unameTxtField.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        unameTxtField.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-25).isActive = true
        unameTxtField.heightAnchor.constraint(equalToConstant:45).isActive = true
    }

    func passwordLabelLayout() {
        passwordLabel.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:45).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        passwordLabel.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-290).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant:20).isActive = true
    }
    
    func pwordTxtFieldLayout() {
        pwordTxtField.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        pwordTxtField.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-25).isActive = true
        pwordTxtField.heightAnchor.constraint(equalToConstant:45).isActive = true
        pwordTxtField.topAnchor.constraint(equalTo:passwordLabel.bottomAnchor, constant:8).isActive = true
    }

    func pwordAgainTxtFieldLayout() {
        pwordAgainTxtField.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        pwordAgainTxtField.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-25).isActive = true
        pwordAgainTxtField.heightAnchor.constraint(equalToConstant:45).isActive = true
        pwordAgainTxtField.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:8).isActive = true
    }

    func btnSignupLayout() {
        btnSignup.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:210).isActive = true
        btnSignup.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        btnSignup.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-25).isActive = true
        btnSignup.heightAnchor.constraint(equalToConstant:56).isActive = true
    }
}
