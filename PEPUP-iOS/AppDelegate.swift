//
//  AppDelegate.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/29.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SwiftyBootpay
import Firebase
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(3)
        
        if(isConnectedToNetwork() == true){
            print("NETWORK CONNECTED")
        }else{
            self.exitAlert()
        }
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        } else {
            // Fallback on earlier versions
        }
        
        
        if let token = UserDefaults.standard.object(forKey: "token") as? String {
            Alamofire.AF.request("\(Config.baseURL)/accounts/check_userinfo/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": token]) .validate(statusCode: 200..<300) .responseJSON {
                (response) in switch response.result {
                case .success(let JSON):
                    // 만료되지 않은 token이 저장되어 있을 경우
                    let response = JSON as! NSDictionary
                    let code = response.object(forKey: "code") as! Int
                    // user.email, user.nickname 모두 존재할 경우
                    if code == 1 {
                        self.loadHome()
                        print("Success with JSON: \(JSON)")
                        Alamofire.AF.request("\(Config.baseURL)/accounts/check_store/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .response { response in
                            if response.response?.statusCode == 200 {
                                print("SUCESS!")
                                UserDefaults.standard.set(true, forKey: "exist_store")
                            }
                            else if response.response?.statusCode == 404 {
                                print("NOT FOUND!")
                                UserDefaults.standard.set(false, forKey: "exist_store")
                            }
                            else {
                                print("OTHER ERROR!")
                                UserDefaults.standard.set(false, forKey: "exist_store")
                            }
                        }
                    }
                    // token이 없는 경우
                    else if code == -1 {
                        print("NO Token")
                        self.loadHome()
                    }
                    // user.email이 없는 경우
                    else if code == -2 {
                        self.loadLogin()
                    }
                    // user.nickname이 없는 경우
                    else if code == -3 {
                        self.loadNickName()
                    }
                    // phone confirm 자체도 하지 않은 경우
                    else if code == -4 {
                        UserDefaults.standard.set(nil, forKey: "token")
                        self.loadLogin()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    if error.responseCode == 401 {
                        self.loadLogin()
                    }
                }
            }
        }
        else {
            print("Invalid TOKEN")
            self.loadLogin()
        }
        Bootpay.sharedInstance.appLaunch(application_id: "5e05af1302f57e00219c40dc") // production sample
        FirebaseApp.configure()
        return true
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Bootpay.sharedInstance.sessionActive(active: false)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Bootpay.sharedInstance.sessionActive(active: true)
    }
    
    // MARK: Load RootViewController
    
    fileprivate func loadLogin() {
        let controller = UINavigationController(rootViewController: LoginVC())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    fileprivate func loadHome() {
        let controller = TabBarController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    fileprivate func loadNickName() {
        let controller = UINavigationController(rootViewController: LoginVC())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        let nextVC = NickNameVC()
        controller.pushViewController(nextVC, animated: true)
    }
    
    func exitAlert() {
        let controller = HomeVC()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        print("NETWORK ERROR")
        let alertController = UIAlertController(title: nil, message: "네트워크가 올바르지 않습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (UIAlertAction) in
            exit(0)
        }))
        window?.makeKeyAndVisible()
        window?.rootViewController?.present(alertController, animated: false, completion: nil)
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PEPUP_iOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

