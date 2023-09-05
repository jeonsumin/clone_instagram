//
//  UserSearchController.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/04.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController{
    
    //MARK: - Properties
    let cellId = "cellId"
    var posts = [Post]()
    
    // 검색 필드
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        searchBar.barTintColor = .gray
        searchBar.delegate = self
        
        return searchBar
    }()
    
    // 검색 결과 View
    let userSearchView = SearchResultView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)

        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor,
                         left: navBar?.leftAnchor,
                         bottom: navBar?.bottomAnchor,
                         right: navBar?.rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 8,
                         paddingBotton: 0,
                         paddingRight: 8,
                         width: 0,
                         height: 0)
        
        searchBar.setValue("취소", forKey: "cancelButtonText")
        
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.alwaysBounceVertical = true
        
        userSearchView.alpha = 1
        view.addSubview(userSearchView)
        userSearchView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBotton: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
        
        userSearchView.alpha = 0
        
        userSearchView.delegate = self
        userSearchView.collectionView.keyboardDismissMode = .onDrag
        fetchPosts()
    }
    
    //MARK: - Function
    /**
     돋보기 게시글 가져오기
     */
    fileprivate func fetchPosts(){
        let ref = Database.database().reference().child("posts")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            dictionary.keys.forEach { users in
                Database.fetchUserWithUID(uid: users) { user in
                    self.fetchPostsWithUser(user: user)
                }
            }
        }
    }
    
    /**
     사용자의 게시글 가져오기 
     */
    fileprivate func fetchPostsWithUser(user: User){
        let ref = Database.database().reference().child("posts/\(user.uid)")
        ref.observeSingleEvent(of: .value) { snapshot  in
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            
            dictionaries.forEach{ key, value in
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            }
            self.collectionView.reloadData()
            
        } withCancel: { error in
            print("Faild to fetch posts : " ,error )
        }
    }
}

//MARK: - CollectionView Delegate
extension UserSearchController: UICollectionViewDelegateFlowLayout{
    
    // 셀 마진 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 컬렉션뷰 셀의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 ) / 3
        return CGSize(width: width, height: width)
    }
    
    // 컬렉션뷰 셀의 개수 설정
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // 컬렉션뷰 셀의 속성 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.posts = self.posts[indexPath.row]
        return cell
    }
    
}

//MARK: - SearchBar Delegate
extension UserSearchController: UISearchBarDelegate {
    
    /**
     검색 필드 값이 변경될때 호출되는 메소드
     
     검색어에 따라 컬렉션뷰 업데이트
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.userSearchView.filteredUsers = self.userSearchView.users.filter { user -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        }
        
        self.userSearchView.collectionView.reloadData()
        
    }
    
    // 검색필드의 취소 버튼 클릭시 호출 되는 메소드
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.userSearchView.alpha = 0
            self.collectionView.alpha = 1
        }
    }
    
    /**
     검색 필드가 활성화 될때 검색 뷰 show
     */
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.userSearchView.alpha = 1
        }
    }
    
}

extension UserSearchController: searchResultDelegate  {
    
    func didTappedSearchUserProfile(userId: String) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = userId
        self.navigationController?.pushViewController(userProfileController, animated: true)
    }
}
