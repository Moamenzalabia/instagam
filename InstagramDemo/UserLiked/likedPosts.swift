//  likedPosts.swift
//  InstagramDemo
//  Created by MOAMEN on 12/1/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Firebase

private let reuseIdentifier = "likedCell"

class likedPosts: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePhotoCellDelegate {
    
    var likedPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.white
        navigationItem.title = "Your Liked Posts"
        self.collectionView!.register(HomePhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchLikedUser()

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedPosts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomePhotoCell
        cell.post = likedPosts[indexPath.row]
        return cell
    }
    
    func fetchLikedUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchLikedPost(user: user)
        }
    }
    
    func fetchLikedPost(user: User) {
        
        let ref = Database.database().reference().child("posts").child(user.uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            guard let postsDictionaries = snapshot.value as? [String: Any] else { return }
            
            postsDictionaries.forEach({ (key ,value) in
                guard let valueDictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: valueDictionary)
                post.Id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).observe(.value, with: { (snapshot) in
                    guard let userPostsLiked = snapshot.value as? [String: Any] else {return}
                    userPostsLiked.forEach({ (userKey ,value) in
                        if uid == userKey {
                            self.likedPosts.append(post)
                        }
                    })
                    self.likedPosts.sort(by: { (post1, post2) -> Bool in
                        return post1.creationDate?.compare(post2.creationDate!) == .orderedDescending
                    })
                    self.collectionView.reloadData()
                    
                }, withCancel: { (error) in
                    print("Failed to fetch like info for post", error.localizedDescription)
                })
            })
            
        }) { (error) in
            print("Failed to fetch posts: ", error.localizedDescription)
            
        }
    }
    
    
    func didTabComment(post: Post) {
        
    }
    
    func didLike(for cell: HomePhotoCell) {
        
    }
    

}
