//
//  Post.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/01.
//

import UIKit

struct Post{
    let user: User
    let imageUrl :String
    let cation: String
    
    init(user: User, dictionary: [String:Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.cation = dictionary["caption"] as? String ?? ""
    }
}
