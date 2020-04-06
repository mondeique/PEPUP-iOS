//
//  MessageChatVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

private let mycellID = "chatcell"
private let destinationcellID = "chatdestinationcell"

class MessageChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var destinationUid: String?
    var destinationUrlString : String?
    var destinationName : String?
    
    var databaseRef : DatabaseReference?
    var observe : UInt?
    
    var messagetableView: UITableView!
    
    var uid = String(UserDefaults.standard.object(forKey: "pk") as! Int)
    var chatRoomUid : String?
    
    var comments: [ChatModel.Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        checkChatRoom()
        createUserDB()
        createMyDB()
        setup()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        NotificationCenter.default.removeObserver(self)
        
        databaseRef?.removeObserver(withHandle: observe!)
    }
    
    @objc func keyboardWillShow(notification : Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomcontentView.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant: -keyboardSize.height).isActive = true
        }
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (complete) in
            
            if self.comments.count > 0 {
                self.messagetableView.scrollToRow(at: IndexPath(item:self.comments.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
            }
        })
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomcontentView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        self.view.layoutIfNeeded()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setup() {
        self.view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let defaultWidth: CGFloat = 375
        let defaultHeight: CGFloat = 667
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height

        navcontentView.addSubview(btnBack)
        navcontentView.addSubview(chatLabel)
        navcontentView.addSubview(lineLabel)

        self.view.addSubview(navcontentView)

        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true

        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true

        chatLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
        chatLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
        
        lineLabel.bottomAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalTo: navcontentView.widthAnchor).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 1).isActive = true
        
        messagetableView = UITableView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: screenWidth, height: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 56), style: .plain)
        
        self.view.addSubview(messagetableView)
        
        messagetableView.translatesAutoresizingMaskIntoConstraints = false
        messagetableView.delegate = self
        messagetableView.dataSource = self
        messagetableView.separatorStyle = .none
        messagetableView.backgroundColor = .white

        messagetableView.register(MyMessageChatCell.self, forCellReuseIdentifier: mycellID)
        messagetableView.register(DestinationMessageChatCell.self, forCellReuseIdentifier: destinationcellID)
        
        messagetableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messagetableView.topAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        messagetableView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        messagetableView.heightAnchor.constraint(equalToConstant: screenHeight - statusBarHeight - navBarHeight - screenHeight/defaultHeight * 56).isActive = true
        
        self.view.addSubview(bottomcontentView)
        
        bottomcontentView.addSubview(messageTxtField)
        bottomcontentView.addSubview(btnSend)
        
        bottomcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomcontentView.topAnchor.constraint(equalTo: messagetableView.bottomAnchor).isActive = true
        bottomcontentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        bottomcontentView.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 56).isActive = true
        
        messageTxtField.leftAnchor.constraint(equalTo: bottomcontentView.leftAnchor, constant: screenWidth/defaultWidth * 12).isActive = true
        messageTxtField.bottomAnchor.constraint(equalTo: bottomcontentView.bottomAnchor, constant: screenHeight/defaultHeight * -8).isActive = true
        messageTxtField.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 301).isActive = true
        messageTxtField.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 40).isActive = true
        
        btnSend.leftAnchor.constraint(equalTo: messageTxtField.rightAnchor, constant: screenWidth/defaultWidth * 10).isActive = true
        btnSend.bottomAnchor.constraint(equalTo: bottomcontentView.bottomAnchor, constant: screenHeight/defaultHeight * -8).isActive = true
        btnSend.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 40).isActive = true
        btnSend.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 40).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.comments[indexPath.row].uid == uid) {
            let cell = tableView.dequeueReusableCell(withIdentifier: mycellID, for: indexPath) as! MyMessageChatCell
            cell.backgroundLabel.layer.cornerRadius = 22
            cell.backgroundLabel.clipsToBounds = true
            cell.userChatLabel.text = self.comments[indexPath.row].message
            cell.userChatLabel.numberOfLines = 0
            cell.userChatLabel.lineBreakMode = .byWordWrapping
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: destinationcellID, for: indexPath) as! DestinationMessageChatCell
            if indexPath.row > 0 {
                if self.comments[indexPath.row - 1].uid != uid {
                    cell.backgroundLabel.layer.cornerRadius = 22
                    cell.backgroundLabel.clipsToBounds = true
                    cell.userChatLabel.text = self.comments[indexPath.row].message
                    cell.userChatLabel.numberOfLines = 0
                    cell.userChatLabel.lineBreakMode = .byWordWrapping
                    let imageUrl:NSURL = NSURL(string: destinationUrlString!)!
                    let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                    let image = UIImage(data: imageData as Data)
                    DispatchQueue.main.async {
                        cell.profileImage.image = image
                        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
                        cell.profileImage.layer.borderColor = UIColor.clear.cgColor
                        cell.profileImage.layer.borderWidth = 1
                        cell.profileImage.layer.masksToBounds = false
                        cell.profileImage.clipsToBounds = true
                        cell.profileImage.isHidden = true
                    }
                }
                else {
                    cell.backgroundLabel.layer.cornerRadius = 22
                    cell.backgroundLabel.clipsToBounds = true
                    cell.userChatLabel.text = self.comments[indexPath.row].message
                    cell.userChatLabel.numberOfLines = 0
                    cell.userChatLabel.lineBreakMode = .byWordWrapping
                    let imageUrl:NSURL = NSURL(string: destinationUrlString!)!
                    let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                    let image = UIImage(data: imageData as Data)
                    DispatchQueue.main.async {
                        cell.profileImage.image = image
                        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
                        cell.profileImage.layer.borderColor = UIColor.clear.cgColor
                        cell.profileImage.layer.borderWidth = 1
                        cell.profileImage.layer.masksToBounds = false
                        cell.profileImage.clipsToBounds = true
                        cell.profileImage.isHidden = false
                    }
                }
            }
            else {
                cell.backgroundLabel.layer.cornerRadius = 22
                cell.backgroundLabel.clipsToBounds = true
                cell.userChatLabel.text = self.comments[indexPath.row].message
                cell.userChatLabel.numberOfLines = 0
                cell.userChatLabel.lineBreakMode = .byWordWrapping
                let imageUrl:NSURL = NSURL(string: destinationUrlString!)!
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                let image = UIImage(data: imageData as Data)
                DispatchQueue.main.async {
                    cell.profileImage.image = image
                    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
                    cell.profileImage.layer.borderColor = UIColor.clear.cgColor
                    cell.profileImage.layer.borderWidth = 1
                    cell.profileImage.layer.masksToBounds = false
                    cell.profileImage.clipsToBounds = true
                    cell.profileImage.isHidden = false
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func createRoom() {
        let createRoomInfo : Dictionary<String,Any> = [ "users" : [
                uid: true,
                destinationUid: true
            ]
        ]
        if (chatRoomUid == nil) {
            self.btnSend.isEnabled = false
            Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo) { (err, ref) in
                if(err == nil) {
                    self.checkChatRoom()
                }
            }
        }
        else {
            let value : Dictionary<String, Any> = [
                "uid" : uid,
                "message": messageTxtField.text,
                "timestamp": ServerValue.timestamp()
            ]
            if messageTxtField.text == "" {
                print("NO!")
            }
            else {
                Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value) { (err, ref) in
                    self.messageTxtField.text = ""
                }
            }
        }
    }
    
    func createMyDB() {
        Alamofire.AF.request("\(Config.baseURL)/accounts/chat_userinfo/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let pk = response.object(forKey: "id") as! Int
                let nickname = response.object(forKey: "nickname") as! String
                let profileImgUrl = response.object(forKey: "profile_img") as! String
                let value : Dictionary<String, String> = [
                    "pk" : String(pk),
                    "username" : nickname,
                    "profileImgUrl": profileImgUrl
                ]
                Database.database().reference().child("users").child(self.uid).setValue(value)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func createUserDB() {
        let value : Dictionary<String, String> = [
            "pk" : destinationUid!,
            "username" : destinationName!,
            "profileImgUrl": destinationUrlString!
        ]
        Database.database().reference().child("users").child(destinationUid!).setValue(value)
    }
    
    func checkChatRoom() {
        
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/" + uid).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: { (datasnapshop) in
            for item in datasnapshop.children.allObjects as! [DataSnapshot] {
                
                if let chatRoomdic = item.value as? [String:AnyObject] {
                    let chatModel = ChatModel(JSON: chatRoomdic)
                    if (chatModel?.users[self.destinationUid!] == true) {
                        self.chatRoomUid = item.key
                        self.btnSend.isEnabled = true
                        self.getMessageList()
                    }
                }
            }
        })
    }
    
    func getMessageList() {
        databaseRef = Database.database().reference().child("chatrooms").child(self.chatRoomUid!).child("comments")
        observe = databaseRef?.observe(DataEventType.value, with: { (datasnapshot) in
            self.comments.removeAll()
            var readUserDic : Dictionary<String, AnyObject> = [:]
            for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                let key = item.key as String
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                comment?.readUsers[self.uid] = true
                readUserDic[key] = comment?.toJSON() as! NSDictionary
                self.comments.append(comment!)
            }
            
            let nsDic = readUserDic as NSDictionary
            
            datasnapshot.ref.updateChildValues(nsDic as! [AnyHashable : Any]) { (err, ref) in
                
                self.messagetableView.reloadData()
                
                if self.comments.count > 0 {
                    self.messagetableView.scrollToRow(at: IndexPath(item:self.comments.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
                }
            }
        })
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

    let chatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        label.textColor = .black
        label.text = "M E S S A G E"
        label.textAlignment = .center
        return label
    }()
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        return label
    }()
    
    let bottomcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let messageTxtField: TextField = {
        let txtfield = TextField()
        txtfield.translatesAutoresizingMaskIntoConstraints = false
        txtfield.placeholder = "메세지 보내기"
        txtfield.layer.borderColor = UIColor(rgb: 0xEBEBF6).cgColor
        txtfield.layer.borderWidth = 1
        txtfield.layer.cornerRadius = 22
        return txtfield
    }()
    
    let btnSend: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("전송", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        return btn
    }()

}

extension Int {
    
    var todayTime : String {
        let dataFormatter = DateFormatter()
        dataFormatter.locale = Locale(identifier: "ko_KR")
        dataFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dataFormatter.string(from: date)
    }
}
