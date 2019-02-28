//  ChatCell.swift
//  InstagramDemo
//  Created by MOAMEN on 12/1/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit



class ChatCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            guard let comment = message else { return }
            let attributedText = NSMutableAttributedString(string: comment.user.username!, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " \(comment.text!)", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
           // commentTextView.attributedText = attributedText
           // profileImageView.loadImage(urlString: comment.user.profileImageUrl!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
