//
//  LoginController.swift
//  instagramFireBase
//
//  Created by deepvisions on 2023/08/30.
//

import UIKit

class LoginController: UIViewController {
    
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
        
        view.addSubview(signUpButton)
        signUpButton.anchor(
            top: nil,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            paddingTop: 0,
            paddingLeft: 0,
            paddingBotton: 0,
            paddingRight: 0,
            width: 0,
            height: 50
        )
    }
    
    @objc func handlShowSignUp(){
        let signUpController = SignupController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
}
