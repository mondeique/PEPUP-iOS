//
//  TabBarController.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/29.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBar.backgroundColor = .white
        super.viewWillAppear(animated)
        // Login 에서 push 될 때 navigationBar가 생기는데 이를 없앰
        self.navigationController?.isNavigationBarHidden = true
        
        var tabFrame = self.tabBar.frame

        tabFrame.size.height = UIScreen.main.bounds.height/667 * 49
        tabFrame.origin.y = UIScreen.main.bounds.height/667 * -49
        self.tabBar.frame = tabFrame
    }
    
    fileprivate func setup() {
        delegate = self
        // Instantiate controllers
        // Home
        let home = UINavigationController(rootViewController: HomeVC())
        home.tabBarItem.image = #imageLiteral(resourceName: "home_unselected")
        home.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected")
        // Follow
        let follow = UINavigationController(rootViewController: FollowVC())
//        let follow = UINavigationController(rootViewController: TagVC())
        follow.tabBarItem.image = #imageLiteral(resourceName: "follow_unselected")
        follow.tabBarItem.selectedImage = #imageLiteral(resourceName: "follow_selected")
        // Store
        let store = UINavigationController(rootViewController: StoreVC())
        store.tabBarItem.image = #imageLiteral(resourceName: "store_unselected")
        store.tabBarItem.selectedImage = #imageLiteral(resourceName: "store_selected")
        viewControllers = [home, follow, store]
        if let items = tabBar.items {
            for item in items{
                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            }
        }
    }
}
