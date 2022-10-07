//
//  AuthFirebase.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 28/09/22.
//

import Firebase

class AuthService {
    
    public static let shared = AuthService()
    private let firebaseAuth = Auth.auth()
    private let db = Firestore.firestore()
    
    func getUniversity(completion: @escaping (Result<QuerySnapshot,Error>) -> Void) {
        let ref = db.collection("university-list")
        ref.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let querySnapshot = querySnapshot {
                completion(.success(querySnapshot))
            }
            
        }
    }
        
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult,Error>) -> Void){
        
        firebaseAuth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            if let result = result {
                let userFirebase = result
                completion(.success(userFirebase))
            }
        }
        
    }
    
    
    func registerUser(withEmail email: String, pseudo: String, password: String, completion: @escaping ((Result<[String:Any],Error>) -> Void)){
        firebaseAuth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            if let result = result {
                
                let uid = result.user.uid
                let data = ["email" : email, "pseudoname" : pseudo, "uid" : uid, "upvotedFeeds": []] as [String : Any]
                
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
    
    func sendVerificationEmail(completion: @escaping (Error) -> Void){
        if firebaseAuth.currentUser?.uid != nil && firebaseAuth.currentUser?.isEmailVerified == false {            firebaseAuth.currentUser?.sendEmailVerification(completion: { error in
                if let error = error {
                    completion(error)
                }
            })
        }
    }
    
}
