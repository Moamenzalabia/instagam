//  Message.swift
//  InstagramDemo
//  Created by MOAMEN on 12/1/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import Foundation

struct Message {
    
    let user: User
    let text: String?
    let uid: String?
    let creationDate: Date?
    
    init(user: User, messagesDictionary:[String: Any]) {
        self.user = user
        self.text = messagesDictionary["text"] as? String
        self.uid = messagesDictionary["uid"] as? String
        let secondFrom1970 = messagesDictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondFrom1970)
        
    }
    
}
