//  Comment.swift
//  InstagramDemo
//  Created by MOAMEN on 9/15/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.


import Foundation

struct Comment {
    
    let user: User
    let text: String?
    let uid: String?
    let creationDate: Date?

    init(user: User, commentsDictionary:[String: Any]) {
        self.user = user
       self.text = commentsDictionary["text"] as? String
       self.uid = commentsDictionary["uid"] as? String
       let secondFrom1970 = commentsDictionary["creationDate"] as? Double ?? 0
       self.creationDate = Date(timeIntervalSince1970: secondFrom1970)
        
    }
    
}
