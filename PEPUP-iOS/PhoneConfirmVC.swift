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
        // Do any additional setup after loading the view.
    }
    
    private let loginContentView: UIView = {
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
    
    @objc func sendsms() {
        guard let phonenum = phonenumTxtField.text else {
            return
        }
        
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
                               case .failure(let error):
                                   print("Request failed with error: \(error)")
                               }
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
            self.login()
        case .failure(let error):
            print("Request failed with error: \(error)")
        }
        }
    }
    
    func login() {
        let controller = SignupVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func setCurrentLoginToken(_ struserid: String) {
        UserDefaults.standard.set(struserid, forKey: "token")
    }
    
    func setup() {
        view.backgroundColor = .purple
        loginContentView.addSubview(phonenumTxtField)
        loginContentView.addSubview(authnumTxtField)
        loginContentView.addSubview(btnSendSMS)
        loginContentView.addSubview(btnConfirm)
        view.addSubview(loginContentView)

        loginContentViewLayout()
        phonenumTxtFieldLayout()
        authnumTxtFieldLayout()
        btnSendSMSLayout()
        btnConfirmLayout()
    }
    //
    func loginContentViewLayout() {
        loginContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        loginContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        loginContentView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        loginContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func phonenumTxtFieldLayout() {
        phonenumTxtField.keyboardType = .emailAddress
        phonenumTxtField.placeholder = "전화번호를 입력해주세요"
        phonenumTxtField.topAnchor.constraint(equalTo:loginContentView.topAnchor, constant:40).isActive = true
        phonenumTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        phonenumTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        phonenumTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
    }

    func authnumTxtFieldLayout() {
        authnumTxtField.placeholder = "인증번호를 입력해주세요"
        authnumTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        authnumTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        authnumTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
        authnumTxtField.topAnchor.constraint(equalTo:phonenumTxtField.bottomAnchor, constant:20).isActive = true
    }
    
    func btnSendSMSLayout() {
        btnSendSMS.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:20).isActive = true
        btnSendSMS.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        btnSendSMS.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        btnSendSMS.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    func btnConfirmLayout() {
        btnConfirm.topAnchor.constraint(equalTo:authnumTxtField.bottomAnchor, constant:100).isActive = true
        btnConfirm.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        btnConfirm.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
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
