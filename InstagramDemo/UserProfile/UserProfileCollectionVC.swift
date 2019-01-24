//
// UserProfileCollectionVC.swift
//  InstagramDemo
//  Created by MOAMEN on 7/26/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import UIKit
import Firebase

class UserProfileCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    let cellId = "cellId"
    let homePhotoCellId = "homePhotoCellId"
    var userId: String?
    
    var isGridView = true
    
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
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomePhotoCell.self, forCellWithReuseIdentifier: homePhotoCellId)
        
        setupLogOutButton()
        fetchUser()
      //  fetchOrderedPosts()
        
    }
    
    var posts = [Post]()
    var isFinishedPaging = false
    
    fileprivate func paginatePosts() {
        
        guard let uid = self.user?.uid else {return}
        
        let ref = Database.database().reference().child("posts").child(uid)
        var query = ref.queryOrdered(byChild: "creationDate")
        
        if posts.count > 0{
            let value = posts.last?.creationDate?.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
            
            guard let user = self.user else {return}
            
            allObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return}
                var post = Post(user: user, dictionary: dictionary)
                post.Id = snapshot.key
                self.posts.append(post)
            })
            self.collectionView?.reloadData()
            
        }) { (error) in
            print("Failed to paginate for posts", error .localizedDescription)
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
                    print("loged out user")

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
        
        
        // show you how to fire off the paginate call
        if indexPath.item == self.posts.count - 1  && !isFinishedPaging{
            paginatePosts()
        }
        
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

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
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
            self.collectionView.reloadData()
            self.paginatePosts()
            
        }
        
    }
    
}
