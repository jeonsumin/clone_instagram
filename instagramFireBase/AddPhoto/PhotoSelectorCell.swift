//
//  PhotoSelectorCell.swift
//  instagramFireBase
//
//  Created by Terry on 2023/09/01.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    //MARK: - Properties
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(
            top: topAnchor,
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
