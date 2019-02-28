//  HomeCollectionVC.swift
//  InstagramDemo
//  Created by MOAMEN on 8/27/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Firebase

class HomeCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePhotoCellDelegate {
   
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoVC.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView?.register(HomePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        setupNavigationItems()
        fetchAllPosts()
    }
    
    @objc fileprivate func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc fileprivate func handleRefresh() {
        posts.removeAll()
        collectionView.reloadData()
        fetchAllPosts()

    }
    
    fileprivate func fetchAllPosts() {
        
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        
         guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value
            , with: { (snapshot) in
                
                guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
                userIdsDictionary.forEach({ (key, value) in
                    Database.fetchUserWithUID(uid: key, completion: { (user) in
                        
                        self.fetchPostsWithUser(user: user)
                        
                    })
                    
                })
                
        }) { (error) in
            print("Failed to fetch following user Ids: ", error.localizedDescription)
            
        }
        
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
        
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        
        let ref = Database.database().reference().child("posts").child(user.uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
    
            self.collectionView?.refreshControl?.endRefreshing()
        
            guard let postsDictionaries = snapshot.value as? [String: Any] else { return }
            
            postsDictionaries.forEach({ (key ,value) in
                guard let valueDictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: valueDictionary)
                post.Id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observe(.value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    }else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort(by: { (post1, post2) -> Bool in
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
    
    func setupNavigationItems() {
        
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal
            ), style: .plain, target: self, action: #selector(handleCamera))
        
    }
    
    @objc fileprivate func handleCamera() {

        let camreaContoller = CameraVC()
        present(camreaContoller, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 50 + 8 + 8 // username + userprofileimageview + there's padding
        height += view.frame.width
        height += 50     // like,comment,bookmark button's
        height += 60   // caption label
        return CGSize(width: view.frame.width, height: height)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePhotoCell
        cell.delegate = self
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
        }
        
        return cell
    }
    
    // go to commentCollectionView Screen
    func didTabComment(post: Post) {
        let commentsController = CommentsCollectionVC(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didLike(for cell: HomePhotoCell) {

        guard let indexPath = collectionView.indexPath(for: cell) else{ return }
        var post = posts[indexPath.item]
        print(post.caption!)
        
        guard let postId = post.Id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid: post.hasLiked == true ? 1 : 0]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, _) in
           if let error = error {
                print("Failed to like post", error.localizedDescription)
                return
            }
            print("Successfully liked post")
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
        
    }


}
