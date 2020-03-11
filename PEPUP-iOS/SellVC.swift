//
//  SellVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/10.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class SellVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func getData() {
        
    }
    

}
