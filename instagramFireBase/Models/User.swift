//
//  User.swift
//  instagramFireBase
//
//  Created by deepvisions on 2023/09/01.
//

import Foundation

struct User{

    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
