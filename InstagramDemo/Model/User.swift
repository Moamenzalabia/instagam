//  User.swift
//  InstagramDemo
//  Created by MOAMEN on 7/26/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import Foundation

//Mark: user firebase data model
struct User {
    
    let uid: String?
    let username: String?
    let profileImageUrl: String?
    
    init(uid: String, dictionary: [String: Any]) {
        
        self.uid = uid
        self.username = dictionary["username"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        
    }
    
    
}
