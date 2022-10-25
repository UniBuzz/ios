//
//  ProfileViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 09/10/22.
//

import Foundation
import Firebase

class ProfileViewModel {
    
    func fetchCurrentUser(completion: @escaping(User)->Void) {
        let uid = Auth.auth().currentUser?.uid
        ProfileService.shared.fetchUser(withUid: uid ?? "") { user in
            completion(user)
        }
    }
}
