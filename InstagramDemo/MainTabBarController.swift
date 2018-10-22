//
//  MainTabBarController.swift
//  InstagramDemo
//
//  Created by MOAMEN on 7/26/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        
           super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            
            // show if not logged in
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
               self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setupViewControllers()
        
    }
    
    func setupViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        let userProfileCollectionVC = UserProfileCollectionVC(collectionViewLayout: layout)
        
        //Mark: root VC "main VC" that open when user is login into app
        let navigationController = UINavigationController(rootViewController: userProfileCollectionVC)
        navigationController.tabBarItem.image = UIImage(named: "profile_unselected")
        navigationController.tabBarItem.selectedImage =  UIImage(named: "profile_selected")
        
        viewControllers = [navigationController, UIViewController()]
        
    }
}
