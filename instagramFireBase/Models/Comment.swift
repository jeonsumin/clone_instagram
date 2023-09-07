//
//  Comment.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/07.
//

import Foundation

struct Comment {
    let text: String
    let uid: String
    
    init(dictionary:[String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
