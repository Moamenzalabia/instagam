// UserProfileCollectionVC.swift
//  InstagramDemo
//  Created by MOAMEN on 7/26/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Firebase

class UserProfileCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
  
    let cellId = "cellId"
    let homePhotoCellId = "homePhotoCellId"
    var userId: String?
    var isGridView = true
    var header: UserProfileHeaderCell?
    
    func didChangeToGridView() {
        isGridView = true
        collectionView.reloadData()
    }
    
    func didChangeToListView() {
        isGridView = false
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomePhotoCell.self, forCellWithReuseIdentifier: homePhotoCellId)
        setupLogOutButton()
        fetchUser()
        //fetchOrderedPosts()
        fetchFollowingUser()
    }
    
    var posts = [Post]()
    var followwingCount: Int?
    var followerCount: Int?
    
    fileprivate func fetchFollowingUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref =  Database.database().reference().child("following")
        ref.observeSingleEvent(of: .value) { (followerSnapshot) in
            if let userFollowDictionary = followerSnapshot.children.allObjects as? [DataSnapshot] {
                for user in userFollowDictionary{
                    if user.key == uid {
                        guard let userFollowingDictionary = user.value as? [String: Any] else { return }
                        self.followwingCount = userFollowingDictionary.count
                    }
                    let valueDic = user.value as! [String: Any]
                    for v in valueDic {
                        if v.key == uid {
                            guard let userFollowerDictionary = user.value as? [String: Any] else { return }
                            self.followerCount = userFollowerDictionary.count
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func fetchOrderedPosts() {
        
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        //perhaps later on we well implement some pagination of data
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let postsDictionaries = snapshot.value as? [String: Any] else { return }
            
            guard let user = self.user else { return }
            
            let post = Post(user: user, dictionary: postsDictionaries)
            self.posts.insert(post, at: 0)
            self.collectionView?.reloadData()
            
        }) { (error) in
            print("Failed to fetch ordered posts: ", error.localizedDescription)

        }
        
    }
    
    fileprivate func setupLogOutButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        
    }
    
    @objc func handleLogOut()  {

        let alertController = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do{
                try Auth.auth().signOut()
                // what's happens? we need to present some kind of login controller
                DispatchQueue.main.async {
                    let loginVC = LoginVC()
                    let navigation = UINavigationController(rootViewController: loginVC)
                    UIApplication.shared.keyWindow?.rootViewController = navigation
                   // self.present(navigation, animated: true, completion: nil)
                }
            }catch let signOutError {
                print("Failed to sign out", signOutError.localizedDescription)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isGridView{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
             cell.post = posts[indexPath.item]
             return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePhotoCellId, for: indexPath) as! HomePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    //Mark: vertical space between cell's is one pixel
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    //Mark: herzontal space between cell's is one pixel
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    //Mark: cell size and number cell in each row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        if isGridView{
             let width = (view.frame.width - 2 ) / 3
             return CGSize(width: width, height: width)
        } else {
            var height: CGFloat = 50 + 8 + 8 // username + userprofileimageview + there's padding
            height += view.frame.width
            height += 50     // like,comment,bookmark button's
            height += 60   // caption label
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    //Mark: custom collection view header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeaderCell
        header.user = self.user
        header.postsNumber = self.posts
        header.followingNumber = self.followwingCount
        header.followerNumber = self.followerCount
        header.delegate = self
        return header
    }
    
    //Mark: custom collection view header size = 200
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return  CGSize(width: view.frame.width, height: 200)
        
    }
    
    var user :User?
    //Mark: retraive and fetch user data from firebase
    fileprivate func fetchUser() {
        
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user!.username
            self.fetchOrderedPosts()
            self.collectionView.reloadData()
        }
        
    }
    
}
