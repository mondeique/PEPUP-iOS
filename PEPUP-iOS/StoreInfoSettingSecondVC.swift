//
//  StoreInfoSettingSecondVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/26.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class StoreInfoSettingSecondVC: UIViewController {
    
    var bankId = UserDefaults.standard.object(forKey: "bank_id") as! Int
    var accountnum: String!
    var accountname: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setup() {
        
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIScreen.main.bounds.height/defaultHeight * 20
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        self.view.addSubview(navcontentView)
        navcontentView.addSubview(btnBack)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        self.view.addSubview(storedeliveryLabel)
        storedeliveryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        storedeliveryLabel.topAnchor.constraint(equalTo: navcontentView.bottomAnchor, constant: screenHeight/defaultHeight * 40).isActive = true
        storedeliveryLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 35).isActive = true
        
        self.view.addSubview(origindeliveryLabel)
        origindeliveryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        origindeliveryLabel.topAnchor.constraint(equalTo: storedeliveryLabel.bottomAnchor, constant: screenHeight/defaultHeight * 48).isActive = true
        origindeliveryLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        self.view.addSubview(origindeliverytxtView)
        origindeliverytxtView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        origindeliverytxtView.topAnchor.constraint(equalTo: origindeliveryLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        origindeliverytxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 325).isActive = true
        origindeliverytxtView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        origindeliverytxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true
        origindeliverytxtView.delegate = self
        
        self.view.addSubview(mountaindeliveryLabel)
        mountaindeliveryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        mountaindeliveryLabel.topAnchor.constraint(equalTo: origindeliverytxtView.bottomAnchor, constant: screenHeight/defaultHeight * 18).isActive = true
        mountaindeliveryLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        self.view.addSubview(mountaindeliverytxtView)
        mountaindeliverytxtView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        mountaindeliverytxtView.topAnchor.constraint(equalTo: mountaindeliveryLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        mountaindeliverytxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true
        mountaindeliverytxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 325).isActive = true
        mountaindeliverytxtView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mountaindeliverytxtView.delegate = self
        
        self.view.addSubview(statusDonebarLabel)
        statusDonebarLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        statusDonebarLabel.topAnchor.constraint(equalTo: mountaindeliverytxtView.bottomAnchor, constant: screenHeight/defaultHeight * 228).isActive = true
        statusDonebarLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 2).isActive = true
        statusDonebarLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 216).isActive = true
        
        self.view.addSubview(statusNotDonebarLabel)
        statusNotDonebarLabel.leftAnchor.constraint(equalTo: statusDonebarLabel.rightAnchor).isActive = true
        statusNotDonebarLabel.topAnchor.constraint(equalTo: mountaindeliverytxtView.bottomAnchor, constant: screenHeight/defaultHeight * 228).isActive = true
        statusNotDonebarLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 2).isActive = true
        statusNotDonebarLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 108).isActive = true
        
        self.view.addSubview(btnNext)
        btnNext.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        btnNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: screenHeight/defaultHeight * -24).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 48).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 325).isActive = true
        btnNext.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func complete() {
        let parameters = [
            "bank" : bankId,
            "account" : Int(accountnum)!,
            "account_holder" : accountname!,
            "general" : origindeliverytxtView.text!,
            "mountain" : mountaindeliverytxtView.text!
            ] as [String : Any]
//        Alamofire.AF.request("\(Config.baseURL)/api/delivery-policy/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
//            (response) in switch response.result {
//            case .success(let JSON):
//                print("SUCESS Setting! \(JSON)")
//                let nextVC = SellSelectVC()
//                self.navigationController?.pushViewController(nextVC, animated: true)
//            case .failure(let error):
//                print("Request failed with error: \(error)")
//
//            }
//        }
        Alamofire.AF.request("\(Config.baseURL)/api/delivery-policy/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .response { response in
            if response.response?.statusCode == 201 {
                print("SUCESS!")
                let nextVC = SellSelectVC()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            else if response.response?.statusCode == 400 {
                print("BAD REQUEST!")
            }
            else {
                print("OTHER ERROR!")
            }
        }
    }
    
    let navcontentView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.backgroundColor = .white
       return view
    }()

    let btnBack: UIButton = {
       let btn = UIButton()
       btn.setImage(UIImage(named: "btnBack"), for: .normal)
       btn.translatesAutoresizingMaskIntoConstraints = false
       btn.addTarget(self, action: #selector(back), for: .touchUpInside)
       return btn
    }()
    
    let storedeliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 29)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "스토어 계좌 정보"
        label.backgroundColor = .white
        return label
    }()
    
    let origindeliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "기본 배송비"
        label.textAlignment = .left
        return label
    }()
    
    let origindeliverytxtView : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "배송비를 설정해주세요"
        txtView.keyboardType = .decimalPad
        return txtView
    }()
    
    let mountaindeliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "도서산간지역 배송비"
        label.textAlignment = .left
        return label
    }()
    
    let mountaindeliverytxtView : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "도서산간지역 배송비를 설정해주세요"
        txtView.keyboardType = .decimalPad
        return txtView
    }()
    
    let statusDonebarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 5
        label.backgroundColor = .black
        return label
    }()
    
    let statusNotDonebarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 5
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let btnNext: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("다음", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(complete), for: .touchUpInside)
        return btn
    }()

}

extension StoreInfoSettingSecondVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewSetupView() {
        if origindeliverytxtView.text == "배송비를 설정해주세요" {
            origindeliverytxtView.text = ""
            origindeliverytxtView.textColor = UIColor.black
        }
        else if origindeliverytxtView.text == "" {
            origindeliverytxtView.text = "배송비를 설정해주세요"
            origindeliverytxtView.textColor = UIColor(rgb: 0xEBEBF6)
        }
        if mountaindeliverytxtView.text == "도서산간지역 배송비를 설정해주세요" {
            mountaindeliverytxtView.text = ""
            mountaindeliverytxtView.textColor = UIColor.black
        }
        else if mountaindeliverytxtView.text == "" {
            mountaindeliverytxtView.text = "도서산간지역 배송비를 설정해주세요"
            mountaindeliverytxtView.textColor = UIColor(rgb: 0xEBEBF6)
        }
    }
}

