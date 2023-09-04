//
//  FirebaseUtils.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/04.
//

import Foundation
import Firebase


extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> () ){
        print("FEtching user with uid: ", uid)
        
        Database.database().reference().child("users/\(uid)").observeSingleEvent(of: .value) { snapshot in
            guard let userDictionary = snapshot.value as? [String:Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        } withCancel: { error in
            print("Faild to fetch user for posts", error)
        }
    }
}
