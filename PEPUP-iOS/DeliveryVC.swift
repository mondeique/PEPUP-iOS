//
//  DeliveryVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/22.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialBottomSheet

class DeliveryVC: UIViewController {
    
    var Myid : Int!
    var DeliveryId : Int!
    var DeliveryCompany : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification : Notification) {
        print("KEYBOARD OPEN")
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print("KEYBOARD CLOSE")
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
        navcontentView.addSubview(deliveryLabel)
        navcontentView.addSubview(btnNext)
        
        self.view.addSubview(maincontentView)
        maincontentView.addSubview(deliveryCompanyLabel)
        maincontentView.addSubview(deliveryTextView)
        deliveryTextView.addSubview(deliveryBtn)
        deliveryTextView.addSubview(deliveryfakeBtn)
        maincontentView.addSubview(deliveryNumLabel)
        maincontentView.addSubview(deliveryNumTextView)
        
        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
        
        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 16).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
        
        deliveryLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        deliveryLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        btnNext.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        btnNext.rightAnchor.constraint(equalTo: navcontentView.rightAnchor, constant: screenWidth/defaultWidth * -18).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true
        
        maincontentView.topAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        maincontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        maincontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        maincontentView.heightAnchor.constraint(equalToConstant: screenHeight - navBarHeight - statusBarHeight).isActive = true
        
        deliveryCompanyLabel.topAnchor.constraint(equalTo: maincontentView.topAnchor, constant: screenHeight/defaultHeight * 32).isActive = true
        deliveryCompanyLabel.leftAnchor.constraint(equalTo: maincontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryCompanyLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 45).isActive = true
        deliveryCompanyLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 20).isActive = true
        
        deliveryTextView.topAnchor.constraint(equalTo: deliveryCompanyLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        deliveryTextView.leftAnchor.constraint(equalTo: maincontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryTextView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        deliveryTextView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 44).isActive = true
        
        print(DeliveryCompany)
        if DeliveryCompany != nil {
            deliveryTextView.text = DeliveryCompany
        }
        
        deliveryfakeBtn.topAnchor.constraint(equalTo: deliveryTextView.topAnchor).isActive = true
        deliveryfakeBtn.leftAnchor.constraint(equalTo: deliveryTextView.leftAnchor).isActive = true
        deliveryfakeBtn.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        deliveryfakeBtn.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 44).isActive = true
        view.bringSubviewToFront(deliveryfakeBtn)

        deliveryBtn.topAnchor.constraint(equalTo: deliveryTextView.topAnchor, constant: screenHeight/defaultHeight * 16).isActive = true
        deliveryBtn.leftAnchor.constraint(equalTo: deliveryTextView.leftAnchor, constant: screenWidth/defaultWidth * 309).isActive = true
        deliveryBtn.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 14).isActive = true
        deliveryBtn.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 14).isActive = true
        view.bringSubviewToFront(deliveryBtn)
        
        deliveryNumLabel.topAnchor.constraint(equalTo: deliveryTextView.bottomAnchor, constant: screenHeight/defaultHeight * 24).isActive = true
        deliveryNumLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryNumLabel.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 80).isActive = true
        deliveryNumLabel.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 20).isActive = true

        deliveryNumTextView.topAnchor.constraint(equalTo: deliveryNumLabel.bottomAnchor, constant: screenHeight/defaultHeight * 8).isActive = true
        deliveryNumTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        deliveryNumTextView.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 339).isActive = true
        deliveryNumTextView.heightAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 44).isActive = true
        
        deliveryNumTextView.delegate = self
        
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ok() {
        let parameters = [
            "code" : UserDefaults.standard.object(forKey: "Delivery_Company") as! String,
            "number" : deliveryNumTextView.text!
            ] as [String : Any]
        Alamofire.AF.request("\(Config.baseURL)/api/sold/leave_waybill/" + String(Myid) , method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print(JSON)

            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        print("OK")
    }
    
    @objc func delivery() {
        // View controller the bottom sheet will hold
        let viewController: UIViewController = DeliveryBottomSheetVC()
        
        // Initialize the bottom sheet with the view controller just created
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        bottomSheet.dismissOnDraggingDownSheet = true
        bottomSheet.dismissOnBackgroundTap = true
        bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 350)
        // Present the bottom sheet
        present(bottomSheet, animated: true, completion: nil)
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
    
    let deliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textColor = .black
        label.text = "운송장 번호"
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
    
    let maincontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let deliveryCompanyLabel: UILabel = {
        let label = UILabel()
        label.text = "택배사"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    let deliveryTextView: UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "택배사를 선택해주세요"
        return txtView
    }()
    
    let deliveryfakeBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(delivery), for: .touchUpInside)
        return btn
    }()
    
    let deliveryBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnScroll"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(delivery), for: .touchUpInside)
        return btn
    }()
    
    let deliveryNumLabel: UILabel = {
        let label = UILabel()
        label.text = "운송장 번호"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    let deliveryNumTextView: UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        txtView.textAlignment = .left
        txtView.backgroundColor = .white
        txtView.layer.borderWidth = 1
        txtView.layer.cornerRadius = 3
        txtView.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtView.textColor = UIColor(rgb: 0xEBEBF6)
        txtView.text = "운송장 번호를 입력해주세요"
        txtView.keyboardType = UIKeyboardType.decimalPad
        return txtView
    }()
}

extension DeliveryVC: UITextViewDelegate {

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
        if deliveryNumTextView.text == "운송장 번호를 입력해주세요" {
            deliveryNumTextView.text = ""
            deliveryNumTextView.textColor = UIColor.black
        }
        else if deliveryNumTextView.text == "" {
            deliveryNumTextView.text = "운송장 번호를 입력해주세요"
            deliveryNumTextView.textColor = UIColor(rgb: 0xEBEBF6)
        }
    }
}

class DeliveryBottomSheetVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : DeliveryVC?
    
    private let reuseIdentifier = "tablecell"
    
    var deliverytableView: UITableView!
    var deliveryDatas = Array<NSDictionary>()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setup()
        getData()
    }
    
    func getData() {
        Alamofire.AF.request("\(Config.baseURL)/api/sold/waybill/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! Array<NSDictionary>
                self.deliveryDatas = response
                DispatchQueue.main.async {
                    self.deliverytableView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func setup() {
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
//        let defaultWidth: CGFloat = 375
//        let defaultHeight: CGFloat = 667
//        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
//        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
        
        deliverytableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .plain)
        deliverytableView.delegate = self
        deliverytableView.dataSource = self
        self.deliverytableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(self.deliverytableView)
        deliverytableView.translatesAutoresizingMaskIntoConstraints = false
        
        deliverytableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        deliverytableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        deliverytableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        deliverytableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let deliveryDic = deliveryDatas[indexPath.row]
        let name = deliveryDic.object(forKey: "name") as! String
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deliveryDic = deliveryDatas[indexPath.row]
        let name = deliveryDic.object(forKey: "name") as! String
        let code = deliveryDic.object(forKey: "code") as! String
        UserDefaults.standard.set(code, forKey: "Delivery_Company")
        print(name)
        delegate?.DeliveryCompany = name
        delegate?.setup()
        self.dismiss(animated: true, completion: nil)
    }
}
