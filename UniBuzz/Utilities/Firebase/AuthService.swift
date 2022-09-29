//
//  AuthFirebase.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 28/09/22.
//

import Firebase

class AuthService {
    
    public static let shared = AuthService()
    
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult,Error>) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            if let result = result {
                let userFirebase = result
                print(userFirebase)
                completion(.success(userFirebase))
            }
        }
        
    }
    
    
    func registerUser(withEmail email: String, pseudo: String, password: String, completion: @escaping ((Result<[String:Any],Error>) -> Void)){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            if let result = result {
                
                let uid = result.user.uid
                let data = ["email" : email, "pseudoname" : pseudo, "uid" : uid] as [String : Any]
                
                self.saveUserToCollection(uid: uid, data: data) { err in
                    completion(.failure(err))
                }
                completion(.success(data))
            }
        }
    }
    
    private func saveUserToCollection(uid: String, data: [String:Any], completion: @escaping (Error) -> Void){
        Firestore.firestore().collection("users").document(uid).setData(data) { error in
            if let error = error {
                completion(error)
            }
        }
        
    }
    
}
