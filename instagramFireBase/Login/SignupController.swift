//
//  ViewController.swift
//  instagramFireBase
//
//  Created by Terry on 2023/08/29.
//

import UIKit
import Firebase

class SignupController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //MARK: - Properties
    
    // 이미지 추가 버튼
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo.png"), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    // 이메일 필드
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    //닉네임 필드
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    // 비밀번호 필드
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    // 회원가입 버튼
    let signUpButton: UIButton = {
        let button = UIButton(type: .system )
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: nil,
            bottom: nil,
            right: nil,
            paddingTop: 40,
            paddingLeft: 0,
            paddingBotton: 0,
            paddingRight: 0,
            width: 140,
            height: 140
        )
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
    }
    
    
    //MARK: - Function
    
    /**
     텍스트 필드 스택뷰 설정
     */
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField,signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: nil,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 40,
                         paddingBotton: 0,
                         paddingRight: 40,
                         width: 0,
                         height: 200)
    }
    
    /**
     로그인 버튼 핸들링
     
     파이어베이스( 인증,데이터베이스, 스토리지)를 활용하여 회원 정보 및 회원썸네일을 저장
     */
    @objc func handleSignUp(){
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }

        // 파이어베이스 사용자 인증 추가
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let err = error {
                print("Failed to create user : ", err)
                return
            }
            print("successfully create user : ", user?.user.uid)
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            //파이어베이스 스토리지에 프로필이미지 저장
            Storage.storage().reference().child("profile_images/\(filename)").putData(uploadData,metadata: nil,completion: { [weak self]metadata, error in
                if let error = error {
                    print("Failed to upload profile iamge: ",error)
                    return
                }
                // 스토리지에 저장된 프로필이미지의 url을 가져온다.
                Storage.storage().reference().child("profile_images/\(filename)").downloadURL { url, error in
                    if let error = error {
                        print("Fiald get proflie Download url ", error)
                        return
                    }
                    
                    guard let profileImageUrl = url?.absoluteString else { return }
                    guard let uid = user?.user.uid else { return }
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    let values = [uid: dictionaryValues]
                    
                    // 닉네임과 프로필이미지경로를 데이터베이스에 저장
                    Database.database().reference().child("users").updateChildValues(values) { error, ref in
                        if let err = error {
                            print("Failed to save user info into db: ", err)
                            return
                        }
                        print("Successfully saved user info to db")
                        
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        
                        mainTabBarController.setupViewControllers()
                        self?.dismiss(animated: true)
                    }

                }
                
                
            })
                
        }
    
    }
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
        passwordTextField.text?.count ?? 0 > 0 &&
        usernameTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .mainBlue()
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    /**
     Firebase storage 이미지 업로드
     */
    @objc func handlePlusPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editingImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage]as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true,completion: nil)
    }
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor?, bottom:NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat, paddingLeft: CGFloat, paddingBotton: CGFloat, paddingRight: CGFloat,
                width: CGFloat, height: CGFloat
    ){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBotton).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
