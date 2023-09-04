//
//  UserSearchCell.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/04.
//

import UIKit

class UserSearchCell: UICollectionViewCell {

    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        [profileImageView,usernameLabel].forEach{
            addSubview($0)
        }
        profileImageView.anchor(top: nil,
                                left: leftAnchor,
                                bottom: nil,
                                right: nil,
                                paddingTop: 0,
                                paddingLeft: 8,
                                paddingBotton: 0,
                                paddingRight: 0,
                                width: 50,
                                height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBotton: 0, paddingRight: 0, width: 0, height: 0)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
