//
//  ChatModel.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/18.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class ChatModel: NSObject {
    
    public var users: Dictionary<String,Bool> = [:]
    public var comments: Dictionary<String, Comment> = [:]
    
    public class Comment {
        public var uid: String?
        public var message: String?
    }

}
