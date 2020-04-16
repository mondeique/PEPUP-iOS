//
//  PhoneConfirmVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/31.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class PhoneConfirmVC: UIViewController {
    
    var time = 180
    var timer = Timer()
    var startTimer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Declare each view programmatically 
    
    private let phoneConfirmContentView: UIView = {
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
    
    private let signupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "회원가입"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 29)
        label.backgroundColor = .white
        return label
    }()

    private let phonenumTxtField: TextField = {
        let txtField = TextField()
        txtField.placeholder = " 전화번호를 입력해주세요"
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 3
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.keyboardType = .decimalPad
        txtField.textColor = .black
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
        txtField.layer.borderWidth = 1.0
        txtField.layer.cornerRadius = 3
        txtField.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.isEnabled = false
        txtField.keyboardType = .decimalPad
        txtField.textColor = .black
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

    private let btnConfirm: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("본인인증하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.layer.cornerRadius = 3
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 각 Button에 따른 selector action 설정
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendsms() {
        guard let phonenum = phonenumTxtField.text else {
            return
        }
        
        // 휴대폰 형식이 맞는지 확인 후 User와 Token 생성
        
        if isValidPhonenumber(phonenumber: phonenum) {
            let parameters = [
                "phone": phonenum
            ]
            Alamofire.AF.request("\(Config.baseURL)/accounts/confirmsms/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:  ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    let JSONDic = JSON as! NSDictionary
                    let code = JSONDic.object(forKey: "code") as! Int
                    if code == 1 {
                        let token_name = "Token "
                        let token_ = JSONDic.object(forKey: "token") as! String
                        let token = token_name + token_
                        self.setCurrentLoginToken(token)
                        self.timerStart()
                        self.authnumTxtField.isEnabled = true
                        self.sendsmsAlert()
                    }
                    else if code == 3 {
                        let token_name = "Token "
                        let token_ = JSONDic.object(forKey: "token") as! String
                        let token = token_name + token_
                        self.setCurrentLoginToken(token)
                        self.signup()
                    }
                    else if code == -1 {
                        self.smsAlreadyAlert()
                        self.authnumTxtField.isEnabled = true
                    }
                    else if code == -2 {
                        self.sessionAlert()
                        let token_name = "Token "
                        let token_ = JSONDic.object(forKey: "token") as! String
                        let token = token_name + token_
                        self.setCurrentLoginToken(token)
                        self.timerStart()
                        self.authnumTxtField.isEnabled = true
                    }
                    else if code == -3 {
                        self.login()
                        self.userAlreadyAlert()
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
        let token = UserDefaults.standard.object(forKey: "token") as! String
        guard let authnumber = authnumTxtField.text else {
                   return
               }
        let parameters = [
            "confirm_key": authnumber
        ]
        Alamofire.AF.request("\(Config.baseURL)/accounts/confirmsms/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": token]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                let code = response.object(forKey: "code") as! Int
                if code == 1 {
                    self.confirmAlert()
                }
                else if code == -1 {
                    self.authnumAlert()
                }
                else if code == -2 {
                    self.sessionAlert()
                }
                else if code == -3 {
                    self.signup()
                    self.confirmAlreadyAlert()
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
    
    func sessionAlert() {
        let alertController = UIAlertController(title: nil, message: "세션이 만료되었습니다. 다시 인증번호를 받아주세요", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func helpmondeAlert() {
        let alertController = UIAlertController(title: nil, message: "몽데이크 CS팀으로 문의해주세요", preferredStyle: .alert)
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
    
    func userAlreadyAlert() {
        let alertController = UIAlertController(title: nil, message: "유저가 이미 존재합니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmAlreadyAlert() {
        let alertController = UIAlertController(title: nil, message: "이미 인증되었습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmAlert() {
        let alertController = UIAlertController(title: nil, message: "본인인증이 완료되었습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.signup()
        self.present(alertController, animated: true, completion: nil)
    }
    
    func phonefailAlert() {
        let alertController = UIAlertController(title: nil, message: "올바른 번호를 입력하세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: 그 외 함수
    
    // 휴대폰 번호 형식 mask 씌워서 표현
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXX-XXX-XXXX"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
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
    
    func login() {
        let controller = LoginVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func signup() {
        let controller = SignupVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setCurrentLoginToken(_ struserid: String) {
        UserDefaults.standard.set(struserid, forKey: "token")
    }

    func setup() {
        view.backgroundColor = .white
        phoneConfirmContentView.addSubview(btnBack)
        phoneConfirmContentView.addSubview(signupLabel)
        phoneConfirmContentView.addSubview(phonenumTxtField)
        phoneConfirmContentView.addSubview(btnSendSMS)
        phoneConfirmContentView.addSubview(authnumTxtField)
        phoneConfirmContentView.addSubview(timerLabel)
        phoneConfirmContentView.addSubview(btnConfirm)
        view.addSubview(phoneConfirmContentView)

        phoneConfirmContentViewLayout()
        btnBackLayout()
        signupLabelLayout()
        phonenumTxtFieldLayout()
        timerLabelLayout()
        btnSendSMSLayout()
        authnumTxtFieldLayout()
        btnConfirmLayout()
    }
    
    // MARK: Set Layout of each view
    
    func phoneConfirmContentViewLayout() {
        phoneConfirmContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        phoneConfirmContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        phoneConfirmContentView.heightAnchor.constraint(equalToConstant:view.frame.height).isActive = true
        phoneConfirmContentView.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
    }
    
    func btnBackLayout() {
        btnBack.topAnchor.constraint(equalTo:phoneConfirmContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 18).isActive = true
    }
    
    func signupLabelLayout() {
        signupLabel.topAnchor.constraint(equalTo:phoneConfirmContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 104).isActive = true
        signupLabel.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        signupLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 104).isActive = true
        signupLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 35).isActive = true
    }
    
    func phonenumTxtFieldLayout() {
        phonenumTxtField.topAnchor.constraint(equalTo:signupLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 68).isActive = true
        phonenumTxtField.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        phonenumTxtField.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 215).isActive = true
        phonenumTxtField.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 44).isActive = true
    }

    func btnSendSMSLayout() {
        btnSendSMS.topAnchor.constraint(equalTo:phoneConfirmContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 212).isActive = true
        btnSendSMS.leftAnchor.constraint(equalTo:phonenumTxtField.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        btnSendSMS.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 100).isActive = true
        btnSendSMS.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 34).isActive = true
    }
    
    func authnumTxtFieldLayout() {
        authnumTxtField.topAnchor.constraint(equalTo:phonenumTxtField.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 16).isActive = true
        authnumTxtField.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        authnumTxtField.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 215).isActive = true
        authnumTxtField.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 45).isActive = true
    }
    
    func timerLabelLayout() {
        timerLabel.topAnchor.constraint(equalTo:btnSendSMS.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 26).isActive = true
        timerLabel.leftAnchor.constraint(equalTo:authnumTxtField.rightAnchor, constant:UIScreen.main.bounds.width/375 * 10).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 100).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 34).isActive = true
    }
    
    func btnConfirmLayout() {
        btnConfirm.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 44).isActive = true
        btnConfirm.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        btnConfirm.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 325).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 48).isActive = true
    }

}
