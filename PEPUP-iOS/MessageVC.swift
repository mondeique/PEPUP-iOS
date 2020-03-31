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
    
    var messagecollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getChatRoomsList()
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
        
        var destinationUid : String?
        
        for item in chatrooms[indexPath.row].users {
            if(item.key != self.uid) {
                destinationUid = item.key
            }
        }
        Database.database().reference().child("users").child("destinationUid").observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            
        })
        return cell
    }
    
    func getChatRoomsList() {
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/" + uid).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
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
        print("SELECT \(indexPath.row)")
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
