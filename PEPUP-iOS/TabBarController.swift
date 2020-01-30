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
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setup() {
        view.backgroundColor = .white
        delegate = self
        //Instantiate controllers
        //Home
        let homeFlow = UICollectionViewFlowLayout()
        let home = UINavigationController(rootViewController: HomeVC(collectionViewLayout: homeFlow))
        home.tabBarItem.image = #imageLiteral(resourceName: "home_unselected")
        home.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected")
        //Follow
        let followFlow = UICollectionViewFlowLayout()
        let follow = UINavigationController(rootViewController: FollowVC(collectionViewLayout: followFlow))
        follow.tabBarItem.image = #imageLiteral(resourceName: "home_unselected")
        follow.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected")
        
        tabBar.tintColor = .black
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
