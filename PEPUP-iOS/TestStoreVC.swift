//
//  TestStoreVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/28.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class TestStoreVC: UIViewController {
    
    var SellerID : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        self.view.backgroundColor = .white
        self.view.addSubview(button)
        
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    let button : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(follow), for: .touchUpInside)
        btn.setTitle("Follow", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    @objc func follow() {
        let parameters: [String: Int] = [
            "_to" : SellerID
        ]
        Alamofire.AF.request("\(Config.baseURL)/api/follow/following/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                print(response)
            case .failure(let error):
                print("Request failed with error: \(error)")
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
