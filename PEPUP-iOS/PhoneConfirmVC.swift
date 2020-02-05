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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Declare each view programmatically 
    
    private let phoneConfirmContentView: UIView = {
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

    private let btnConfirm:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("본인인증하기", for: .normal)
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
        btnSendSMS.isEnabled = false
        guard let phonenum = phonenumTxtField.text else {
            return
        }
        
        // 휴대폰 형식이 맞는지 확인 후 User와 Token 생성
        
        if isValidPhonenumber(phonenumber: phonenum) {
            let parameters = [
                "phone": phonenum
            ]
            Alamofire.AF.request("http://mypepup.com/accounts/confirmsms/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                                   (response) in switch response.result {
                                   case .success(let JSON):
                                       print("Success with JSON: \(JSON)")
                                       let JSONDic = JSON as! NSDictionary
                                       let token_name = "Token "
                                       let token_ = JSONDic.object(forKey: "token") as! String
                                       let token = token_name + token_
                                       self.setCurrentLoginToken(token)
                                       self.sendsmsAlert()
                                       self.authnumTxtField.isEnabled = true
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
        guard let token = UserDefaults.standard.object(forKey: "token") else {
                   return
               }
        guard let authnumber = authnumTxtField.text else {
                   return
               }
        let parameters = [
            "confirm_key": authnumber
        ]
        Alamofire.AF.request("http://mypepup.com/accounts/confirmsms/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": token as! String]) .validate(statusCode: 200..<300) .responseJSON {
                                (response) in switch response.result {
                                case .success(let JSON):
                                    print("Success with JSON: \(JSON)")
                                    self.confirmAlert()
                                    
                                case .failure(let error):
                                    print("Request failed with error: \(error)")
                                }
        }
    }
    
    // MARK: 그 외 함수
    
    func isValidPhonenumber(phonenumber: String) -> Bool{
        let phonenumRegEx = "[0-1]{3,}+[0-9]{7,}"
        let phonenumTest = NSPredicate(format:"SELF MATCHES %@", phonenumRegEx)
        return phonenumTest.evaluate(with: phonenumber)
    }
    
    func sendsmsAlert() {
        let alertController = UIAlertController(title: nil, message: "인증번호가 발송되었습니다.", preferredStyle: .alert)
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
        phoneConfirmContentView.addSubview(btnConfirm)
        view.addSubview(phoneConfirmContentView)

        phoneConfirmContentViewLayout()
        btnBackLayout()
        signupLabelLayout()
        phonenumTxtFieldLayout()
        btnSendSMSLayout()
        
        authnumTxtFieldLayout()
        btnConfirmLayout()
    }
    
    // MARK: Set Layout of each view
    
    func phoneConfirmContentViewLayout() {
        phoneConfirmContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        phoneConfirmContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        phoneConfirmContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        phoneConfirmContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func btnBackLayout() {
        btnBack.topAnchor.constraint(equalTo:phoneConfirmContentView.topAnchor, constant:34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:18).isActive = true
    }
    
    func signupLabelLayout() {
        signupLabel.topAnchor.constraint(equalTo:phoneConfirmContentView.topAnchor, constant:104).isActive = true
        signupLabel.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:25).isActive = true
        signupLabel.widthAnchor.constraint(equalToConstant:104).isActive = true
        signupLabel.heightAnchor.constraint(equalToConstant:35).isActive = true
    }
    
    func phonenumTxtFieldLayout() {
        phonenumTxtField.topAnchor.constraint(equalTo:signupLabel.bottomAnchor, constant:68).isActive = true
        phonenumTxtField.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:25).isActive = true
        phonenumTxtField.widthAnchor.constraint(equalToConstant:215).isActive = true
        phonenumTxtField.heightAnchor.constraint(equalToConstant:44).isActive = true
    }

    func btnSendSMSLayout() {
        btnSendSMS.topAnchor.constraint(equalTo:phoneConfirmContentView.topAnchor, constant:212).isActive = true
        btnSendSMS.leftAnchor.constraint(equalTo:phonenumTxtField.rightAnchor, constant:10).isActive = true
        btnSendSMS.widthAnchor.constraint(equalToConstant:100).isActive = true
        btnSendSMS.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    func authnumTxtFieldLayout() {
        authnumTxtField.topAnchor.constraint(equalTo:phonenumTxtField.bottomAnchor, constant:16).isActive = true
        authnumTxtField.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:25).isActive = true
        authnumTxtField.widthAnchor.constraint(equalToConstant:215).isActive = true
        authnumTxtField.heightAnchor.constraint(equalToConstant:45).isActive = true
    }
    
    func btnConfirmLayout() {
        btnConfirm.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:44).isActive = true
        btnConfirm.leftAnchor.constraint(equalTo:phoneConfirmContentView.leftAnchor, constant:25).isActive = true
        btnConfirm.widthAnchor.constraint(equalToConstant:325).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant:48).isActive = true
    }

}
