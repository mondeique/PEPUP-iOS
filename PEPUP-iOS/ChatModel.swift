//
//  ChatModel.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/18.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import ObjectMapper

class ChatModel: Mappable {
    
    public var users: Dictionary<String,Bool> = [:]
    public var comments: Dictionary<String, Comment> = [:]
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    
    public class Comment : Mappable {
        public var uid: String?
        public var message: String?
        public var timestamp: Int?
        public var readUsers: Dictionary<String,Bool> = [:]
        public required init?(map: Map) {
            
        }
        public func mapping(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
            timestamp <- map["timestamp"]
            readUsers <- map["readUsers"]
        }
    }

}
