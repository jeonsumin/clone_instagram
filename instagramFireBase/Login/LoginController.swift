//
//  LoginController.swift
//  instagramFireBase
//
//  Created by Terry on 2023/08/30.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    //MARK: - Properties
    // 로고 이미지
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Instagram_logo_white")
        imageView.layer.masksToBounds = true
        
        return imageView
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

    //비밀번호 필드
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
    
    //로그인 버튼
    let loginButton: UIButton = {
        let button = UIButton(type: .system )
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    // 회원가입 버튼
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("계정이 없으신가요? 회원가입", for: .normal)
        button.addTarget(self, action: #selector(handlShowSignUp), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        setupinputFields()
        
        view.addSubview(signUpButton)
        
        signUpButton.anchor(
            top: loginButton.bottomAnchor,
            left: loginButton.leftAnchor,
            bottom: nil,
            right: loginButton.rightAnchor,
            paddingTop: 10,
            paddingLeft: 0,
            paddingBotton: 0,
            paddingRight: 0,
            width: 0,
            height: 50
        )
        
    }
    
    /**
     이메일, 비밀번호, 로그인 버튼 스택뷰 설정
     */
    func setupinputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
        view.addSubview(stackView)
        view.addSubview(logoImageView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        logoImageView.anchor(
            top: nil,
            left: stackView.leftAnchor,
            bottom: stackView.topAnchor,
            right: stackView.rightAnchor,
            paddingTop: 0,
            paddingLeft: 0,
            paddingBotton: -10,
            paddingRight: 0,
            width: 200,
            height: 143)
        stackView.anchor(
            top: nil,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            paddingTop: 0,
            paddingLeft: 40,
            paddingBotton: 0,
            paddingRight: 40,
            width: 0,
            height: 150
        )
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    /**
     회원가입 페이지 전환
     */
    @objc func handlShowSignUp(){
        let signUpController = SignupController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
    
    /**
     로그인 액션 메소드
     */
    @objc func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                print("Failed To sign n with Email", email)
                return
            }
            
            print("Successfully logged back in with user: ", user?.user.uid ?? "" )
            
            //appDelegate의 window를 가져온다
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true)
        }
    }
    
    /**
     텍스트 필드의 값이 변경될 때 호출되는 메소드
     
     로그인 버튼 활성화 여부
     */
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
        passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
}
