//
//  TabBarController.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/29.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

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
        follow.tabBarItem.image = #imageLiteral(resourceName: "follow_unselected")
        follow.tabBarItem.selectedImage = #imageLiteral(resourceName: "follow_selected")
        // Sell
        var is_store = false
        Alamofire.AF.request("\(Config.baseURL)/accounts/check_store/" , method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print(JSON)
                is_store = true
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                is_store = false
            }
        }
        var sell = UINavigationController(rootViewController: StoreInfoSettingVC())
        if is_store == true {
            sell = UINavigationController(rootViewController: SellSelectVC())
        }
        else  {
            sell = UINavigationController(rootViewController: StoreInfoSettingVC())
        }
        sell.tabBarItem.image = #imageLiteral(resourceName: "sell_unselected")
        sell.tabBarItem.selectedImage = #imageLiteral(resourceName: "sell_selected")
        // Noti
        let noti = UINavigationController(rootViewController: NotiVC())
        noti.tabBarItem.image = UIImage(named: "noti_unselected")
        noti.tabBarItem.selectedImage = UIImage(named: "noti_selected")
        // Store
        let store = UINavigationController(rootViewController: MyStoreVC())
        store.tabBarItem.image = #imageLiteral(resourceName: "store_unselected")
        store.tabBarItem.selectedImage = #imageLiteral(resourceName: "store_selected")
        viewControllers = [home, follow, sell, noti, store]
        if let items = tabBar.items {
            for item in items{
                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            }
        }
    }
    
}
