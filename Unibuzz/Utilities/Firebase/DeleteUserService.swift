//
//  DeleteUserService.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/10/22.
//

import Foundation
import Firebase


class DeleteUserService {
    
    public static var shared = DeleteUserService()
    
    internal func reauthenticateUser(_ password: String,completion: @escaping(String?) -> Void) {
        let user = Auth.auth().currentUser
        let userEmail = Auth.auth().currentUser?.email ?? ""
        let credential = EmailAuthProvider.credential(withEmail: userEmail, password: password)
        user?.reauthenticate(with: credential) { result, error  in
          if let error = error {
              completion("\(error.localizedDescription)")
          } else {
              completion(nil)
          }
        }
    }
    
    internal func deleteUser(completion: @escaping(String?)->Void) {
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
