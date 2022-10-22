//
//  ProfileService.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/10/22.
//


import Firebase


class ProfileService {
    
    public static let shared = ProfileService()
    
    internal func fetchUser(withUid uid: String, completion: @escaping (User)->Void) {
        ServiceConstant.COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}
