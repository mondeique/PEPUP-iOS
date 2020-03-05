//
//  FilterVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/05.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        self.view.backgroundColor = .white
    }

}
