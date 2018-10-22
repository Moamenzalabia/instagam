//
//  User.swift
//  InstagramDemo
//
//  Created by MOAMEN on 7/26/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import Foundation

//Mark: user firebase data model
struct User {
    
    let username: String?
    let profileImageUrl: String?
    
    init(dictionary: [String: Any]) {
        
        self.username = dictionary["username"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        
    }
    
    
}
