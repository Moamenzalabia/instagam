//
//  MainTabBarController.swift
//  InstagramDemo
//
//  Created by MOAMEN on 7/26/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil )
            
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        
           super.viewDidLoad()
        
           self.delegate = self
        
        /*
        if Auth.auth().currentUser == nil {
            // show if not logged in
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil)
            }
            
            return
            
        }*/
     
        setupViewControllers()
        
    }
    
    func setupViewControllers() {
        
        //home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"),  selectedImage: #imageLiteral(resourceName: "home_selected"),  rootViewController: HomeCollectionVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //search
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchCollectionVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //plus
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        //like
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        // user profile
        let userProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_selected"),  selectedImage: #imageLiteral(resourceName: "profile_selected"),  rootViewController: UserProfileCollectionVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController, userProfileNavController]
     
        // modify tab bar item insets to be in center of tab bar
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        UITabBar.appearance().tintColor = UIColor.black
        navController.tabBarItem.selectedImage = selectedImage
        return navController

    }
    
}
