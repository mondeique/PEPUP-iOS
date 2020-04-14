//
//  FindPwdResetVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/06.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class FindPwdResetVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Declare each view programmatically
    
    private let resetpwdContentView: UIView = {
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
    
    private let resetpwdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "비밀번호 변경"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 29)
        label.backgroundColor = .white
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "비밀번호"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.backgroundColor = .white
        return label
    }()

    private let pwordTxtField:TextField = {
        let txtField = TextField()
        txtField.placeholder = " 비밀번호 8자 이상, 특수문자 사용불가"
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 3
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.addTarget(self, action: #selector(pwdcheck), for: UIControl.Event.editingChanged)
        return txtField
    }()
    
    private let pwordAgainTxtField: TextField = {
        let txtField = TextField()
        txtField.placeholder = " 비밀번호를 확인해주세요"
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 3
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.addTarget(self, action: #selector(againpwdcheck), for: UIControl.Event.editingChanged)
        return txtField
    }()
    
    private let passworderrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0xFF0000)
        label.text = "비밀번호 형식이 올바르지 않습니다."
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.backgroundColor = .white
        label.isHidden = true
        return label
    }()
    
    private let passworderrorLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0xFF0000)
        label.text = "비밀번호가 일치하지 않습니다."
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.backgroundColor = .white
        label.isHidden = true
        return label
    }()
    
    private let btnReset:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("비밀번호 변경", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.layer.cornerRadius = 3
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return btn
    }()
    
    // MARK: Button Action Selector
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
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
    
    @objc func reset() {
        guard let passwordText = pwordTxtField.text else {
            return
        }
        guard let passwordagainText = pwordAgainTxtField.text else {
            return
        }
        let token = UserDefaults.standard.object(forKey: "token") as! String
        if isVaildPassword(password: passwordText) && isSamePassword(password: passwordText, againpassword: passwordagainText) {
            let parameters = [
                "password" : passwordText
            ]
            Alamofire.AF.request("\(Config.baseURL)/accounts/reset_password/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": token]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                let code = response.object(forKey: "code") as! Int
                if code == 1 {
                    self.login()
                    self.resetpwdAlert()
                }
                case .failure(let error):
                print("Request failed with error: \(error)")
                }
            }
        }
    }
    
    // MARK: 그 외 함수
    
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
    
    func login() {
        let controller = LoginVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func resetpwdAlert() {
        let alertController = UIAlertController(title: nil, message: "비밀번호가 변경되었습니다", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setup() {
        view.backgroundColor = .purple
        resetpwdContentView.addSubview(btnBack)
        resetpwdContentView.addSubview(resetpwdLabel)
        resetpwdContentView.addSubview(passwordLabel)
        resetpwdContentView.addSubview(pwordTxtField)
        resetpwdContentView.addSubview(pwordAgainTxtField)
        resetpwdContentView.addSubview(passworderrorLabel)
        resetpwdContentView.addSubview(passworderrorLabel2)
        resetpwdContentView.addSubview(btnReset)
        view.addSubview(resetpwdContentView)

        resetpwdContentViewLayout()
        btnBackLayout()
        resetpwdLabelLayout()
        passwordLabelLayout()
        pwordTxtFieldLayout()
        pwordAgainTxtFieldLayout()
        passworderrorLabelLayout()
        passworderrorLabel2Layout()
        btnResetLayout()
    }
    
    // MARK: Set Layout of each view
    
    func resetpwdContentViewLayout() {
        resetpwdContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        resetpwdContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        resetpwdContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        resetpwdContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func btnBackLayout() {
        btnBack.topAnchor.constraint(equalTo:resetpwdContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:resetpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 18).isActive = true
    }
    
    func resetpwdLabelLayout() {
        resetpwdLabel.topAnchor.constraint(equalTo:resetpwdContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 104).isActive = true
        resetpwdLabel.leftAnchor.constraint(equalTo:resetpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        resetpwdLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 165).isActive = true
        resetpwdLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 35).isActive = true
    }
    
    func passwordLabelLayout() {
        passwordLabel.topAnchor.constraint(equalTo:resetpwdLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 40).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo:resetpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 60).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 20).isActive = true
    }
    
    func passworderrorLabelLayout() {
        passworderrorLabel.topAnchor.constraint(equalTo:resetpwdLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 44).isActive = true
        passworderrorLabel.rightAnchor.constraint(equalTo:resetpwdContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -25).isActive = true
        passworderrorLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 188).isActive = true
        passworderrorLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    func passworderrorLabel2Layout() {
        passworderrorLabel2.topAnchor.constraint(equalTo:resetpwdLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 44).isActive = true
        passworderrorLabel2.rightAnchor.constraint(equalTo:resetpwdContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -25).isActive = true
        passworderrorLabel2.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 161).isActive = true
        passworderrorLabel2.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    func pwordTxtFieldLayout() {
        pwordTxtField.topAnchor.constraint(equalTo:passwordLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 8).isActive = true
        pwordTxtField.leftAnchor.constraint(equalTo:resetpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        pwordTxtField.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 325).isActive = true
        pwordTxtField.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 44).isActive = true
    }
    
    func pwordAgainTxtFieldLayout() {
        pwordAgainTxtField.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 8).isActive = true
        pwordAgainTxtField.leftAnchor.constraint(equalTo:resetpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        pwordAgainTxtField.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 325).isActive = true
        pwordAgainTxtField.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 44).isActive = true
    }
    
    func btnResetLayout() {
        btnReset.topAnchor.constraint(equalTo:pwordAgainTxtField.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 52).isActive = true
        btnReset.leftAnchor.constraint(equalTo:resetpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        btnReset.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 325).isActive = true
        btnReset.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 48).isActive = true
    }
    
    
    

}
