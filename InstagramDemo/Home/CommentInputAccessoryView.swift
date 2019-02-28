//  CommentInputAccessoryView.swift
//  InstagramDemo
//  Created by MOAMEN on 11/4/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.


import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentTextField() {
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
    }
    
   fileprivate let commentTextView: CommentInputTextView = {
        let textView = CommentInputTextView()
      textView.isScrollEnabled = false
      textView.font = UIFont.systemFont(ofSize: 18)
      return textView
        
    }()
    
   fileprivate let submitButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Submit", for: .normal)
        sb.setTitleColor(.black, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //step 1
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        
        addSubview(commentTextView)
        // step 3
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        setUpLineSeparatorView()
    }
    //step 2
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    fileprivate func setUpLineSeparatorView (){
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    //  delegate action that save comment into firebase 
    @objc func handleSubmit() {
        guard let comment = commentTextView.text else { return}
        delegate?.didSubmit(for: comment)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
