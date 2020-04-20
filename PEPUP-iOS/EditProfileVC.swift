//
//  EditProfileVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/04/16.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    
    let picker = UIImagePickerController()
    var storeInfoDatas : NSDictionary!
    var imageData : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        picker.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
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
        navcontentView.addSubview(sellLabel)
        navcontentView.addSubview(btnNext)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        sellLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        sellLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        btnNext.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        btnNext.rightAnchor.constraint(equalTo: navcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        
        self.view.addSubview(profileImage)
        self.view.addSubview(btnProfileImage)
        self.view.addSubview(nicknameLabel)
        self.view.addSubview(nicknameTxtView)
        self.view.addSubview(storedetailLabel)
        self.view.addSubview(storedetailTxtView)
        self.view.addSubview(storedetailcountLabel)
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: navcontentView.bottomAnchor, constant: screenHeight/defaultHeight * 40).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 96).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 96).isActive = true
        
        btnProfileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnProfileImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
//        btnProfileImage.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 96).isActive = true
        btnProfileImage.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        nicknameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        nicknameLabel.topAnchor.constraint(equalTo: btnProfileImage.bottomAnchor, constant: screenHeight/defaultHeight * 42).isActive = true
//        nicknameLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 96).isActive = true
        nicknameLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        nicknameTxtView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        nicknameTxtView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        nicknameTxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        nicknameTxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true
        nicknameTxtView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        storedetailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        storedetailLabel.topAnchor.constraint(equalTo: nicknameTxtView.bottomAnchor, constant: screenHeight/defaultHeight * 32).isActive = true
//        storedetailLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 96).isActive = true
        storedetailLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        storedetailTxtView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        storedetailTxtView.topAnchor.constraint(equalTo: storedetailLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        storedetailTxtView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        storedetailTxtView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 100).isActive = true
        storedetailTxtView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        storedetailTxtView.delegate = self
        
        storedetailcountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        storedetailcountLabel.topAnchor.constraint(equalTo: storedetailTxtView.bottomAnchor, constant: screenHeight/defaultHeight * 4).isActive = true
//        storedetailcountLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 96).isActive = true
        storedetailcountLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 19).isActive = true
        
    }
    
    func getData() {
        let pk : Int = UserDefaults.standard.object(forKey: "pk") as! Int
        Alamofire.AF.request("\(Config.baseURL)/api/profile/" + String(pk) + "/" , method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                self.storeInfoDatas = response
                self.setinfo()
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let changedText = currentText.replacingCharacters(in: stringRange, with: text)

        return changedText.count <= 40
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        storedetailcountLabel.text = String(count) + "/40"
    }
    
    func setinfo() {
        if let imageUrlString = storeInfoDatas.object(forKey: "profile") as? String {
            let imageUrl:NSURL = NSURL(string: imageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let image = UIImage(data: imageData as Data)
            profileImage.setImage(image, for: .normal)
            profileImage.layer.cornerRadius = profileImage.frame.height / 2
            profileImage.layer.borderColor = UIColor.clear.cgColor
            profileImage.layer.borderWidth = 1
            profileImage.layer.masksToBounds = false
            profileImage.clipsToBounds = true
        }
        let nickname = storeInfoDatas.object(forKey: "nickname") as! String
        nicknameTxtView.text = nickname
        if let introduce = storeInfoDatas.object(forKey: "introduce") as? String {
            storedetailTxtView.text = introduce
        }
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
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    func openCamera(){
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: false) {
                self.imageData = image
                self.profileImage.setImage(image, for: .normal)
                self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
                self.profileImage.layer.borderColor = UIColor.clear.cgColor
                self.profileImage.layer.borderWidth = 1
                self.profileImage.layer.masksToBounds = false
                self.profileImage.clipsToBounds = true
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func changeprofileAlert() {
        let alertController = UIAlertController(title: nil, message: "회원정보가 변경되었습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            let nextVC = MyStoreVC()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ok() {
        let pk = UserDefaults.standard.object(forKey: "pk") as! Int
        let url = "\(Config.baseURL)/api/profile/" + String(pk) + "/"
        let nickname = nicknameTxtView.text
        let introduce = storedetailTxtView.text
        if self.imageData != nil {
            if let upload_image = self.imageData.jpegData(compressionQuality: 0.8){
                let parameters = [
                    "nickname" : nickname,
                    "introduce" : introduce
                ] as! [String: String]
                showSpinner(onView: self.view)
                AF.upload(multipartFormData: { (multipartFormData) in
                    for(key,value) in parameters{
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    multipartFormData.append(upload_image, withName: "profile_img", fileName: "image.jpeg", mimeType: "image/jpeg")
                }, to: url, method: .put, headers: ["Authorization": UserDefaults.standard.object(forKey: "token") as! String]).responseData { (response) in
                    debugPrint("RESPONSE: \(response)")
                    self.changeprofileAlert()
                    self.removeSpinner()
                }
            }
        }
        else {
            let parameters = [
                "nickname" : nickname,
                "introduce" : introduce
            ] as! [String: String]
            showSpinner(onView: self.view)
            AF.upload(multipartFormData: { (multipartFormData) in
                for(key,value) in parameters{
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: url, method: .put, headers: ["Authorization": UserDefaults.standard.object(forKey: "token") as! String]).responseData { (response) in
                debugPrint("RESPONSE: \(response)")
                self.changeprofileAlert()
                self.removeSpinner()
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
    
    let sellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.text = "프로필 수정하기"
        label.textAlignment = .center
        return label
    }()
    
    let btnNext: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "OK"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(ok), for: .touchUpInside)
        return btn
    }()
    
    let profileImage: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(setimage), for: .touchUpInside)
        return btn
    }()
    
    let btnProfileImage:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitle("프로필 사진 바꾸기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(setimage), for: .touchUpInside)
        return btn
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "닉네임"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        return label
    }()
    
    let nicknameTxtView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 3
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.textColor = .black
        textView.isEditable = false
        return textView
    }()
    
    let storedetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "스토어 설명"
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .left
        return label
    }()
    
    let storedetailTxtView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 3
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.textColor = .black
        return textView
    }()
    
    let storedetailcountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()

}
