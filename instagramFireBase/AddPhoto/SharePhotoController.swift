//
//  SharePhotoController.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/01.
//

import UIKit

class SharePhotoController: UIViewController {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    var selectImage: UIImage?{
        didSet{
            imageView.image = selectImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    fileprivate func setupImageAndTextViews(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         bottom: nil,
                         right: view.rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 0,
                         paddingBotton: 0,
                         paddingRight: 0,
                         width: 0,
                         height: 100)
        
        [imageView,textView].forEach{
            containerView.addSubview($0)
        }
        
        imageView.anchor(top: containerView.topAnchor,
                         left: containerView.leftAnchor,
                         bottom: containerView.bottomAnchor,
                         right: nil,
                         paddingTop: 8,
                         paddingLeft: 8,
                         paddingBotton: 8,
                         paddingRight: 0,
                         width: 84,
                         height: 0)
        
        textView.anchor(top: containerView.topAnchor,
                        left: imageView.rightAnchor,
                        bottom: containerView.bottomAnchor,
                        right: containerView.rightAnchor,
                        paddingTop: 0,
                        paddingLeft: 4,
                        paddingBotton: 0,
                        paddingRight: 0,
                        width: 0,
                        height: 0)
        
    }
    
    @objc func handleShare() {
        print("sharing photo")
    }
}
