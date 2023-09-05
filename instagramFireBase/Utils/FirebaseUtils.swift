//
//  FirebaseUtils.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/04.
//

import Foundation
import Firebase


extension Database {
    /**
     UID 를 통해서 유저 정보 가져오기 
     */
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> () ){

        Database.database().reference().child("users/\(uid)").observeSingleEvent(of: .value) { snapshot in
            guard let userDictionary = snapshot.value as? [String:Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        } withCancel: { error in
            print("Faild to fetch user for posts", error)
        }
    }
}
