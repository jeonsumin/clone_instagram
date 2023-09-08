//
//  HomePostCell.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/01.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didTapLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    //MARK: - Propreties
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            likeButton.setImage(post?.hasLiked == true ? UIImage(named: "like_selected") : UIImage(named: "like_unselected"), for: .normal)
            
            photoImageView.loadImage(urlString: postImageUrl)
            
            usernameLabel.text = "TEST USERNAME"
            usernameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
//            captionLabel.text = post?.cation
            setupAttributedCaption()
        }
    }
    
    // 프로필 썸네일
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    // 게시글 이미지
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // 사용자 이름
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    // 더보기 버튼
    let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    // 좋아요 버튼
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    // 댓글 버튼
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    //DM버튼
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    // 북마크 버튼
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    // 게시글 설명
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
    
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        [userProfileImageView,usernameLabel,optionButton,photoImageView].forEach{ addSubview($0)}
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBotton: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBotton: 0, paddingRight: 0, width: 0, height: 0)
        
        optionButton.anchor(top: topAnchor,
                            left: nil,
                            bottom: photoImageView.topAnchor,
                            right: rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBotton: 0,
                            paddingRight: 0,
                            width: 44,
                            height: 0)
        photoImageView.anchor(top: userProfileImageView.bottomAnchor,
                              left: leftAnchor,
                              bottom: nil,
                              right: rightAnchor,
                              paddingTop: 8,
                              paddingLeft: 0,
                              paddingBotton: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor,multiplier: 1).isActive = true
        
        setupActionButtons()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBotton: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Function
    /**
     게시글 설명 타이틀 텍스트 속성 설정
     */
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        
        let attributedText = NSMutableAttributedString(string: post.user.username ,attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.cation)",attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.createDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay,attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.gray]))
    
        self.captionLabel.attributedText = attributedText
    }
    
    /**
     게시글 액션 버튼 스택뷰 설정
     
     좋아요, 댓글,DM 버튼
     */
    fileprivate func setupActionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendMessageButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBotton: 0, paddingRight: 0, width: 120, height: 50)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 40, height: 50)
    }
    
    //MARK: - Action Selector Methods
    @objc func handleComment(){
        guard let post = self.post else { return }
        delegate?.didTapComment(post: post )
    }
    
    @objc func handleLike(){
        print("handling like from within cell")
        delegate?.didTapLike(for: self)
    }
}
