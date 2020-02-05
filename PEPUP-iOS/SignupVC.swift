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
    
    private let btnBack:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: "btnBack"), for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    
    private let signupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "회원가입"
        label.textColor = .black
        label.font = .systemFont(ofSize: 29)
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
    
    private let emailerrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이메일 형식이 올바르지 않습니다."
        label.textColor = UIColor(rgb: 0xFF0000)
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = .white
        label.isHidden = true
        return label
    }()
    
//    private let emailerrorLabel2: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "이미 사용 중인 이메일 입니다."
//        label.textColor = UIColor(rgb: 0xFF0000)
//        label.font = .systemFont(ofSize: 13)
//        label.backgroundColor = .white
//        label.isHidden = true
//        return label
//    }()

    private let unameTxtField:UITextField = {
        let txtField = UITextField()
        txtField.placeholder = " 아이디 또는 이메일"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.addTarget(self, action: #selector(emailcheck), for: UIControl.Event.editingDidEnd)
        return txtField
    }()
    
//    private let errorImage: UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(named: "errorImage")
//        image.isHidden = true
//        return image
//    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "비밀번호"
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.backgroundColor = .white
        return label
    }()

    private let pwordTxtField:UITextField = {
        let txtField = UITextField()
        txtField.placeholder = " 비밀번호 8자 이상"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.addTarget(self, action: #selector(pwdcheck), for: UIControl.Event.editingDidEnd)
        return txtField
    }()
    
    private let pwordAgainTxtField:UITextField = {
        let txtField = UITextField()
        txtField.placeholder = " 비밀번호를 다시 입력해 주세요"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.addTarget(self, action: #selector(againpwdcheck), for: UIControl.Event.editingDidEnd)
        return txtField
    }()
    
    private let passworderrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0xFF0000)
        label.text = "비밀번호 형식이 올바르지 않습니다."
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = .white
        label.isHidden = true
        return label
    }()
    
    private let passworderrorLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0xFF0000)
        label.text = "비밀번호가 일치하지 않습니다."
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = .white
        label.isHidden = true
        return label
    }()
    
//    private let errorImage2: UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(named: "errorImage")
//        return image
//    }()
//
//    private let errorImage3: UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(named: "errorImage")
//        return image
//    }()
    
    private let btnSignup:UIButton = {
        let btn = UIButton()
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
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func emailcheck() {
        guard let emailText = unameTxtField.text else {
            return
        }
        if !isValidEmailAddress(email: emailText) {
            self.emailerrorLabel.isHidden = false
//            self.errorImage.isHidden = false
        }
        else {
            self.emailerrorLabel.isHidden = true
        }
        // TODO: - 이미 사용 중인 이메일 입니다 처리
    }
    
    @objc func pwdcheck() {
        guard let passwordText = pwordTxtField.text else {
            return
        }
        if !isVaildPassword(password: passwordText) {
            self.passworderrorLabel.isHidden = false
//            self.errorImage2.isHidden = false
        }
        else {
            self.passworderrorLabel.isHidden = true
            self.pwordAgainTxtField.isEnabled = true
        }
    }
    
    @objc func againpwdcheck() {
        self.passworderrorLabel.isHidden = true
        guard let passwordText = pwordTxtField.text else {
            return
        }
        guard let againpasswordText = pwordAgainTxtField.text else {
            return
        }
        if !isSamePassword(password: passwordText, againpassword: againpasswordText) {
            self.passworderrorLabel2.isHidden = false
//            self.errorImage3.isHidden = false
        }
        else {
            self.passworderrorLabel2.isHidden = true
        }
    }
    
    @objc func signup() {
        guard let emailText = unameTxtField.text else {
            return
        }
        guard let passwordText = pwordTxtField.text else {
            return
        }
        guard let passwordagainText = pwordAgainTxtField.text else {
            return
        }
        if isValidEmailAddress(email: emailText) && isVaildPassword(password: passwordText) && isSamePassword(password: passwordText, againpassword: passwordagainText) {
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
    }
    // MARK: 그 외 함수
    
    func successAlert() {
        let controller = NickNameVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
//    func failedAlert(message: String) {
//        let alertController = UIAlertController(title: nil, message: "\(message) 다시 입력해 주세요.", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    func passwordAlert() {
//        let alertController = UIAlertController(title: nil, message: "두 비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
    
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
        view.backgroundColor = .white
        signupContentView.addSubview(btnBack)
        signupContentView.addSubview(signupLabel)
        signupContentView.addSubview(emailLabel)
        signupContentView.addSubview(emailerrorLabel)
//        signupContentView.addSubview(emailerrorLabel2)
        signupContentView.addSubview(unameTxtField)
//        signupContentView.addSubview(errorImage)
        signupContentView.addSubview(passwordLabel)
        signupContentView.addSubview(passworderrorLabel)
        signupContentView.addSubview(passworderrorLabel2)
        signupContentView.addSubview(pwordTxtField)
//        signupContentView.addSubview(errorImage2)
        signupContentView.addSubview(pwordAgainTxtField)
//        signupContentView.addSubview(errorImage3)
        signupContentView.addSubview(btnSignup)
        view.addSubview(signupContentView)

        signupContentViewLayout()
        btnBackLayout()
        signupLabelLayout()
        emailLabelLayout()
        emailerrorLabelLayout()
//        emailerrorLabel2Layout()
        unameTxtFieldLayout()
//        errorImageLayout()
        passwordLabelLayout()
        passworderrorLabelLayout()
        passworderrorLabel2Layout()
        pwordTxtFieldLayout()
//        errorImage2Layout()
        pwordAgainTxtFieldLayout()
//        errorImage3Layout()
        btnSignupLayout()
    }
    
    // MARK: Set Layout of each view
    
    func signupContentViewLayout() {
        signupContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        signupContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        signupContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        signupContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func btnBackLayout() {
        btnBack.topAnchor.constraint(equalTo:signupContentView.topAnchor, constant:34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:18).isActive = true
    }
    
    func signupLabelLayout() {
        signupLabel.topAnchor.constraint(equalTo:signupContentView.topAnchor, constant:104).isActive = true
        signupLabel.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        signupLabel.widthAnchor.constraint(equalToConstant:104).isActive = true
        signupLabel.heightAnchor.constraint(equalToConstant:35).isActive = true
    }
    
    func emailLabelLayout() {
        emailLabel.topAnchor.constraint(equalTo:signupLabel.bottomAnchor, constant:40).isActive = true
        emailLabel.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant:45).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant:20).isActive = true
    }
    
    func emailerrorLabelLayout() {
        emailerrorLabel.topAnchor.constraint(equalTo:signupLabel.bottomAnchor, constant:44).isActive = true
        emailerrorLabel.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-25).isActive = true
        emailerrorLabel.widthAnchor.constraint(equalToConstant: 176).isActive = true
        emailerrorLabel.heightAnchor.constraint(equalToConstant:16).isActive = true
    }
    
