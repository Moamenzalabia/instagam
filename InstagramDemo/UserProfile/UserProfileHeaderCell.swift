//  UserProfileHeader.swift
//  InstagramDemo
//  Created by MOAMEN on 7/26/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()

}

class UserProfileHeaderCell: UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    var followerNumber: Int? {
        didSet{
            let attributedText = NSMutableAttributedString(string: "\(followerNumber ?? 0 )\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "follower", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            
            followersLabel.attributedText = attributedText
        }
    }
    
    var followingNumber: Int? {
        didSet{
            let attributedText = NSMutableAttributedString(string: "\(followingNumber ?? 0 )\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            followingLabel.attributedText = attributedText
        }
    }
    
    var postsNumber = [Post]() {
        didSet {
            let attributedText = NSMutableAttributedString(string: "\(postsNumber.count)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            postsLabel.attributedText = attributedText
        }
    }
    
    //Mark: user object from  user model
    var user: User? {
        didSet{
            //Mark: fetch user profile image from model
            guard let profileImageUrl = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
        }
        
    }
    
    fileprivate func setupEditFollowButton () {
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            // edit Profile
        }else {
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value
                , with: { (snapshot) in
                    
                    if let isFollowing = snapshot.value as? Int , isFollowing == 1 {
                      //  guard let followingDictionary = snapshot.value as? [String: Any] else { return }
                        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                        
                    }else {
                        self.setupFollowStyle()
                    }
            }) { (error) in
                print("Failed to check if following: ", error.localizedDescription)
            
            }
        }
    }
    
    @objc func handleEditProfileOrFollow() {
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            //Unfollow
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (error, ref) in
                if let error = error {
                    print("Failed to Unfollow user: ", error.localizedDescription)
                    return
                }
                print("Successfully Unfollowed user: ", self.user?.username ?? "")
                self.setupFollowStyle()
            }
        }else {
            //follow
            let values = [userId: 1]
            Database.database().reference().child("following").child(currentLoggedInUserId).updateChildValues(values) { (error, ref) in
                if let error = error {
                    print("Failed to follow user: ", error.localizedDescription)
                    return
                }
                print("Successfully followed user: ", self.user?.username ?? "")
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = UIColor.white
                self.editProfileFollowButton.setTitleColor(.black , for: .normal)
            }
        }
    }
    
    
    fileprivate func setupFollowStyle() {
        
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(.white , for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    // Mark: user  profile image
    let profileImageView: CustomImageView = {
        
        let image = CustomImageView()
        
        return image
    }()
    
    // Mark: button to change display user image into grid
    lazy var gridButtton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToGridView(){
        gridButtton.tintColor = .mainBlue()
        listButtton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    
    // Mark: button to change display user image into list
    lazy var listButtton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToListView(){
      listButtton.tintColor = .mainBlue()
      gridButtton.tintColor = UIColor(white: 0, alpha: 0.2)
      delegate?.didChangeToListView()
    }
    
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
       let label = UILabel()
       label.textAlignment = .center
       label.numberOfLines = 0
        
       return label
    }()
    
    // Mark: number of user follower's and i make it custom from 2 line
    let followersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    // Mark: number of user following and i make it custom from 2 line
    let followingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    //Mark: edit user profile data button
    lazy var editProfileFollowButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("EditProfile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        
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
                
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
        
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
