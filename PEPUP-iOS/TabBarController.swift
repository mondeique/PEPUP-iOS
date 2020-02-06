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
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Login 에서 push 될 때 navigationBar가 생기는데 이를 없앰
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        
        tabFrame.size.height = 49
        tabFrame.origin.y = self.view.frame.size.height - 49
        self.tabBar.frame = tabFrame
    }
    
    fileprivate func setup() {
        delegate = self
        // Instantiate controllers
        // Home
        let homeFlow = UICollectionViewFlowLayout()
        let home = UINavigationController(rootViewController: HomeVC(collectionViewLayout: homeFlow))
        home.tabBarItem.image = #imageLiteral(resourceName: "home_unselected")
        home.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected")
        // Follow
        let followFlow = UICollectionViewFlowLayout()
        let follow = UINavigationController(rootViewController: FollowVC(collectionViewLayout: followFlow))
        follow.tabBarItem.image = #imageLiteral(resourceName: "home_unselected")
        follow.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected")
        viewControllers = [home, follow]
        if let items = tabBar.items {
            for item in items{
                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
