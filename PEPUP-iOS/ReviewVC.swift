//
//  ReviewVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/23.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

}
