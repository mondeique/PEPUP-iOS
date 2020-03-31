//
//  MessageChatVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Firebase

private let mycellID = "chatcell"
private let destinationcellID = "chatdestinationcell"

class MessageChatVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var destinationUid: String?
    
    var messagecollectionView: UICollectionView!
    
    var uid: String!
    var chatRoomUid : String?
    
    var comments: [ChatModel.Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        uid = String(UserDefaults.standard.object(forKey: "pk") as! Int)
        checkChatRoom()
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
        self.tabBarController?.tabBar.isHidden = false
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
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight/defaultHeight * 88)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        messagecollectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight, width: view.frame.width, height: screenHeight), collectionViewLayout: layout)
        messagecollectionView.delegate = self
        messagecollectionView.dataSource = self
        messagecollectionView.register(MyMessageChatCell.self, forCellWithReuseIdentifier: mycellID)
        messagecollectionView.register(DestinationMessageChatCell.self, forCellWithReuseIdentifier: destinationcellID)
        messagecollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(messagecollectionView)
        
        messagecollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messagecollectionView.topAnchor.constraint(equalTo: navcontentView.bottomAnchor).isActive = true
        messagecollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messagecollectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        self.view.addSubview(bottomcontentView)
        
        bottomcontentView.addSubview(messageTxtField)
        bottomcontentView.addSubview(btnSend)
        
        bottomcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (self.comments[indexPath.row].uid == uid) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mycellID, for: indexPath) as! MyMessageChatCell
            cell.userChatLabel.text = self.comments[indexPath.row].message
            cell.userChatLabel.numberOfLines = 0
            cell.userChatLabel.lineBreakMode = .byWordWrapping
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: destinationcellID, for: indexPath) as! DestinationMessageChatCell
            cell.userChatLabel.text = self.comments[indexPath.row].message
            cell.userChatLabel.numberOfLines = 0
            cell.userChatLabel.lineBreakMode = .byWordWrapping
            cell.profileImage.image = UIImage(named: "btnGO")
            return cell
        }
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
                "message": messageTxtField.text
            ]
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
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
        Database.database().reference().child("chatrooms").child(self.chatRoomUid!).child("comments").observe(DataEventType.value, with: { (datasnapshot) in
            self.comments.removeAll()
            
            for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.messagecollectionView.reloadData()
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
    
    let messageTxtField: UITextField = {
        let txtfield = UITextField()
        txtfield.translatesAutoresizingMaskIntoConstraints = false
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
        DateFormatter.dateFormat(fromTemplate: "yyyy.MM.dd HH:mm", options: 0, locale: Locale(identifier: "ko_KR"))
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dataFormatter.string(from: date)
    }
}
