//
//  UserProfileController.swift
//  instagramFireBase
//
//  Created by Terry on 2023/08/29.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {

    //MARK: - Properties
    var user: User?
    let cellId = "cellId"
    let homePostCellId = "homePostCellId"
    var isFinishingPaging = false
    var posts = [Post]()
    var userId: String?
    var isGridView = true
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUser()
        
        //register 채택
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        setupLogOutButton()
//        fetchOrderPosts()
    }
    
    //MARK: - Function
    /**
     사용자 가져오기 
     
     로그인 된 사용자 정보 가져오와서 해당 사용자의 포스터 리스트 가져오기
     */
    func fetchUser(){
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
            
            // 사용자
            self.paginationPost()
        }
    }
    
    /**
     네비게이션바에 로그아웃버튼 추가 메소드
     */
    fileprivate func setupLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    /**
     포스트 리스트 가져오기
     
     파이어베이스에서 포스트 리스트 가져오기
     */
    fileprivate func fetchOrderPosts() {
        guard let uid = self.user?.uid else { return }
        
        let ref = Database.database().reference().child("posts/\(uid)")
        
        // queryOrdered byChild를 기준으로 정렬된 값들을 가져온다.
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            
            guard let user = self.user else { return }
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post,at:0)
            
            self.collectionView.reloadData()
            
        } withCancel: { error in
            print("Faild to fetch posts : " ,error )
        }

    }
    
    fileprivate func paginationPost(){
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts/\(uid)")
        
        var query  = ref.queryOrderedByKey()
        if posts.count > 0 {
            let value = posts.last?.id
            query = query.queryStarting(atValue: value)
        }
        query.queryLimited(toFirst: 4).observeSingleEvent(of: .value) { snapshot in
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            if allObjects.count < 4 {
                self.isFinishingPaging = true
            }
            
            if self.posts.count > 0 {
                allObjects.removeFirst()
            }
            
            guard let user = self.user else { return }
            allObjects.forEach{ snapshot in
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                
                self.posts.append(post)
            }
            
            self.posts.forEach{ post in
                print(post.id)
            }
            self.collectionView.reloadData()
        }
        
    }
    
    //MARK: - Action Selector Methods
    /**
     로그아웃 핸들링 메소드
     
     파이어베이스의 로그아웃
     */
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
//MARK: - CollectionView Delegate / Datasource / FlowLayout / headear
extension UserProfileController:UICollectionViewDelegateFlowLayout {
    
    // 컬렉션 셀의 개수 설정
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // 컬렉션 셀의 컨텐트 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == self.posts.count - 1 && !isFinishingPaging {
            paginationPost()
        }
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
        
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
        if isGridView{
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            var height: CGFloat = 40 + 8 + 8 // 사용자이름 + 유저썸네일 높이
            height += view.frame.width // 게시글 이미지 높이
            height += 50 // 좋아요,커멘트,메시지 버튼 섹션
            height += 60 // 커맨트 섹션
            
            return CGSize(width: view.frame.width, height: height)
        }
    }

    // 컬렉션뷰의 header 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate = self
        return header
    }
    
    // 컬렉션뷰의 header 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    
}

//MARK: - Grid / list View Delegate
extension UserProfileController: UserProfileHeaderDelegate {
    
    func didChangeToGridView() {
        isGridView = true
        collectionView.reloadData()
    }

    func didChangeToListView() {
        isGridView = false
        collectionView.reloadData()
    }
}
 
