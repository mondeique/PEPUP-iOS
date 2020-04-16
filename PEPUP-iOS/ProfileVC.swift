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
    
    let picker = UIImagePickerController()
    var imageData: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setup()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
    
    private let btnProfileImage:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "default_profile"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(setimage), for: .touchUpInside)
        return btn
    }()
    
    let btnCheck:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("다음에 할래요", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.tintColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(changeprofile), for: .touchUpInside)
        return btn
    }()

    // MARK: 각 Button에 따른 selector action 설정
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setimage() {
        let alert =  UIAlertController(title: "프로필 사진", message: nil, preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: "라이브러리에서 선택", style: .default) { (action) in self.openLibrary()}
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera()}
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func changeprofile() {
        let url = "\(Config.baseURL)/accounts/profile/"
        if self.imageData != nil {
            if let upload_image = self.imageData.jpegData(compressionQuality: 1){
                AF.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(upload_image, withName: "thumbnail_img", fileName: "image.jpeg", mimeType: "image/jpeg")
                }, to: url, method: .post, headers: ["Authorization": UserDefaults.standard.object(forKey: "token") as! String]).responseData { (response) in
                    debugPrint("RESPONSE: \(response)")
                    self.successAlert()
                    self.successsignupAlert()
                }
            }
        }
    }
    
    func successsignupAlert() {
        let alertController = UIAlertController(title: nil, message: "회원가입이 완료되었습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func successAlert() {
        let controller = LoginVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    func openCamera(){
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
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
        profileContentView.addSubview(btnBack)
        profileContentView.addSubview(profileLabel)
        profileContentView.addSubview(btnProfileImage)
        profileContentView.addSubview(btnCheck)
        view.addSubview(profileContentView)
        
        profileContentViewLayout()
        btnBackLayout()
        btnProfileImageLayout()
        profileLabelLayout()
        btnCheckLayout()
    }
    
    // MARK: Set Layout of each view
    
    func profileContentViewLayout() {
        profileContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        profileContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        profileContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        profileContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func btnBackLayout() {
        btnBack.topAnchor.constraint(equalTo:profileContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 34).isActive = true
        btnBack.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:(navigationController?.navigationBar.frame.height)!).isActive = true
    }
    
    func profileLabelLayout() {
        profileLabel.topAnchor.constraint(equalTo:profileContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 104).isActive = true
        profileLabel.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 25).isActive = true
        profileLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 78).isActive = true
        profileLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 35).isActive = true
    }
    
    func btnProfileImageLayout() {
        btnProfileImage.topAnchor.constraint(equalTo:profileLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 124).isActive = true
//        btnProfileImage.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 120).isActive = true
        btnProfileImage.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 120).isActive = true
        btnProfileImage.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 120).isActive = true
        btnProfileImage.centerXAnchor.constraint(equalTo: profileContentView.centerXAnchor).isActive = true
    }
    
    func btnCheckLayout() {
        btnCheck.topAnchor.constraint(equalTo:btnProfileImage.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 204).isActive = true
        btnCheck.leftAnchor.constraint(equalTo:profileContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        btnCheck.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 339).isActive = true
        btnCheck.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 56).isActive = true
        btnCheck.centerXAnchor.constraint(equalTo: profileContentView.centerXAnchor).isActive = true
    }
}

extension ProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: false) {
                self.imageData = image
                self.btnProfileImage.setImage(image, for: .normal)
                self.btnProfileImage.layer.cornerRadius = UIScreen.main.bounds.width/375 * 60
                self.btnProfileImage.layer.borderColor = UIColor.clear.cgColor
                self.btnProfileImage.layer.borderWidth = 1
                self.btnProfileImage.layer.masksToBounds = false
                self.btnProfileImage.clipsToBounds = true
                if self.btnProfileImage.currentImage == UIImage(named: "default_profile") {
                    self.btnCheck.setTitle("다음에 할래요", for: .normal)
                }
                else {
                    self.btnCheck.setTitle("확인", for: .normal)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
