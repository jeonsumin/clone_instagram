//
//  CommentCell.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/07.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet{
            
            guard let comment = comment else { return }
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSMutableAttributedString(string: " \(comment.text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            textView.attributedText = attributedText
            profileImageView.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    
    let textView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
//        label.numberOfLines = 0
        return textView
    }()
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBotton: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(textView)
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBotton: 4, paddingRight: 4, width: 0, height: 0)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
