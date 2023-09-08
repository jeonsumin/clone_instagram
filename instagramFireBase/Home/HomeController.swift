//
//  HomeController.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/01.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController{
    
    //MARK: - Properties
    let cellId = "CellId"
    var posts = [Post]()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleUpdate),
                                               name: SharePhotoController.updateFeedNotificationName,
                                               object: nil)
        
        view.backgroundColor = .white
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        setupNavigationItems()
        fetchAllPosts()
        
    }
    
    //MARK: - Function
    
    /**
     팔로우된 UID 가져오기
     
     파이어베이스의 following 하위의 UID  키값을 가져온다.
     */
    fileprivate func fetchFollowUserIds(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following/\(uid)").observeSingleEvent(of: .value) { snapshot in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach { key, value in
                Database.fetchUserWithUID(uid: key) { user in
                    self.fetchPostsWithUser(user: user)
                }
            }
        }
    }
    
    /**
     게시글 가져오기
     */
    fileprivate func fetchPosts(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    /**
     사용자의 게시글 가져오기
     
     파이어베이스 posts 하위의 uid 하위 값을 가져오기
     */
    fileprivate func fetchPostsWithUser(user: User){
        let ref = Database.database().reference().child("posts/\(user.uid)")
        ref.observeSingleEvent(of: .value) { snapshot  in
            self.collectionView.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach{ key, value in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                //like Event
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes/\(key)/\(uid)").observeSingleEvent(of: .value) { snapshot in
                    print(snapshot)
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    }else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    // 업로드시간 기준으로 정렬(내림차순)
                    self.posts.sort { (p1, p2) -> Bool in
                        return p1.createDate.compare(p2.createDate) == .orderedDescending
                    }
                    self.collectionView.reloadData()
                }
            }
            
            
            
            
        } withCancel: { error in
            print("Faild to fetch posts : " ,error )
        }
    }
    /**
     네비게이션바에 로고 설정
     */
    func setupNavigationItems(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    /**
     내 게시글과 팔로우한 사용자의 게시글 가져오기
     */
    fileprivate func fetchAllPosts(){
        fetchPosts()
        fetchFollowUserIds()
    }
    
    //MARK: - Action Selector Methods
    /**
     컬렉션 뷰 새로고침 액션 메소드
     */
    @objc func handleRefresh(){
        print("handle refresh")
        
        posts.removeAll()
        fetchAllPosts()
    }
    /**
     노티피케이션 액션
     
     게시글 업로드시 홈 화면의 게시글 업데이트
     */
    @objc func handleUpdate(){
        handleRefresh()
    }
    
    /**
     네비게이션 왼쪽 아이팀 액션
     
     카메라 호출 메서드
     */
    @objc func handleCamera(){
        print("Showing camera")
        
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        
        present(cameraController, animated: true)
    }
    
    
}
//MARK: - CollectionView Delegate
extension HomeController: UICollectionViewDelegateFlowLayout {
    
    //컬랙션 뷰의 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 // 사용자이름 + 유저썸네일 높이
        height += view.frame.width // 게시글 이미지 높이
        height += 50 // 좋아요,커멘트,메시지 버튼 섹션
        height += 60 // 커맨트 섹션
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    //컬렉션 셀의 개수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // 컬렉션뷰의 셀 속성 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        if posts.count > 0 {
            cell.post = posts[indexPath.item]
            
        }
        cell.delegate = self
        
        return cell
    }
}

extension HomeController: HomePostCellDelegate {
    func didTapLike(for cell: HomePostCell) {
        print("hanling like inside for controller ")
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        var post = posts[indexPath.item]
        
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes/\(postId)").updateChildValues(values) { err, ref in
            if let err = err {
                print("Faild to like post ", err)
                return
            }
            
            print("Successfully save like ")
            post.hasLiked = !post.hasLiked
            
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func didTapComment(post: Post) {
        print(post.cation)
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: commentController)
        commentController.post = post
        present(navController, animated: true)
    }
    
}
