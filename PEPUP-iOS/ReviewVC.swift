//
//  ReviewVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/23.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire
import Cosmos


class ReviewVC: UIViewController {
    
    var purchasedUid = UserDefaults.standard.object(forKey: "purchaseUid") as! Int
    var reviewDatas : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
        getData()
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
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
        navcontentView.addSubview(reviewLabel)
        navcontentView.addSubview(btnNext)
        
        self.view.addSubview(dealthumbnail)
        self.view.addSubview(reviewcontent)
        self.view.addSubview(cosmosView)
        self.view.addSubview(reviewImage)
        self.view.addSubview(reviewTextView)
        self.view.addSubview(countLabel)
        self.view.addSubview(btnWrite)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        reviewLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        reviewLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        btnNext.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        btnNext.rightAnchor.constraint(equalTo: navcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        
        dealthumbnail.topAnchor.constraint(equalTo: navcontentView.bottomAnchor, constant: screenHeight/defaultHeight * 40).isActive = true
//        dealthumbnail.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        dealthumbnail.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 60).isActive = true
        dealthumbnail.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 60).isActive = true
        dealthumbnail.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        reviewcontent.topAnchor.constraint(equalTo: dealthumbnail.bottomAnchor, constant: screenHeight/defaultHeight * 24).isActive = true
//        reviewcontent.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        reviewcontent.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 127).isActive = true
        reviewcontent.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        reviewcontent.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cosmosView.topAnchor.constraint(equalTo: reviewcontent.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
//        cosmosView.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        cosmosView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 216).isActive = true
        cosmosView.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 40).isActive = true
        cosmosView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        reviewImage.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: screenHeight/defaultHeight * 56).isActive = true
        reviewImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        reviewImage.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 96).isActive = true
        reviewImage.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 96).isActive = true
        
        reviewTextView.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: screenHeight/defaultHeight * 184).isActive = true
//        reviewTextView.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        reviewTextView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        reviewTextView.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 78).isActive = true
        reviewTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        reviewTextView.delegate = self
        
        countLabel.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: screenHeight/defaultHeight * 4).isActive = true
        countLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
//        countLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 19).isActive = true
        
        btnWrite.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: screenHeight/defaultHeight * 24).isActive = true
//        btnWrite.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        btnWrite.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        btnWrite.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 56).isActive = true
        btnWrite.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func setimage() {
        let imageUrlString = self.reviewDatas.object(forKey: "deal_thumbnail") as! String
        let imageUrl:NSURL = NSURL(string: imageUrlString)!
        let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
        let image = UIImage(data: imageData as Data)
        dealthumbnail.image = image
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/purchased/review/" + String(purchasedUid) + "/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                self.reviewDatas = JSON as? NSDictionary
                self.setimage()
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ok() {
        print("OK")
    }
    
    @objc func write() {
//        if let upload_image = self.reviewImage.currentImage?.jpegData(compressionQuality: 1){
//            let url = "\(Config.baseURL)/api/purchased/leave_review/" + String(purchasedUid) + "/"
//            let parameters = [
//                "satisfaction" : Float(cosmosView.rating),
//                "context": reviewLabel.text
//                ] as [String : Any]
//            AF.upload(multipartFormData: { (multipartFormData) in
//                for(key,value) in parameters{
//                    multipartFormData.append(value.data(using: String.Encoding.utf8), withName: key)
//                }
//                multipartFormData.append(upload_image, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
//            }, to: url, method: .post).responseString { (response) in
//                debugPrint("RESPONSE: \(response)")
//            }
//        }
        print("WRITE")
    }
    
    @objc func reviewimage() {
        let nextVC = ReviewSelectVC()
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
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.text = "리뷰 쓰기"
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
    
    let dealthumbnail: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let reviewcontent: UILabel = {
        let label = UILabel()
        label.text = "별점을 남겨주세요!"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = StarFillMode(rawValue: 1)!
        view.settings.updateOnTouch = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.settings.starSize = 40
        return view
    }()
    
    let reviewImage: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor(rgb: 0xF4F5FC), for: .normal)
        btn.setTitle("추가", for: .normal)
        btn.layer.borderColor = UIColor(rgb: 0xF4F5FC).cgColor
        btn.layer.borderWidth = 3
        btn.addTarget(self, action: #selector(reviewimage), for: .touchUpInside)
        return btn
    }()
    
    let reviewTextView: UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "리뷰를 작성해주세요"
        return txtView
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 15)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .white
        return label
    }()
    
    let btnWrite: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("작성 완료", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.white, for: .normal)
        btn.layer.borderWidth = 3
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(write), for: .touchUpInside)
        return btn
    }()
    
}

extension ReviewVC: UITextViewDelegate {

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
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let changedText = currentText.replacingCharacters(in: stringRange, with: text)

        return changedText.count <= 500
    }
    
    func textViewSetupView() {
        if reviewTextView.text == "리뷰를 작성해주세요" {
            reviewTextView.text = ""
            reviewTextView.textColor = UIColor.black
        }
        else if reviewTextView.text == "" {
            reviewTextView.text = "리뷰를 작성해주세요"
            reviewTextView.textColor = UIColor(rgb: 0xEBEBF6)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        countLabel.text = String(count) + " / 500"
    }
}
