//
//  Config.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/06.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import Foundation

struct Config {
    static let baseURL = "http://mypepup.com"
    static let token = UserDefaults.standard.object(forKey: "token") as! String
}
