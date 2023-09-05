//
//  SearchResultView.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/04.
//

import UIKit
import Firebase

protocol searchResultDelegate {
    /**
     검색 결과 탭 이벤트 
     */
    func didTappedSearchUserProfile(userId: String)
}

class SearchResultView: UIView{
    //MARK: - Properties
    var delegate: searchResultDelegate?
    
    // 프로필 이미지
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // 사용자 이름
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    let cellId = "cellId"
    
    // 컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    
    var users = [User]()
    var filteredUsers = [User]()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.delegate = self
        collectionView.dataSource = self
     
        addSubview(collectionView)
        
        collectionView.anchor(top: topAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBotton: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        
        fetchUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - Function
    /**
     사용자 가져오기
     
     파이어베이스 users 하위의 값 가져온다.
     */
    fileprivate func fetchUser() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            dictionaries.forEach{ key, value  in
                guard let userDictionary = value as? [String: Any] else { return }
                
                if key == Auth.auth().currentUser?.uid {
                    print("Found myself, omit from list")
                    return
                }
                
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            }
            
            self.users.sort { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            }
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }
    }
}

//MARK: - CollectionView Delegate
extension SearchResultView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    // 컬렉션뷰의 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 66)
    }
    
    // 컬렉션뷰의 셀 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    // 컬렉션뷰의 셀 속성 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        
        cell.user = filteredUsers[indexPath.row]
        
        return cell
    }
    
    // 컬렉션뷰의 셀 선택시 호출되는 메소드 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.item]
        delegate?.didTappedSearchUserProfile(userId: user.uid)
    }
}
