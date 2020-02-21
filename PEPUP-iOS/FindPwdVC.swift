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
    
    private let btnBack: UIButton = {
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
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이메일 아이디 확인 및 본인인증을 통해 비밀번호를 변경하실 수 있습니다."
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = UIColor(rgb: 0x6B6A6E)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.backgroundColor = .white
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아이디"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.backgroundColor = .white
        return label
    }()
    
    private let unameTxtField: TextField = {
        let txtField = TextField()
        txtField.placeholder = " 이메일을 입력해주세요"
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 3
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let phonenumTxtField: TextField = {
        let txtField = TextField()
        txtField.placeholder = " 전화번호를 입력해주세요"
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 3
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let btnSendSMS: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("인증번호 받기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(sendsms), for: .touchUpInside)
        return btn
    }()
    
    private let authnumTxtField: TextField = {
        let txtField = TextField()
        txtField.placeholder = " 인증번호를 입력해주세요"
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 3
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
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.text = "03:00"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private let btnNext: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("다음", for: .normal)
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
                if code == 1 {
                    self.sendsmsAlert()
                    self.authnumTxtField.isEnabled = true
                    self.timerStart()
                }
                else if code == -1 {
                    self.smsAlreadyAlert()
                    self.authnumTxtField.isEnabled = true
                }
                else if code == -2 {
                    self.sessionAlert()
                }
                else if code == -5 {
                    self.nouserAlert()
                }
                else if code == -20 {
                    self.helpmondeAlert()
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
        Alamofire.AF.request("\(Config.baseURL)/accounts/reset_password_sms/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                let code = response.object(forKey: "code") as! Int
                if code == 1 {
                    let JSONDic = JSON as! NSDictionary
                    let token_name = "Token "
                    let token_ = JSONDic.object(forKey: "token") as! String
                    let token = token_name + token_
                    print(token)
                    self.setCurrentLoginToken(token)
                    self.resetpwd()
                }
                else if code == -1 {
                    self.authnumAlert()
                }
                else if code == -2 {
                    self.sessionAlert()
                }
                else if code == -3 {
                    self.smsAlreadyAlert()
                }
                else if code == -5 {
                    self.nouserAlert()
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
    
    // MARK: Alert
    
    func helpmondeAlert() {
        let alertController = UIAlertController(title: nil, message: "몽데이크 CS팀으로 문의해주세요", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sessionAlert() {
        let alertController = UIAlertController(title: nil, message: "세션이 만료되었습니다. 다시 인증번호를 받아주세요", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func nouserAlert() {
        let alertController = UIAlertController(title: nil, message: "유저가 존재하지 않습니다", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendsmsAlert() {
        let alertController = UIAlertController(title: nil, message: "인증번호가 발송되었습니다", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func authnumAlert() {
        let alertController = UIAlertController(title: nil, message: "인증번호가 일치하지 않습니다", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func smsAlreadyAlert() {
        let alertController = UIAlertController(title: nil, message: "인증번호가 이미 발송되었습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
        btnBack.topAnchor.constraint(equalTo:findpwdContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 18).isActive = true
    }
    
    func resetpwdLabelLayout() {
        resetpwdLabel.topAnchor.constraint(equalTo:findpwdContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 104).isActive = true
        resetpwdLabel.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        resetpwdLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 165).isActive = true
        resetpwdLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 35).isActive = true
    }
    
    func explainLabelLayout() {
        explainLabel.topAnchor.constraint(equalTo:resetpwdLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 16).isActive = true
        explainLabel.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        explainLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 235).isActive = true
        explainLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 38).isActive = true
    }
    
    func emailLabelLayout() {
        emailLabel.topAnchor.constraint(equalTo:explainLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 40).isActive = true
        emailLabel.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 45).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 20).isActive = true
    }
    
    func unameTxtFieldLayout() {
        unameTxtField.topAnchor.constraint(equalTo:emailLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 8).isActive = true
        unameTxtField.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        unameTxtField.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 325).isActive = true
        unameTxtField.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 44).isActive = true
    }
    
    func phonenumTxtFieldLayout() {
        phonenumTxtField.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 36).isActive = true
        phonenumTxtField.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        phonenumTxtField.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 215).isActive = true
        phonenumTxtField.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 44).isActive = true
    }
    
    func btnSendSMSLayout() {
        btnSendSMS.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 41).isActive = true
        btnSendSMS.leftAnchor.constraint(equalTo:phonenumTxtField.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        btnSendSMS.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 100).isActive = true
        btnSendSMS.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 34).isActive = true
    }
    
    func authnumTxtFieldLayout() {
        authnumTxtField.topAnchor.constraint(equalTo:phonenumTxtField.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 16).isActive = true
        authnumTxtField.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        authnumTxtField.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 215).isActive = true
        authnumTxtField.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 44).isActive = true
    }
    
    func timerLabelLayout() {
        timerLabel.topAnchor.constraint(equalTo:btnSendSMS.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 26).isActive = true
        timerLabel.leftAnchor.constraint(equalTo:authnumTxtField.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 100).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 34).isActive = true
    }
    
    func btnNextLayout() {
        btnNext.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 44).isActive = true
        btnNext.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 325).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 48).isActive = true
    }

}

