//
//  SettingVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/04.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        // Do any additional setup after loading the view.
        view.addSubview(btnLogout)
        btnLogout.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnLogout.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func logout() {
        let nextVC = LoginVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    let btnLogout : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("LOGOUT", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return btn
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
