//
//  NickNameVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/04.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class NickNameVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Declare each view programmatically
    
    private let nicknameContentView: UIView = {
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
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "닉네임"
        label.textColor = .black
        label.font = .systemFont(ofSize: 29)
        label.backgroundColor = .white
        return label
    }()
    
    private let nicknameTxtField:UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "닉네임을 입력하세요"
        txtField.backgroundColor = .white
        txtField.borderStyle = .none
        txtField.textAlignment = .center
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let nicknameerrLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이미 사용 중인 닉네임입니다."
        label.textColor = .red
        label.font = .systemFont(ofSize: 13)
        label.isHidden = true
        label.backgroundColor = .white
        return label
    }()
    
    let btnCheck:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("다음", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(update), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 각 Button에 따른 selector action 설정
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func update() {
        guard let nicknameText = nicknameTxtField.text else {
            return
        }
        
        if isValidNickName(nickname: nicknameText) {
//            btnCheck.isEnabled = true
            let parameters: [String: String] = [
                "nickname" : nicknameText
            ]
            Alamofire.AF.request("\(Config.baseURL)/accounts/signup/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                            (response) in switch response.result {
                            case .success(let JSON):
                                print("Success with JSON: \(JSON)")
                                self.changeprofile()
                            case .failure(let error):
                                print("Request failed with error: \(error)")
                            }
            }
        }
        else {
            self.nicknamefailAlert()
        }
    }
    
    func nicknamefailAlert() {
        let alertController = UIAlertController(title: nil, message: "닉네임 형식이) 올바르지 않습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidNickName(nickname: String) -> Bool {
        let nicknameRegEx = "[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ0-9]{1,15}"
        let nicknameTest = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx)
        return nicknameTest.evaluate(with: nickname)
    }
    
    func changeprofile() {
        let controller = ProfileVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setup() {
        view.backgroundColor = .white
        nicknameContentView.addSubview(btnBack)
        nicknameContentView.addSubview(nicknameLabel)
        nicknameContentView.addSubview(nicknameTxtField)
        nicknameContentView.addSubview(nicknameerrLabel)
        nicknameContentView.addSubview(btnCheck)
        view.addSubview(nicknameContentView)
        
        nicknameContentViewLayout()
        btnBackLayout()
        nicknameLabelLayout()
        nicknameTxtFieldLayout()
        nicknameerrLabelLayout()
        btnCheckLayout()
    }
    
    // MARK: Set Layout of each view
    
    func nicknameContentViewLayout() {
        nicknameContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        nicknameContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        nicknameContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        nicknameContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func btnBackLayout() {
        btnBack.topAnchor.constraint(equalTo:nicknameContentView.topAnchor, constant:34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:nicknameContentView.leftAnchor, constant:18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:18).isActive = true
    }
    
    func nicknameLabelLayout() {
        nicknameLabel.topAnchor.constraint(equalTo:nicknameContentView.topAnchor, constant:104).isActive = true
        nicknameLabel.leftAnchor.constraint(equalTo:nicknameContentView.leftAnchor, constant:25).isActive = true
        nicknameLabel.widthAnchor.constraint(equalToConstant:78).isActive = true
        nicknameLabel.heightAnchor.constraint(equalToConstant:35).isActive = true
    }
    
    func nicknameTxtFieldLayout() {
        nicknameTxtField.topAnchor.constraint(equalTo:nicknameLabel.bottomAnchor, constant:185).isActive = true
        nicknameTxtField.leftAnchor.constraint(equalTo:nicknameContentView.leftAnchor, constant:93).isActive = true
        nicknameTxtField.widthAnchor.constraint(equalToConstant:189).isActive = true
        nicknameTxtField.heightAnchor.constraint(equalToConstant:25).isActive = true
    }
    
    func nicknameerrLabelLayout() {
        nicknameerrLabel.topAnchor.constraint(equalTo:nicknameTxtField.bottomAnchor, constant:6).isActive = true
        nicknameerrLabel.leftAnchor.constraint(equalTo:nicknameContentView.leftAnchor, constant:111).isActive = true
        nicknameerrLabel.widthAnchor.constraint(equalToConstant:153).isActive = true
        nicknameerrLabel.heightAnchor.constraint(equalToConstant:16).isActive = true
    }
    
    func btnCheckLayout() {
        btnCheck.topAnchor.constraint(equalTo:nicknameerrLabel.bottomAnchor, constant:216).isActive = true
        btnCheck.leftAnchor.constraint(equalTo:nicknameContentView.leftAnchor, constant:18).isActive = true
        btnCheck.widthAnchor.constraint(equalToConstant:339).isActive = true
        btnCheck.heightAnchor.constraint(equalToConstant:56).isActive = true
    }
}
