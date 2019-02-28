//  CommentInputTextView.swift
//  InstagramDemo
//  Created by MOAMEN on 11/4/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit

class CommentInputTextView: UITextView {
    
    fileprivate let placeholderLabel: UILabel = {
       let label = UILabel()
       label.text = "Enter Comment"
       label.textColor = UIColor.lightGray
    return label
    }()
    
    func showPlaceholderLabel()  {
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty // to change placeholder text deppend on status of user writting
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