//    func emailerrorLabel2Layout() {
//        emailerrorLabel2.topAnchor.constraint(equalTo:signupContentView.bottomAnchor, constant:173).isActive = true
//        emailerrorLabel2.leftAnchor.constraint(equalTo:emailLabel.rightAnchor, constant:123).isActive = true
//        emailerrorLabel2.rightAnchor.constraint(equalTo:signupContentView.rightAnchor, constant:-25).isActive = true
//        emailerrorLabel2.heightAnchor.constraint(equalToConstant:16).isActive = true
//        emailerrorLabel2.widthAnchor.constraint(equalToConstant: 157).isActive = true
//    }
    
    func unameTxtFieldLayout() {
        unameTxtField.keyboardType = .emailAddress
        unameTxtField.topAnchor.constraint(equalTo:emailLabel.bottomAnchor, constant:8).isActive = true
        unameTxtField.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        unameTxtField.widthAnchor.constraint(equalToConstant:325).isActive = true
        unameTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
    }
    
//    func errorImageLayout() {
//        errorImage.topAnchor.constraint(equalTo: unameTxtField.topAnchor, constant: 12).isActive = true
//        errorImage.leftAnchor.constraint(equalTo: unameTxtField.leftAnchor, constant: 295).isActive = true
//        errorImage.widthAnchor.constraint(equalToConstant:20).isActive = true
//        errorImage.heightAnchor.constraint(equalToConstant:20).isActive = true
//    }

    func passwordLabelLayout() {
        passwordLabel.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:40).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant:60).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant:20).isActive = true
    }
    
    func passworderrorLabelLayout() {
        passworderrorLabel.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:44).isActive = true
        passworderrorLabel.leftAnchor.constraint(equalTo:passwordLabel.rightAnchor, constant:77).isActive = true
        passworderrorLabel.widthAnchor.constraint(equalToConstant: 188).isActive = true
        passworderrorLabel.heightAnchor.constraint(equalToConstant:16).isActive = true
    }
    
    func passworderrorLabel2Layout() {
        passworderrorLabel2.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:44).isActive = true
        passworderrorLabel2.leftAnchor.constraint(equalTo:passwordLabel.rightAnchor, constant:104).isActive = true
        passworderrorLabel2.widthAnchor.constraint(equalToConstant:161).isActive = true
        passworderrorLabel2.heightAnchor.constraint(equalToConstant:16).isActive = true
    }
    
    func pwordTxtFieldLayout() {
        pwordTxtField.topAnchor.constraint(equalTo:passwordLabel.bottomAnchor, constant:8).isActive = true
        pwordTxtField.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        pwordTxtField.widthAnchor.constraint(equalToConstant:325).isActive = true
        pwordTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
    }
    
//    func errorImage2Layout() {
//        errorImage2.topAnchor.constraint(equalTo: pwordTxtField.topAnchor, constant: 12).isActive = true
//        errorImage2.leftAnchor.constraint(equalTo: pwordTxtField.leftAnchor, constant: 295).isActive = true
//        errorImage2.widthAnchor.constraint(equalToConstant:20).isActive = true
//        errorImage2.heightAnchor.constraint(equalToConstant:20).isActive = true
//    }
    
    func pwordAgainTxtFieldLayout() {
        pwordAgainTxtField.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:8).isActive = true
        pwordAgainTxtField.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        pwordAgainTxtField.widthAnchor.constraint(equalToConstant:325).isActive = true
        pwordAgainTxtField.heightAnchor.constraint(equalToConstant:45).isActive = true
    }
    
//    func errorImage3Layout() {
//        errorImage3.topAnchor.constraint(equalTo: pwordAgainTxtField.topAnchor, constant: 12).isActive = true
//        errorImage3.leftAnchor.constraint(equalTo: pwordAgainTxtField.leftAnchor, constant: 295).isActive = true
//        errorImage3.widthAnchor.constraint(equalToConstant:20).isActive = true
//        errorImage3.heightAnchor.constraint(equalToConstant:20).isActive = true
//    }

    func btnSignupLayout() {
        btnSignup.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:160).isActive = true
        btnSignup.leftAnchor.constraint(equalTo:signupContentView.leftAnchor, constant:25).isActive = true
        btnSignup.widthAnchor.constraint(equalToConstant:325).isActive = true
        btnSignup.heightAnchor.constraint(equalToConstant:56).isActive = true
    }
}
