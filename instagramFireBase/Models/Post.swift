//
//  Post.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/01.
//

import UIKit

struct Post{
    var id: String?
    
    let user: User
    let imageUrl :String
    let cation: String
    let createDate: Date
    
    var hasLiked = false
    
    init(user: User, dictionary: [String:Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.cation = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.createDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
