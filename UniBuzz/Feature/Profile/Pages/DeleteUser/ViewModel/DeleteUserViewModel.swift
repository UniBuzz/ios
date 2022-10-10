//
//  DeleteUserViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 10/10/22.
//

import Firebase

class DeleteUserViewModel {
    func reauthenticateUser(_ password: String, completion: @escaping(String?) -> Void) {
        let user = Auth.auth().currentUser
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: userEmail, password: password)
        
        user?.reauthenticate(with: credential) { result, error  in
          if let error = error {
              completion("\(error.localizedDescription)")
          } else {
              completion(nil)
          }
        }
    }
    
    func deleteUser(completion: @escaping(String?)->Void) {
        let user = Auth.auth().currentUser
                user?.delete { error in
                  if let error = error {
                      completion(error.localizedDescription)
                  } else {
                      completion(nil)
                  }
                }
    }
}
