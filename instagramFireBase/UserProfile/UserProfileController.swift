//
//  UserProfileController.swift
//  instagramFireBase
//
//  Created by Terry on 2023/08/29.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUser()
        
        //register 채택
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogOutButton()
        
    }
    
    // 컬렉션 셀의 개수 설정
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    // 컬렉션 셀의 컨텐트 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .purple
        return cell
    }
    // top / bottom spacing 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //leading / trailing spacing 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //컬랙션 셀의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }


    // 컬렉션뷰의 header 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        
        return header
    }
    
    // 컬렉션뷰의 header 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    
    
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            print(snapshot.value ?? "" )
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
            
        } withCancel: { error in
            print("Faild To Fetch User: ",error)
        }

    }
    
    fileprivate func setupLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "로그아웃", style: .destructive,handler: { _ in
            do {
                try Auth.auth().signOut()
                //로그아웃시 로그인 컨트롤러로 화면전환
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
                
            }catch let signOutErr {
                print("Failed to sign out : ", signOutErr)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alertController, animated: true)
    }
}

struct User{
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
