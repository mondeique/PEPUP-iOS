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

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Declare each view programmatically 
    
    private let findIdContentView: UIView = {
               let view = UIView()
               view.translatesAutoresizingMaskIntoConstraints = false
               view.backgroundColor = .gray
               return view
           }()

   private let phonenumTxtField:UITextField = {
       let txtField = UITextField()
       txtField.backgroundColor = .white
       txtField.borderStyle = .roundedRect
       txtField.translatesAutoresizingMaskIntoConstraints = false
       return txtField
   }()

   private let authnumTxtField:UITextField = {
       let txtField = UITextField()
       txtField.backgroundColor = .white
       txtField.borderStyle = .roundedRect
       txtField.translatesAutoresizingMaskIntoConstraints = false
       return txtField
   }()
    
   private let btnSendSMS:UIButton = {
       let btn = UIButton(type:.system)
       btn.backgroundColor = .blue
       btn.setTitle("Send SMS", for: .normal)
       btn.tintColor = .white
       btn.layer.cornerRadius = 5
       btn.clipsToBounds = true
       btn.translatesAutoresizingMaskIntoConstraints = false
       btn.addTarget(self, action: #selector(sendsms), for: .touchUpInside)
       return btn
   }()
    
    private let btnConfirm:UIButton = {
          let btn = UIButton(type:.system)
          btn.backgroundColor = .blue
          btn.setTitle("Confirm", for: .normal)
          btn.tintColor = .white
          btn.layer.cornerRadius = 5
          btn.clipsToBounds = true
          btn.translatesAutoresizingMaskIntoConstraints = false
          btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
          return btn
      }()
    
    // TODO: - 무조건 confirm_key 보내줘야함.. FindId FindPwd를 위해서
    
    // MARK: button action selector setting
    
    @objc func sendsms() {
        guard let phonenum = phonenumTxtField.text else {
            return
        }
        
        if isValidPhonenumber(phonenumber: phonenum) {
            let parameters = [
                "phone": phonenum
            ]
            Alamofire.AF.request("http://mypepup.com/accounts/confirmsms/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                                   (response) in switch response.result {
                                   case .success(let JSON):
                                       print("Success with JSON: \(JSON)")
//                                       let response = JSON as! NSDictionary
//                                       let Id = response.object(forKey: "id") as! String
                                       
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
                                    let Id = "Test@123123.com"
                                    self.successAlert(message: Id)
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

    func successAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: "아이디는 \(message)입니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.login()
        self.present(alertController, animated: true, completion: nil)
    }
    
    func phonefailAlert() {
        let alertController = UIAlertController(title: nil, message: "올바른 번호를 입력하세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func login() {
        let controller = LoginVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setCurrentLoginToken(_ struserid: String) {
        UserDefaults.standard.set(struserid, forKey: "token")
    }
    
    func setup() {
        view.backgroundColor = .purple
        findIdContentView.addSubview(phonenumTxtField)
        findIdContentView.addSubview(authnumTxtField)
        findIdContentView.addSubview(btnSendSMS)
        findIdContentView.addSubview(btnConfirm)
        view.addSubview(findIdContentView)

        findIdContentViewLayout()
        phonenumTxtFieldLayout()
        authnumTxtFieldLayout()
        btnSendSMSLayout()
        btnConfirmLayout()
    }
    
    // MARK: Set Layout of each view
    
    func findIdContentViewLayout() {
        findIdContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        findIdContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        findIdContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        findIdContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func phonenumTxtFieldLayout() {
        phonenumTxtField.keyboardType = .emailAddress
        phonenumTxtField.placeholder = "전화번호를 입력해주세요"
        phonenumTxtField.topAnchor.constraint(equalTo:findIdContentView.topAnchor, constant:100).isActive = true
        phonenumTxtField.leftAnchor.constraint(equalTo:findIdContentView.leftAnchor, constant:20).isActive = true
        phonenumTxtField.rightAnchor.constraint(equalTo:findIdContentView.rightAnchor, constant:-20).isActive = true
        phonenumTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
    }

    func authnumTxtFieldLayout() {
        authnumTxtField.placeholder = "인증번호를 입력해주세요"
        authnumTxtField.leftAnchor.constraint(equalTo:findIdContentView.leftAnchor, constant:20).isActive = true
        authnumTxtField.rightAnchor.constraint(equalTo:findIdContentView.rightAnchor, constant:-20).isActive = true
        authnumTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
        authnumTxtField.topAnchor.constraint(equalTo:phonenumTxtField.bottomAnchor, constant:20).isActive = true
    }
    
    func btnSendSMSLayout() {
        btnSendSMS.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:20).isActive = true
        btnSendSMS.leftAnchor.constraint(equalTo:findIdContentView.leftAnchor, constant:20).isActive = true
        btnSendSMS.rightAnchor.constraint(equalTo:findIdContentView.rightAnchor, constant:-20).isActive = true
        btnSendSMS.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    func btnConfirmLayout() {
        btnConfirm.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:100).isActive = true
        btnConfirm.leftAnchor.constraint(equalTo:findIdContentView.leftAnchor, constant:20).isActive = true
        btnConfirm.rightAnchor.constraint(equalTo:findIdContentView.rightAnchor, constant:-20).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
}
