//
//  CommentController.swift
//  instagramFireBase
//
//  Created by deepvisions on 2023/09/07.
//

import UIKit
import Firebase

class CommentController: UICollectionViewController {
    //MARK: - Properties
    var post: Post?
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height:50)
        
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("게시", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        containerView.addSubview(submitButton)
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBotton: 0, paddingRight: 0, width: 0, height: 0)
        
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: commentTextField.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 12, width: 50, height: 0)
        
    
        return containerView
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글달기"
        
        return textField
    }()
    
    
    override var inputAccessoryView: UIView? {
        return containerView
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
//        title = "댓글"
    }
    //MARK: - Function
    
    //MARK: - Action Selector Methods
    @objc func handleSubmit(){
        print("handling submit...", commentTextField.text ?? "" )
        print("post id", post?.id ?? "" )
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postId = post?.id ?? ""
        let values = [
            "text": commentTextField.text ?? "",
            "creationDate": Date().timeIntervalSince1970,
            "uid": uid
        ] as [String: Any]
        
        Database.database().reference().child("comments/\(postId)").childByAutoId().updateChildValues(values) { err, ref in
            if let err = err {
                print("Faild to insert comment : ", err)
                return
            }
            
            print("Successfully inserted comment. ")
        }
    }
}
