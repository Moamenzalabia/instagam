//
//  Post.swift
//  InstagramDemo
//
//  Created by MOAMEN on 8/27/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import Foundation

struct Post {
    
    var Id: String?
    let user: User?
    let imageUrl: String?
    let caption: String?
    let creationDate: Date?
    var hasLiked: Bool = false
    
    init(user: User, dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String
        self.user = user
        self.caption = dictionary["caption"] as? String
        
        let secondFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondFrom1970)
    }
}
