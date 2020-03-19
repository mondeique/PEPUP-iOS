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

private let cellID = "tablecell"

class MessageVC: UIViewController {
    
//    var myUid : Int! = UserDefaults.standard.object(forKey: "pk") as! Int
//    var destinationUid: Int!
//    var ref: DatabaseReference!
//
//    var ChatRoomUid: String!
//
    override func viewDidLoad() {
        super.viewDidLoad()
//        setup()
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
    
//    func setup() {
//        self.view.backgroundColor = .white
//        let screensize: CGRect = UIScreen.main.bounds
//        let screenWidth = screensize.width
//        let screenHeight = screensize.height
//        let defaultWidth: CGFloat = 375
//        let defaultHeight: CGFloat = 667
//        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height
//        let navBarHeight: CGFloat! = navigationController?.navigationBar.frame.height
//
//        navcontentView.addSubview(btnBack)
//        navcontentView.addSubview(chatLabel)
//
//        self.view.addSubview(navcontentView)
//
//        navcontentView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
//        navcontentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        navcontentView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
//        navcontentView.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
//
//        btnBack.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 14).isActive = true
//        btnBack.leftAnchor.constraint(equalTo: navcontentView.leftAnchor, constant: screenWidth/defaultWidth * 18).isActive = true
//        btnBack.widthAnchor.constraint(equalToConstant: screenWidth/defaultWidth * 10).isActive = true
//        btnBack.heightAnchor.constraint(equalToConstant: screenHeight/defaultHeight * 16).isActive = true
//
//        chatLabel.topAnchor.constraint(equalTo: navcontentView.topAnchor, constant: screenHeight/defaultHeight * 12).isActive = true
//        chatLabel.centerXAnchor.constraint(equalTo: navcontentView.centerXAnchor).isActive = true
//
//        self.view.addSubview(sendBtn)
//
//        sendBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: screenHeight/defaultHeight * statusBarHeight).isActive = true
//        sendBtn.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
////        sendBtn.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
//        sendBtn.heightAnchor.constraint(equalToConstant: navBarHeight).isActive = true
//    }
//
//    @objc func back() {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    @objc func createRoom() {
//        let createRoomInfo : Dictionary<String,Any> = [
//            "users: " [
//                uid!: true,
//                destinationUid!: true
//            ]
//            ] as [String : Int]
//        ref = Database.database().reference()
//        if(ChatRoomUid == nil) {
//            ref.child("chatrooms").setValue(createRoomInfo)
//        }
//        else {
//            let value : Dictionary<String, Any> = [
//                "comments": [
//                    "uid" : uid!,
//                    "message" : textfield_message.text!
//                ]
//            ]
//            ref.child("chatrooms").child(ChatRoomUid).child("comments").childByAutoId().setValue(value)
//        }
//    }
//
//    func checkChatRoom() {
//        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/").queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: {
//            (datasnapshot) in
//            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
//                ChatRoomUid = item.key
//            }
//
//
//        )}
//    }
//
//    let navcontentView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        return view
//    }()
//
//    let btnBack: UIButton = {
//        let btn = UIButton()
//        btn.setImage(UIImage(named: "btnBack"), for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
//        return btn
//    }()
//
//    let chatLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
//        label.textColor = .black
//        label.text = "C H A T T I N G"
//        label.textAlignment = .center
//        return label
//    }()
//
//    let sendBtn: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
//        btn.setTitle("전송", for: .normal)
//        btn.setTitleColor(.black, for: .normal)
//        btn.backgroundColor = .red
//        return btn
//    }()

}
