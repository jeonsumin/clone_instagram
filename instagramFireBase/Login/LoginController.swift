//
//  LoginController.swift
//  instagramFireBase
//
//  Created by deepvisions on 2023/08/30.
//

import UIKit

class LoginController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Instagram_logo_white")
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system )
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("계정이 없으신가요? 회원가입", for: .normal)
        button.addTarget(self, action: #selector(handlShowSignUp), for: .touchUpInside)
        return button
    }()
    
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
    
    @objc func handlShowSignUp(){
        let signUpController = SignupController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
}
