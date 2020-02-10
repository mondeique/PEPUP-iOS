//
//  FindIdVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/03.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class FindIdVC: UIViewController {
    
    var time = 180
    var timer = Timer()
    var startTimer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Declare each view programmatically 
    
    private let findIdContentView: UIView = {
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
    
    private let findidLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.text = "아이디 찾기"
       label.textColor = .black
       label.font = .systemFont(ofSize: 29)
       label.backgroundColor = .white
       return label
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
    
    private let btnConfirm:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("아이디 찾기", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return btn
    }()
    
    // MARK: button action selector setting
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendsms() {
        guard let phonenum = phonenumTxtField.text else {
            return
        }
        if isValidPhonenumber(phonenumber: phonenum) {
            let parameters = [
                "phone": phonenum
            ]
            Alamofire.AF.request("\(Config.baseURL)/accounts/find_email/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                                   (response) in switch response.result {
                                   case .success(let JSON):
                                    print("Success with JSON: \(JSON)")
                                    let response = JSON as! NSDictionary
                                    let code = response.object(forKey: "code") as! Int
                                    if code == 1 {
                                        self.timerStart()
                                        self.authnumTxtField.isEnabled = true
                                        self.sendsmsAlert()
                                    }
                                    else if code == -1 {
                                        self.smsAlreadyAlert()
                                        self.authnumTxtField.isEnabled = true
                                    }
                                    else if code == -2 {
                                        self.sessionAlert()
                                    }
                                    else if code == -3 {
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
        else {
            phonefailAlert()
        }
    }
    
    @objc func confirm() {
        guard let phonenum = phonenumTxtField.text else {
            return
                }
        guard let authnumber = authnumTxtField.text else {
                   return
               }
        let parameters = [
            "phone" : phonenum,
            "confirm_key": authnumber
        ]
        Alamofire.AF.request("\(Config.baseURL)/accounts/find_email/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                                (response) in switch response.result {
                                case .success(let JSON):
                                    print("Success with JSON: \(JSON)")
                                    let response = JSON as! NSDictionary
                                    let code = response.object(forKey: "code") as! Int
                                    if code == 1 {
                                        let email = response.object(forKey: "email") as! String
                                        self.successAlert(message: email)
                                    }
                                    else if code == -1 {
                                        self.authnumAlert()
                                    }
                                    else if code == -2 {
                                        self.sessionAlert()
                                    }
                                    else if code == -3 {
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
    
    func isValidPhonenumber(phonenumber: String) -> Bool{
        let phonenumRegEx = "[0-1]{3,}+[0-9]{7,}"
        let phonenumTest = NSPredicate(format:"SELF MATCHES %@", phonenumRegEx)
        return phonenumTest.evaluate(with: phonenumber)
    }
    
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

    func successAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: "아이디는 \(message)입니다.", preferredStyle: .alert)
        let login = UIAlertAction(title: "로그인", style: .default) {(action) in self.login()}
        let findpwd = UIAlertAction(title: "비밀번호 찾기", style: .default) {(action) in self.findpwd()}
        
        alertController.addAction(login)
        alertController.addAction(findpwd)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func phonefailAlert() {
        let alertController = UIAlertController(title: nil, message: "올바른 번호를 입력하세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
    
    func findpwd() {
        let controller = FindPwdVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func login() {
        let controller = LoginVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setup() {
        view.backgroundColor = .purple
        findIdContentView.addSubview(btnBack)
        findIdContentView.addSubview(findidLabel)
        findIdContentView.addSubview(phonenumTxtField)
        findIdContentView.addSubview(authnumTxtField)
        findIdContentView.addSubview(btnSendSMS)
        findIdContentView.addSubview(timerLabel)
        findIdContentView.addSubview(btnConfirm)
        view.addSubview(findIdContentView)

        findIdContentViewLayout()
        btnBackLayout()
        findidLabelLayout()
        phonenumTxtFieldLayout()
        authnumTxtFieldLayout()
        btnSendSMSLayout()
        timerLabelLayout()
        btnConfirmLayout()
    }
    
    // MARK: Set Layout of each view
    
    func findIdContentViewLayout() {
        findIdContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        findIdContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        findIdContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        findIdContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func btnBackLayout() {
        btnBack.topAnchor.constraint(equalTo:findIdContentView.topAnchor, constant:34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:findIdContentView.leftAnchor, constant:18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:18).isActive = true
    }
    
    func findidLabelLayout() {
        findidLabel.topAnchor.constraint(equalTo:findIdContentView.topAnchor, constant:104).isActive = true
        findidLabel.leftAnchor.constraint(equalTo:findIdContentView.leftAnchor, constant:25).isActive = true
        findidLabel.widthAnchor.constraint(equalToConstant:139).isActive = true
        findidLabel.heightAnchor.constraint(equalToConstant:35).isActive = true
    }
    
    func phonenumTxtFieldLayout() {
        phonenumTxtField.topAnchor.constraint(equalTo:findidLabel.bottomAnchor, constant:68).isActive = true
        phonenumTxtField.leftAnchor.constraint(equalTo:findIdContentView.leftAnchor, constant:25).isActive = true
        phonenumTxtField.widthAnchor.constraint(equalToConstant: 215).isActive = true
        phonenumTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
    }
    
    func btnSendSMSLayout() {
        btnSendSMS.topAnchor.constraint(equalTo:findidLabel.bottomAnchor, constant:73).isActive = true
        btnSendSMS.rightAnchor.constraint(equalTo:findIdContentView.rightAnchor, constant:-25).isActive = true
        btnSendSMS.widthAnchor.constraint(equalToConstant:100).isActive = true
        btnSendSMS.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    func authnumTxtFieldLayout() {
        authnumTxtField.topAnchor.constraint(equalTo:phonenumTxtField.bottomAnchor, constant:16).isActive = true
        authnumTxtField.leftAnchor.constraint(equalTo:findIdContentView.leftAnchor, constant:25).isActive = true
        authnumTxtField.widthAnchor.constraint(equalToConstant:215).isActive = true
        authnumTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
    }
    
    func timerLabelLayout() {
        timerLabel.topAnchor.constraint(equalTo:btnSendSMS.bottomAnchor, constant:26).isActive = true
        timerLabel.leftAnchor.constraint(equalTo:authnumTxtField.rightAnchor, constant:10).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant:100).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant:34).isActive = true
    }

    func btnConfirmLayout() {
        btnConfirm.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:44).isActive = true
        btnConfirm.leftAnchor.constraint(equalTo:findIdContentView.leftAnchor, constant:25).isActive = true
        btnConfirm.widthAnchor.constraint(equalToConstant:325).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant:48).isActive = true
    }
}
