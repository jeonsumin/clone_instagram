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
    var comment = [Comment]()
    let cellId = "cellId"
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height:80)
        
        
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
        title = "댓글"
        let seperatorView = UIView()
        seperatorView.backgroundColor = .systemGray4
        view.addSubview(seperatorView)
        seperatorView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 0, height: 1)
        
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.register(CommentCell.self,forCellWithReuseIdentifier: cellId)
        
        fetchComments()
    }
    
    //MARK: - Function
    fileprivate func fetchComments(){
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments/\(postId)")
        ref.observe(.childAdded) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let comment = Comment(dictionary: dictionary)
            self.comment.append(comment)
            self.collectionView.reloadData()
            print(comment.text, comment.uid)
            
        }
    }
    
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

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comment.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = comment[indexPath.item]
        return cell
    }
}
