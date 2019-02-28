//  likedCell.swift
//  InstagramDemo
//  Created by MOAMEN on 12/1/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit

class likedCell: UICollectionViewCell {
    
    var likedPost: Post? {
        didSet {
            guard let imageUrl = likedPost?.imageUrl else{ return }
            photoImageView.loadImage(urlString: imageUrl)
            usernameLabel.text = likedPost?.user?.username
            guard let profileImageUrl = likedPost?.user?.profileImageUrl else { return }
            UserProfileImageView.loadImage(urlString: profileImageUrl)
            setupAttributedCaption(post: likedPost!)
            
        }
    }
    
    fileprivate func setupAttributedCaption (post: Post) {
        
        let attributedText = NSMutableAttributedString(string: (post.user?.username)!, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.caption!)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: " \n\n ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        guard let timeAgoDisplay = post.creationDate?.timeAgoDisplay() else { return }
        
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        captionLabel.attributedText = attributedText
        
    }
    
    var delegate: HomePhotoCellDelegate?
    
    let UserProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComments), for: .touchUpInside)
        return button
    }()
    
    @objc func handleComments() {
        guard let post = likedPost else{ return }
        delegate?.didTabComment(post: post)
    }
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(UserProfileImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        
        UserProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        UserProfileImageView.layer.cornerRadius = 50 / 2
        
        usernameLabel.anchor(top: topAnchor, left: UserProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        photoImageView.anchor(top: UserProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
        addSubview(captionLabel)
        captionLabel.anchor(top: commentButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
    }
    
    fileprivate func setupActionButtons() {
        
        let stackView = UIStackView(arrangedSubviews: [ commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


