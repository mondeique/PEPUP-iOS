//
//  DetailVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class DetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
        getData()
    }
    
    func setup() {
        self.view.backgroundColor = .white
//        navigationItem.hidesBackButton = true
//        setImage()
//        setInfo()
    }
//
//    fileprivate func setImage() {
//        view.addSubview(view: UIView)
//    }
//
//    fileprivate func setInfo() {
//        view.addSubview(view: UIView)
//    }
//
//    fileprivate func setButton() {
//        view.addSubview(UIView)
//    }
    func getData() {
        Alamofire.AF.request("http://mypepup.com/api/products/5/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json",  "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
                let results = response["results"] as! Array<Dictionary<String, Any>>
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
