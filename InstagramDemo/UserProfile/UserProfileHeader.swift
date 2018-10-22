//
//  UserProfileHeader.swift
//  InstagramDemo
//
//  Created by MOAMEN on 7/26/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    //Mark: user object from  user model
    var user: User? {
        
        didSet{
            setupProfileImage()
            usernameLabel.text = user?.username
        }
        
    }
    
    // Mark: user  profile image
    let profileImageView: UIImageView = {
        
        let image = UIImageView()
        
        return image
    }()
    
    // Mark: button to change display user image into grid
    let gridButtton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        
        return button
    }()
    
    // Mark: button to change display user image into list
    let listButtton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
    }()
    
    // Mark: button to change display user image into ribbon
    let bookmarkButtton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
    }()
    
    // Mark: username label to display her name
    let usernameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    // Mark: number of user post's and i make it custom from 2 line
    let postsLabel: UILabel = {
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
       let label = UILabel()
       label.attributedText = attributedText
       label.textAlignment = .center
       label.numberOfLines = 0
        
       return label
    }()
    
    // Mark: number of user follower's and i make it custom from 2 line
    let followersLabel: UILabel = {
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "follower", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        let label = UILabel()
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    // Mark: number of user following and i make it custom from 2 line
    let followingLabel: UILabel = {
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        let label = UILabel()
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    //Mark: edit user profile data button
    let editProfileButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("EditProfile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    //Mark: add user profile image, username and edit profile image and setup all view's into main class function and it's constrain
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 3
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButtton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStatsView()
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
        
    }
    
    //Mark: add user status information like number of posts, number of followers and number of following into stackview and it's constrain
    fileprivate func setupUserStatsView () {
        
        let stackview = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackview.distribution = .fillEqually
        addSubview(stackview)
        stackview.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
        
    }
    
    //Mark: add user image's information and it's cattogray like grid display information's , list display information's and bookmark information's into stackview and it's constrain
    fileprivate func setupBottomToolbar () {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButtton, listButtton, bookmarkButtton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
    }
    //Mark: fetch user profile image from model
    fileprivate func setupProfileImage() {
        
        guard let profileImageUrl = user?.profileImageUrl else {return}
        guard let url = URL(string: profileImageUrl) else { return}
        
        URLSession.shared.dataTask(with: url ) { (data, response, error) in
            
            // check for the error , then construct the image using data
            if let error = error{
                print("Failed to fetch profile image", error.localizedDescription)
                return
            }
            
            // perhaps check for response status of 200 (HTTP OK)
            
            guard let data = data else{return}
            let image = UIImage(data: data)
            
            // need to get back onto  the main UI thread
            DispatchQueue.main.async {
                self.profileImageView.image = image
                
               }
            }.resume()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
