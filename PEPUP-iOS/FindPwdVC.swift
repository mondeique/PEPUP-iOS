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

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Declare each view programmatically 
    
    private let findpwdContentView: UIView = {
               let view = UIView()
               view.translatesAutoresizingMaskIntoConstraints = false
               view.backgroundColor = .gray
               return view
           }()
    
    private let IdTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
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
    
    // TODO: - 비밀번호 찾기는 아이디까지 같이 확인한 다음 주는 것인가?
    
    // MARK: Button Action Selector
    
    @objc func sendsms() {
        guard let unameTxt = IdTxtField.text else {
            return
        }
        guard let phonenum = phonenumTxtField.text else {
            return
        }
        if isValidPhonenumber(phonenumber: phonenum) {
            let parameters = [
                "username": unameTxt,
                "phone": phonenum
            ]
            Alamofire.AF.request("http://mypepup.com/accounts/confirmsms/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300) .responseJSON {
                                   (response) in switch response.result {
                                   case .success(let JSON):
                                       print("Success with JSON: \(JSON)")
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
                                    let Pwd = "Qwe123123"
                                    self.successAlert(message: Pwd)
                                case .failure(let error):
                                    print("Request failed with error: \(error)")
                                }
        }
    }
    
    // MARK: 그 외 함수
    
    func successAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: "패스워드는 \(message)입니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.login()
        self.present(alertController, animated: true, completion: nil)
    }
    
    func phonefailAlert() {
        let alertController = UIAlertController(title: nil, message: "올바른 번호를 입력하세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidPhonenumber(phonenumber: String) -> Bool{
        let phonenumRegEx = "[0-1]{3,}+[0-9]{7,}"
        let phonenumTest = NSPredicate(format:"SELF MATCHES %@", phonenumRegEx)
        return phonenumTest.evaluate(with: phonenumber)
    }
    
    func login() {
        let controller = LoginVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setup() {
        view.backgroundColor = .purple
        findpwdContentView.addSubview(IdTxtField)
        findpwdContentView.addSubview(phonenumTxtField)
        findpwdContentView.addSubview(authnumTxtField)
        findpwdContentView.addSubview(btnSendSMS)
        findpwdContentView.addSubview(btnConfirm)
        view.addSubview(findpwdContentView)

        findpwdContentViewLayout()
        IdTxtFieldLayout()
        phonenumTxtFieldLayout()
        authnumTxtFieldLayout()
        btnSendSMSLayout()
        btnConfirmLayout()
    }
    
    // MARK: Set Layout of each view
    
    func findpwdContentViewLayout() {
        findpwdContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        findpwdContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        findpwdContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        findpwdContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func IdTxtFieldLayout() {
        IdTxtField.keyboardType = .emailAddress
        IdTxtField.placeholder = "아이디를 입력해주세요"
        IdTxtField.topAnchor.constraint(equalTo:findpwdContentView.topAnchor, constant:100).isActive = true
        IdTxtField.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:20).isActive = true
        IdTxtField.rightAnchor.constraint(equalTo:findpwdContentView.rightAnchor, constant:-20).isActive = true
        IdTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    func phonenumTxtFieldLayout() {
        phonenumTxtField.keyboardType = .emailAddress
        phonenumTxtField.placeholder = "전화번호를 입력해주세요"
        phonenumTxtField.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:20).isActive = true
        phonenumTxtField.rightAnchor.constraint(equalTo:findpwdContentView.rightAnchor, constant:-20).isActive = true
        phonenumTxtField.topAnchor.constraint(equalTo:IdTxtField.bottomAnchor, constant:20).isActive = true
        phonenumTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
    }

    func authnumTxtFieldLayout() {
        authnumTxtField.placeholder = "인증번호를 입력해주세요"
        authnumTxtField.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:20).isActive = true
        authnumTxtField.rightAnchor.constraint(equalTo:findpwdContentView.rightAnchor, constant:-20).isActive = true
        authnumTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
        authnumTxtField.topAnchor.constraint(equalTo:phonenumTxtField.bottomAnchor, constant:20).isActive = true
    }
    
    func btnSendSMSLayout() {
        btnSendSMS.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:20).isActive = true
        btnSendSMS.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:20).isActive = true
        btnSendSMS.rightAnchor.constraint(equalTo:findpwdContentView.rightAnchor, constant:-20).isActive = true
        btnSendSMS.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    func btnConfirmLayout() {
        btnConfirm.topAnchor.constraint(equalTo:btnSendSMS.bottomAnchor, constant:20).isActive = true
        btnConfirm.leftAnchor.constraint(equalTo:findpwdContentView.leftAnchor, constant:20).isActive = true
        btnConfirm.rightAnchor.constraint(equalTo:findpwdContentView.rightAnchor, constant:-20).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant:50).isActive = true
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

