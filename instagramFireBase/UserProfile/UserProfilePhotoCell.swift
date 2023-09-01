//
//  UserProfilePhotoCell.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/01.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            postImageView.loadImage(urlString: imageUrl)
        }
    }
    let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor,
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
