//
//  SearchCell.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/04.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    //MARK: - Properties
    // 게시글 데이터
    var posts: Post? {
        didSet{
            guard let urlString = posts?.imageUrl else { return }
            profileImageView.loadImage(urlString: urlString)
        }
    }
    
    //프로필 이미지
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    //MARK: - Init 
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor,
                                left: leftAnchor,
                                bottom: bottomAnchor,
                                right: rightAnchor,
                                paddingTop: 0,
                                paddingLeft: 0,
                                paddingBotton: 0,
                                paddingRight: 0,
                                width: 0,
                                height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
