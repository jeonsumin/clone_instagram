//
//  Post.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/01.
//

import UIKit

struct Post{
    let imageUrl :String
    
    init(dictionary: [String:Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? "" 
    }
}
