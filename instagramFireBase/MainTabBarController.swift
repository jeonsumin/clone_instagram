//
//  MainTabBarController.swift
//  instagramFireBase
//
//  Created by Terry on 2023/08/29.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.delegate = self
        
        // 로그인 여부 확인
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
    
    //MARK: - Function
    /**
     탭바 아이탬 선택시 활성화 비활성화 메소드
     */
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectContoller = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectContoller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
            return false
        }
        return true
    }
    
    /**
     탭바의 아이템 View 설정
     */
    func setupViewControllers(){
        
        // 홈 탭
        let homeNavController = templateNavController(unselectedImage: UIImage(named: "home_unselected")!,
                                                      selectedImage: UIImage(named: "home_selected")!,
                                                      rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        // 검색 탭
        let searchNavController = templateNavController(unselectedImage: UIImage(named: "search_unselected")!,
                                                        selectedImage: UIImage(named: "search_selected")!,
                                                        rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        )
        
        // 사진추가 탭
        let plusNavController = templateNavController(unselectedImage: UIImage(named: "plus_unselected")!,
                                                      selectedImage: UIImage(named: "plus_unselected")!)
        // 좋아요 탭
        let likeNavController = templateNavController(unselectedImage: UIImage(named: "like_unselected")!,
                                                      selectedImage: UIImage(named: "like_selected")!)
        
        // 프로필 탭
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
    
    /**
     네비게이션 뷰컨트롤러 탬플릿 설정
     */
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage:UIImage, rootViewController:UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.image = unselectedImage
        
        return navController
    }
}
