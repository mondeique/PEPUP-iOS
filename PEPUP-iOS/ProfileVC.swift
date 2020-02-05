//
//  ProfileVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/04.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Declare each view programmatically
    
    private let profileContentView: UIView = {
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
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "프로필"
        label.textColor = .black
        label.font = .systemFont(ofSize: 29)
        label.backgroundColor = .white
        return label
    }()
    
    // TODO: - imageView 뭐 들어가야하는지 알아보기
    
//    private let profileImage:UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = .white
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    let btnLater:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("다음에 할래요", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(signup), for: .touchUpInside)
        return btn
        }()
    
    let btnCheck:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("확인", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(signup), for: .touchUpInside)
        return btn
    }()

    // MARK: 각 Button에 따른 selector action 설정
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signup() {
//        guard let profile = profileImage.image else {
//            return
//        }
//        let parameters: [String: [UIImage]?] = [
//            "thumbnail" : profile.images
//        ]
        Alamofire.AF.request("http://mypepup.com/accounts/reset_password/", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
                        (response) in switch response.result {
                        case .success(let JSON):
                            print("Success with JSON: \(JSON)")
                            self.successAlert()
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                        }
        }
    }
    
    func successAlert() {
        let controller = TabBarController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setup() {
        view.backgroundColor = .white
//        profileContentView.addSubview(profileImage)
        profileContentView.addSubview(btnBack)
        profileContentView.addSubview(profileLabel)
        profileContentView.addSubview(btnCheck)
        profileContentView.addSubview(btnLater)
        view.addSubview(profileContentView)
        
        profileContentViewLayout()
        btnBackLayout()
//        profileImageLayout()
        profileLabelLayout()
//        btnLaterLayout()
//        btnCheckLayout()
    }
    
    // MARK: Set Layout of each view
    
    func profileContentViewLayout() {
        profileContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        profileContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        profileContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        profileContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func btnBackLayout() {
        btnBack.topAnchor.constraint(equalTo:profileContentView.topAnchor, constant:34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:18).isActive = true
    }
    
    func profileLabelLayout() {
        profileLabel.topAnchor.constraint(equalTo:profileContentView.topAnchor, constant:104).isActive = true
        profileLabel.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:25).isActive = true
        profileLabel.widthAnchor.constraint(equalToConstant:78).isActive = true
        profileLabel.heightAnchor.constraint(equalToConstant:35).isActive = true
    }
    
//    func profileImageLayout() {
//        profileImage.topAnchor.constraint(equalTo:profileContentView.topAnchor, constant:100).isActive = true
//        profileImage.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:20).isActive = true
//        profileImage.rightAnchor.constraint(equalTo:profileContentView.rightAnchor, constant:-20).isActive = true
//        profileImage.heightAnchor.constraint(equalToConstant:50).isActive = true
//    }
    
    func btnLaterLayout() {
        btnLater.topAnchor.constraint(equalTo:profileLabel.bottomAnchor, constant:448).isActive = true
        btnLater.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:18).isActive = true
        btnLater.widthAnchor.constraint(equalToConstant:339).isActive = true
        btnLater.heightAnchor.constraint(equalToConstant:56).isActive = true
    }
    
    func btnCheckLayout() {
        btnCheck.topAnchor.constraint(equalTo:profileLabel.bottomAnchor, constant:448).isActive = true
        btnCheck.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:18).isActive = true
        btnCheck.widthAnchor.constraint(equalToConstant:339).isActive = true
        btnCheck.heightAnchor.constraint(equalToConstant:56).isActive = true
    }
    
    
    
//    extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//            var newImage: UIImage? = nil
//
//            if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage { // 수정된 이미지가 있을 경우
//                newImage = possibleImage
//            } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage { // 오리지널 이미지가 있을 경우
//                newImage = possibleImage
//            }
//
//            self.profileImage.image = newImage // 받아온 이미지를 이미지 뷰에 넣어준다.
//
//            picker.dismiss(animated: true) // 그리고 picker를 닫아준다.
//    }
}
