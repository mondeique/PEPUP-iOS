//
//  MessageVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/10.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "messagechatcell"

class MessageVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var uid = String(UserDefaults.standard.object(forKey: "pk") as! Int)
    var chatrooms : [ChatModel]! = []
    var users: [UserModel]! = []
    var destinationUser: [String] = []
    var readCount: Int = 0
    
    var messagecollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getChatRoomsList()
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
        messagecollectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        messagecollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(messagecollectionView)
        
        messagecollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messagecollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messagecollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        messagecollectionView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chatrooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        readCount = 0
        var destinationUid : String?
        
        for item in chatrooms[indexPath.row].users {
            if(item.key != self.uid) {
                destinationUid = item.key
                destinationUser.append(destinationUid as! String)
            }
        }
        Database.database().reference().child("users").child(destinationUid!).observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            let userModel = UserModel()
            let userDic = datasnapshot.value as! NSDictionary
            userModel.pk = userDic.object(forKey: "pk") as! String
            userModel.username = userDic.object(forKey: "username") as! String
            userModel.profileImgUrl = userDic.object(forKey: "profileImgUrl") as! String
            cell.userNameLabel.text = userModel.username
            let imageUrl:NSURL = NSURL(string: userModel.profileImgUrl!)!
            let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
            let image = UIImage(data: imageData as Data)
            cell.profileImage.image = image
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
            cell.profileImage.layer.borderColor = UIColor.clear.cgColor
            cell.profileImage.layer.borderWidth = 1
            cell.profileImage.layer.masksToBounds = false
            cell.profileImage.clipsToBounds = true
        })
        
        let lastMessagekey = chatrooms[indexPath.row].comments.keys.sorted(){$0>$1}
        cell.userChatLabel.text = self.chatrooms[indexPath.row].comments[lastMessagekey[0]]?.message
        let unixTime = self.chatrooms[indexPath.row].comments[lastMessagekey[0]]?.timestamp
        cell.chattimeLabel.text = String(unixTime!.todayTime)
        for item in chatrooms[indexPath.row].comments {
            let readDic = item.value.readUsers as NSDictionary
            if let is_read = readDic.object(forKey: uid) as? Bool {
                readCount = readCount + 1
            }
        }
        cell.unreadCount.text = String(chatrooms[indexPath.row].comments.count - readCount)
        if cell.unreadCount.text == "0" {
            cell.unreadCount.text = ""
        }
        return cell
    }
    
    func getChatRoomsList() {
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/" + uid).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            self.chatrooms.removeAll()
            for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                if let chatroomdic = item.value as? [String:AnyObject] {
                    let chatModel = ChatModel(JSON: chatroomdic)
                    self.chatrooms.append(chatModel!)
                }
            }
            self.messagecollectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationUid = self.destinationUser[indexPath.row]
        let nextVC = MessageChatVC()
        Database.database().reference().child("users").child(destinationUid).observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            let userDic = datasnapshot.value as! NSDictionary
            nextVC.destinationUid = userDic.object(forKey: "pk") as! String
            nextVC.destinationUrlString = userDic.object(forKey: "profileImgUrl") as! String
            nextVC.destinationName = userDic.object(forKey: "username") as! String
            self.navigationController?.pushViewController(nextVC, animated: true)
        })
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
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

}
