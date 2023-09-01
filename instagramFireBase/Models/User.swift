//
//  User.swift
//  instagramFireBase
//
//  Created by deepvisions on 2023/09/01.
//

import Foundation

struct User{
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
