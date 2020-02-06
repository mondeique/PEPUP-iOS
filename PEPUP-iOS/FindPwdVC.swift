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
    
    var time = 180
    var timer = Timer()
    var startTimer = false
    
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
        label.font = .systemFont(ofSize: 29)
        label.backgroundColor = .white
        return label
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이메일 아이디 확인 및 본인인증을 통해 비밀번호를 변경하실 수 있습니다."
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
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
        txtField.placeholder = " 이메일을 입력해주세요"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let phonenumTxtField:UITextField = {
        let txtField = UITextField()
        txtField.placeholder = " 전화번호를 입력해주세요"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let btnSendSMS:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("인증번호 받기", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(sendsms), for: .touchUpInside)
        return btn
    }()
    
    private let authnumTxtField:UITextField = {
        let txtField = UITextField()
        txtField.placeholder = " 인증번호를 입력해주세요"
        txtField.backgroundColor = .white
        txtField.borderStyle = .line
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.isEnabled = false
        return txtField
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.text = "03:00"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        return label
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
        btn.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return btn
    }()
    
    // MARK: Button Action Selector
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendsms() {
        guard let phonenum = phonenumTxtField.text else {
            return
        }
        guard let unameTxt = unameTxtField.text else {
            return
        }
        
        if isValidPhonenumber(phonenumber: phonenum) {
            let parameters = [
                "email": unameTxt,
                "phone": phonenum
            ]
            Alamofire.AF.request("\(Config.baseURL)/accounts/reset_password_sms/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                                   (response) in switch response.result {
                                   case .success(let JSON):
                                    print("Success with JSON: \(JSON)")
                                    let response = JSON as! NSDictionary
                                    let code = response.object(forKey: "code") as! Int
                                    if code == 1 || code == -1 {
                                        self.authnumTxtField.isEnabled = true
                                        self.timerStart()
                                    }
                                   case .failure(let error):
                                       print("Request failed with error: \(error)")
                                   }
            }
        }
    }
    
    @objc func reset() {
        guard let unameTxt = unameTxtField.text else {
            return
        }
        guard let phonenum = phonenumTxtField.text else {
            return
        }
        guard let authnum = authnumTxtField.text else {
            return
        }
        let parameters = [
            "email": unameTxt,
            "phone": phonenum,
            "confirm_key": authnum
        ]
        Alamofire.AF.request("\(Config.baseURL)/accounts/reset_password_sms_confirm/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                               (response) in switch response.result {
                               case .success(let JSON):
                                print("Success with JSON: \(JSON)")
                                if (UserDefaults.standard.object(forKey: "token") as! String) != nil {
                                    self.resetpwd()
                                }
                                else {
                                    let JSONDic = JSON as! NSDictionary
                                    let token_name = "Token "
                                    let token_ = JSONDic.object(forKey: "token") as! String
                                    let token = token_name + token_
                                    print(token)
                                    self.setCurrentLoginToken(token)
                                    self.resetpwd()
                                }
                               case .failure(let error):
                                print("Request failed with error: \(error)")
                               }
        }
    }
    
    @objc func timeLimit() {
        if time > 0 {
            time = time - 1
            if time%60 < 10 {
                timerLabel.text = "0\(time/60):0\(time%60)"
            }
            else {
                timerLabel.text = "0\(time/60):\(time%60)"
            }
        }
        else {
            timeLimitStop()
        }
    }
    
    // MARK: 그 외 함수
    
    func setCurrentLoginToken(_ struserid: String) {
        UserDefaults.standard.set(struserid, forKey: "token")
    }
    
    func isValidPhonenumber(phonenumber: String) -> Bool{
        let phonenumRegEx = "[0-1]{3,}+[0-9]{7,}"
        let phonenumTest = NSPredicate(format:"SELF MATCHES %@", phonenumRegEx)
        return phonenumTest.evaluate(with: phonenumber)
    }
    
    func timerStart() {
        if startTimer == false {
            startTimer = true
            timerLimitStart()
        }
    }
    
    func timerLimitStart() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeLimit), userInfo: nil, repeats: true)
    }
    
    func timeLimitStop() {
        startTimer = false
        timer.invalidate()
    }
    
    func resetpwd() {
        let controller = FindPwdResetVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setup() {
        view.backgroundColor = .purple
        findpwdContentView.addSubview(btnBack)
        findpwdContentView.addSubview(resetpwdLabel)
        findpwdContentView.addSubview(explainLabel)
        findpwdContentView.addSubview(emailLabel)
        findpwdContentView.addSubview(unameTxtField)
        findpwdContentView.addSubview(phonenumTxtField)
        findpwdContentView.addSubview(btnSendSMS)
        findpwdContentView.addSubview(authnumTxtField)
        findpwdContentView.addSubview(timerLabel)
        findpwdContentView.addSubview(btnNext)
        view.addSubview(findpwdContentView)

        findpwdContentViewLayout()
        btnBackLayout()
        resetpwdLabelLayout()
        explainLabelLayout()
        emailLabelLayout()
        unameTxtFieldLayout()
        phonenumTxtFieldLayout()
        btnSendSMSLayout()
        authnumTxtFieldLayout()
        timerLabelLayout()
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
        emailLabel.topAnchor.constraint(equalTo:explainLabel.bottomAnchor, constant:40).isActive = true
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
    
    func phonenumTxtFieldLayout() {
        phonenumTxtField.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:36).isActive = true
        phonenumTxtField.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:25).isActive = true
        phonenumTxtField.widthAnchor.constraint(equalToConstant:215).isActive = true
        phonenumTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
    }
    
    func btnSendSMSLayout() {
        btnSendSMS.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:41).isActive = true
        btnSendSMS.leftAnchor.constraint(equalTo:phonenumTxtField.rightAnchor, constant:10).isActive = true
        btnSendSMS.widthAnchor.constraint(equalToConstant:100).isActive = true
        btnSendSMS.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    func authnumTxtFieldLayout() {
        authnumTxtField.topAnchor.constraint(equalTo:phonenumTxtField.bottomAnchor, constant:16).isActive = true
        authnumTxtField.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:25).isActive = true
        authnumTxtField.widthAnchor.constraint(equalToConstant:215).isActive = true
        authnumTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
    }
    
    func timerLabelLayout() {
        timerLabel.topAnchor.constraint(equalTo:btnSendSMS.bottomAnchor, constant:26).isActive = true
        timerLabel.leftAnchor.constraint(equalTo:authnumTxtField.rightAnchor, constant:10).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant:100).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    func btnNextLayout() {
        btnNext.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:44).isActive = true
        btnNext.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:25).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant:325).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant:48).isActive = true
    }

}

