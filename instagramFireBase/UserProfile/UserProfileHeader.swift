//
//  UserProfileHeader.swift
//  instagramFireBase
//
//  Created by Terry on 2023/08/30.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate{
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    //MARK: - Properties
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabrl.text = user?.username
            setupEditFollowButton()
        }
    }
    // 사용자 썸네일
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    // 그리드 형식 버튼
    lazy var gridButton: UIButton = {
        let button = UIButton(type:.system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    //TODO: 동영상 형식 버튼으로 변경 ( 동영상 리스트 바인딩)
    // 리스트 형식 버튼
    lazy var listButton: UIButton = {
        let button = UIButton(type:.system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        
        return button
    }()
    
    //북마크 버튼
    let bookmarkButton: UIButton = {
        let button = UIButton(type:.system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    //사용자 이름
    let usernameLabrl: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    // 게시글 정보
    let postsLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n",attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(
            NSAttributedString(string: "게시물",
                               attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,
                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                                           ]))
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    //팔로워수
    let follwersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n",attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(
            NSAttributedString(string: "팔로워",
                               attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,
                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                                           ]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    //팔로잉수
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n",attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(
            NSAttributedString(string: "팔로잉",
                               attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,
                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                                           ]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    //프로필 편집 / 팔로잉 / 팔로우 버튼
    let editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemGray5
        button.addTarget(self, action: #selector(handleEditProfileOrFollwow), for: .touchUpInside)
        
        return button
    }()
    
    // 프로필 공유하기 버튼
    let sharedProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("프로필 공유", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemGray5
        
        return button
    }()
   
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,
                                left: self.leftAnchor,
                                bottom: nil,
                                right: nil,
                                paddingTop: 12,
                                paddingLeft: 12,
                                paddingBotton: 0,
                                paddingRight: 0,
                                width: 80,
                                height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        
        
        addSubview(usernameLabrl)
        usernameLabrl.anchor(
            top: profileImageView.bottomAnchor,
            left: leftAnchor,
            bottom: nil,
            right: rightAnchor,
            paddingTop: 4,
            paddingLeft: 12,
            paddingBotton: 0,
            paddingRight: 12,
            width: 0,
            height: 0
        )
        
        setupUserStatsView()
        
        setupProfileHandleView()
        setupBottomToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Function
    /**
     내 게시글 툴바 스택뷰 설정
     */
    fileprivate func setupBottomToolbar(){
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(
            top: editProfileFollowButton.bottomAnchor,
            left: leftAnchor,
            bottom: nil,
            right: rightAnchor,
            paddingTop: 10,
            paddingLeft: 0,
            paddingBotton: 0,
            paddingRight: 0,
            width: 0,
            height: 50
        )
        
    }
    
    /**
     포스트 / 팔로잉 / 팔로우 정보 스텍뷰 설정
     */
    fileprivate func setupUserStatsView(){
        let stackView = UIStackView(arrangedSubviews: [postsLabel,follwersLabel,followingLabel])
        
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(
            top: topAnchor,
            left: profileImageView.rightAnchor,
            bottom: nil,
            right: rightAnchor,
            paddingTop: 12,
            paddingLeft: 12,
            paddingBotton: 0,
            paddingRight: 12,
            width: 0,
            height: 50
        )
    }
    
    /**
     프로필 편집(팔로우/팔로잉) 버튼 , 공유 버튼 스택뷰 설정
     */
    fileprivate func setupProfileHandleView(){
        
        let stackView = UIStackView(arrangedSubviews: [editProfileFollowButton,sharedProfileButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        addSubview(stackView)
        stackView.anchor(
            top: usernameLabrl.bottomAnchor,
            left: usernameLabrl.leftAnchor,
            bottom: nil,
            right: rightAnchor,
            paddingTop: 14,
            paddingLeft: 0,
            paddingBotton: 10,
            paddingRight: 14,
            width: 0,
            height: 37
        )
        [editProfileFollowButton,sharedProfileButton].forEach{
            $0.layer.cornerRadius = 8
        }
        
    }
    
    /**
     파이어베이스 팔로잉 팔로우 체크
     */
    fileprivate func setupEditFollowButton(){
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            
        } else {
            
            //팔로잉 체크
            Database.database().reference().child("following/\(currentLoggedInUserId)/\(userId)").observeSingleEvent(of: .value) { snapshot in
                
                if let isFollowing = snapshot.value as? Int , isFollowing == 1 {
                    self.setupFollowingStyle()
                }else {
                    self.setupFollowStyle()
                }
            }
            
        }
        
        
    }
    
    /**
     팔로우 버튼 스타일 설정
     */
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("팔로우", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
    }
    
    /**
     팔로잉 버튼 스타일 설정
     */
    fileprivate func setupFollowingStyle() {
        self.editProfileFollowButton.setTitle("팔로잉", for: .normal)
        self.editProfileFollowButton.backgroundColor = .systemGray5
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
        
    }
    
    //MARK: - Action Selector Methods
    /**
     팔로잉 <-> 팔로우 핸들링 메소드
     
     파이어베이스 팔로우 저장 및 삭제
     */
    @objc func handleEditProfileOrFollwow(){
        print("Execute edit profile / follow / unfollow logic ")
        
        guard let currentLoggedInuserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "팔로잉" {
            //팔로잉 -> 팔로우
            Database.database().reference().child("following/\(currentLoggedInuserId)/\(userId)").removeValue { err, ref in
                if let err = err {
                    print("Failed to following user : ",err)
                    return
                }
                print("Successfully following user: ", self.user?.username ?? "" )
                
                self.setupFollowStyle()
            }
        } else { //팔로우 -> 팔로잉
            let ref = Database.database().reference().child("following/\(currentLoggedInuserId)")
            let values = [userId: 1]
            ref.updateChildValues(values) { err, ref in
                if let err = err {
                    print("Failed to follow user:", err)
                    return
                }
                
                print("Successfully Followed user: ", self.user?.username ?? "")
                self.setupFollowingStyle()
            }
        }
    }
    
    @objc func handleChangeToListView(){
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        
        delegate?.didChangeToListView()
    }
    
    @objc func handleChangeToGridView(){
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        
        delegate?.didChangeToGridView()
    }
}
