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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let token = UserDefaults.standard.object(forKey: "token") as? String {
            Alamofire.AF.request("\(Config.baseURL)/accounts/check_userinfo/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json", "Authorization": token]) .validate(statusCode: 200..<300) .responseJSON {
                            (response) in switch response.result {
                            case .success(let JSON):
                                print("Success with JSON: \(JSON)")
                                // 만료되지 않은 token이 저장되어 있을 경우
                                let response = JSON as! NSDictionary
                                let code = response.object(forKey: "code") as! Int
                                if code == 1 {
                                    self.loadHome()
                                }
                                else if code == -1 {
                                    print("Invalid Token")
                                }
                                else if code == -2 {
                                    self.loadLogin()
                                }
                                else if code == -3 {
                                    self.loadNickName()
                                }
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
            print("NO TOKEN")
            self.loadLogin()
        }
        loadLogin()
        return true
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
        let controller = NickNameVC()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
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

