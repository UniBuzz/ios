//
//  DeleteUserViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 10/10/22.
//

import Firebase

class DeleteUserViewModel {
    
    func reauthenticateUser(_ password: String, completion: @escaping(String?) -> Void) {
        DeleteUserService.shared.reauthenticateUser(password) { error in
            completion(error)
        }
    }
    
    func deleteUser(completion: @escaping(String?)->Void) {
        DeleteUserService.shared.deleteUser { error in
            completion(error)
        }
    }
    
    func deletePersistent() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}
