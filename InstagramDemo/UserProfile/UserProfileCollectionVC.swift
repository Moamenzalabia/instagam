//
// UserProfileCollectionVC.swift
//  InstagramDemo
//
//  Created by MOAMEN on 7/26/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import UIKit
import Firebase

class UserProfileCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user :User?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogOutButton()
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
                }
                
                

            }catch let signOutError {
                print("Failed to sign out", signOutError.localizedDescription)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.0540627608, blue: 0.2489752357, alpha: 1)
        
        return cell
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
      
        let width = (view.frame.width - 2 ) / 3
        
        return CGSize(width: width, height: width)
    }
    
    //Mark: custom collection view header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        
        return header
    }
    
    //Mark: custom collection view header size = 200
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return  CGSize(width: view.frame.width, height: 200)
        
    }
    
    //Mark: retraive and fetch user data from firebase
    fileprivate func fetchUser() {
        
        Database.database().reference().child("users").observeSingleEvent(of: .childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any]  else {return}
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user!.username
            self.collectionView.reloadData()
            
            }) { (error) in
                print("Failed to fetch user: ", error.localizedDescription)
        }
       
    }
}
