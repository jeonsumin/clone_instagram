//
//  MainTabBarController.swift
//  instagramFireBase
//
//  Created by Terry on 2023/08/29.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: false)
            }
            
            return
        }
        
        setupViewControllers()
        
    }
    func setupViewControllers(){
        
        //home
        let homeNavController = templateNavController(unselectedImage: UIImage(named: "home_unselected")!,
                                                      selectedImage: UIImage(named: "home_selected")!)
        //search
        let searchNavController = templateNavController(unselectedImage: UIImage(named: "search_unselected")!,
                                                        selectedImage: UIImage(named: "search_selected")!)
        
        //plus
        let plusNavController = templateNavController(unselectedImage: UIImage(named: "plus_unselected")!,
                                                      selectedImage: UIImage(named: "plus_unselected")!)
        
        let likeNavController = templateNavController(unselectedImage: UIImage(named: "like_unselected")!,
                                                      selectedImage: UIImage(named: "like_selected")!)
        
        //user Profile
        let userProfileNavController = templateNavController(unselectedImage: UIImage(named:"profile_unselected")!,
                                                             selectedImage: UIImage(named:"profile_selected")!,
                                                             rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))

        
        tabBar.tintColor = .black
        
        viewControllers = [
            homeNavController,
            searchNavController,
            plusNavController,
            likeNavController,
            userProfileNavController,
        ]
        
        guard let items = tabBar.items else { return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage:UIImage, rootViewController:UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.image = unselectedImage
        
        return navController
    }
}
