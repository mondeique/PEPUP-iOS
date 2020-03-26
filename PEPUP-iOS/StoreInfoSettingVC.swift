//
//  StoreInfoSettingVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/26.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class StoreInfoSettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    func setup() {
        
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        self.view.addSubview(navcontentView)
        navcontentView.addSubview(btnBack)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        self.view.addSubview(storeaccountLabel)
        storeaccountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        storeaccountLabel.topAnchor.constraint(equalTo: navcontentView.bottomAnchor, constant: screenHeight/defaultHeight * 40).isActive = true
        storeaccountLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 35).isActive = true
        
        self.view.addSubview(bankLabel)
        bankLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        bankLabel.topAnchor.constraint(equalTo: storeaccountLabel.bottomAnchor, constant: screenHeight/defaultHeight * 48).isActive = true
        bankLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        self.view.addSubview(banktxtView)
        banktxtView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        banktxtView.topAnchor.constraint(equalTo: bankLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        banktxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 325).isActive = true
        banktxtView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        banktxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true
        banktxtView.delegate = self
        
        self.view.addSubview(accountnumLabel)
        accountnumLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        accountnumLabel.topAnchor.constraint(equalTo: banktxtView.bottomAnchor, constant: screenHeight/defaultHeight * 18).isActive = true
        accountnumLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        self.view.addSubview(accountnumtxtView)
        accountnumtxtView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        accountnumtxtView.topAnchor.constraint(equalTo: accountnumLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        accountnumtxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true
        accountnumtxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 325).isActive = true
        accountnumtxtView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accountnumtxtView.delegate = self
        
        self.view.addSubview(accountnameLabel)
        accountnameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        accountnameLabel.topAnchor.constraint(equalTo: accountnumtxtView.bottomAnchor, constant: screenHeight/defaultHeight * 18).isActive = true
        accountnameLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        self.view.addSubview(accountnametxtView)
        accountnametxtView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        accountnametxtView.topAnchor.constraint(equalTo: accountnameLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        accountnametxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true
        accountnametxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 325).isActive = true
        accountnametxtView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accountnametxtView.delegate = self
        
        self.view.addSubview(statusDonebarLabel)
        statusDonebarLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        statusDonebarLabel.topAnchor.constraint(equalTo: accountnametxtView.bottomAnchor, constant: screenHeight/defaultHeight * 138).isActive = true
        statusDonebarLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 2).isActive = true
        statusDonebarLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 108).isActive = true
        
        self.view.addSubview(statusNotDonebarLabel)
        statusNotDonebarLabel.leftAnchor.constraint(equalTo: statusDonebarLabel.rightAnchor).isActive = true
        statusNotDonebarLabel.topAnchor.constraint(equalTo: accountnametxtView.bottomAnchor, constant: screenHeight/defaultHeight * 138).isActive = true
        statusNotDonebarLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 2).isActive = true
        statusNotDonebarLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 216).isActive = true
        
        self.view.addSubview(btnNext)
        btnNext.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 25).isActive = true
        btnNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: screenHeight/defaultHeight * -24).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 48).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 325).isActive = true
        btnNext.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
    
    @objc func back() {
        let nextVC = TabBarController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func gonext() {
        let nextVC = StoreInfoSettingSecondVC()
        nextVC.bankId = Int(banktxtView.text)
        nextVC.accountnum = accountnumtxtView.text
        nextVC.accountname = accountnametxtView.text
        self.navigationController?.pushViewController(nextVC, animated: true)
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
    
    let storeaccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 29)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "스토어 계좌 정보"
        label.backgroundColor = .white
        return label
    }()
    
    let bankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .left
        label.text = "은행"
        return label
    }()
    
    let banktxtView : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "은행을 선택해 주세요"
        return txtView
    }()
    
    let accountnumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "계좌 번호"
        label.textAlignment = .left
        return label
    }()
    
    let accountnumtxtView : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "계좌번호를 입력해 주세요"
        return txtView
    }()
    
    let accountnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "예금주"
        label.textAlignment = .left
        return label
    }()
    
    let accountnametxtView : UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "예금주를 입력해 주세요"
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
        btn.addTarget(self, action: #selector(gonext), for: .touchUpInside)
        return btn
    }()

}

extension StoreInfoSettingVC: UITextViewDelegate {

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
        if banktxtView.text == "은행을 선택해 주세요" {
            banktxtView.text = ""
            banktxtView.textColor = UIColor.black
        }
        else if banktxtView.text == "" {
            banktxtView.text = "은행을 선택해 주세요"
            banktxtView.textColor = UIColor(rgb: 0xEBEBF6)
        }
        if accountnumtxtView.text == "계좌번호를 입력해 주세요" {
            accountnumtxtView.text = ""
            accountnumtxtView.textColor = UIColor.black
        }
        else if accountnumtxtView.text == "" {
            accountnumtxtView.text = "계좌번호를 입력해 주세요"
            accountnumtxtView.textColor = UIColor(rgb: 0xEBEBF6)
        }
        if accountnametxtView.text == "예금주를 입력해 주세요" {
            accountnametxtView.text = ""
            accountnametxtView.textColor = UIColor.black
        }
        else if accountnametxtView.text == "" {
            accountnametxtView.text = "예금주를 입력해 주세요"
            accountnametxtView.textColor = UIColor(rgb: 0xEBEBF6)
        }
    }
}
