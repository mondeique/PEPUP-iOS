//
//  PaymentVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/05.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {
    
    var trades : Array<Int>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }

}
