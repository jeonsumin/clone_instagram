//
//  SharePhotoController.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/01.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    //MARK: - Properties
    
    // 노티피케이션 이름 프로퍼티스
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    // 게시글 선택된 이미지
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 게시글 필드
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    //선택된 이미지
    var selectImage: UIImage?{
        didSet{
            imageView.image = selectImage
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    
    //MARK: - Function
    /**
     이미지 및 게시글 텍스트박스 뷰 설정
     */
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
    
    /**
     작성된 게시글 저장
     
     파이어베이스 이미지및 게시글 저장
     */
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String){
        guard let postImage = selectImage else { return }
        guard let caption = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userPostRef = Database.database().reference().child("posts/\(uid)")
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imgeHeight": postImage.size.height,"creationDate":Date().timeIntervalSince1970] as [String:Any]
        
        ref.updateChildValues(values) { error, ref in
            if let err = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print(" Failed to save post to DB ", err)
                return
            }
            
            print("Successfully save post to db")
            self.dismiss(animated: true)
            
            //노티피케이션 설정
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
    
    //MARK: - Action Selector Methods
    /**
     게시 버튼 액션 메소드
     
     posts 하위에 uid를 기준으로 이미지url, 게시글 저장
     */
    @objc func handleShare() {
        guard let image = selectImage else { return }
        
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("posts/\(filename)").putData(uploadData) { metadata, error in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post Image : ", error)
                return
            }
            
            Storage.storage().reference().child("posts/\(filename)").downloadURL { url, error in
                if let error = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to upload post Image Url : ", error )
                    return
                }
                
                
                guard let imageUrl = url?.absoluteString else { return }
                print("successfully upload post image url",imageUrl)
                
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
                
            }
        }
    }
}
