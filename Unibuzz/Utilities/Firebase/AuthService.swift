//
//  AuthFirebase.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 28/09/22.
//

import Firebase

enum AuthError: Error {
    case pseudonameExists
}

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
    
    
    func registerUser(withEmail email: String, pseudo: String, university: String, password: String, completion: @escaping ((Result<[String:Any],Error>) -> Void)){
        
        checkPseudonameExist(pseudoname: pseudo, university: university) { result in
            switch result {
            case .success(let exist):
                if exist {
                    completion(.failure(AuthError.pseudonameExists))
                } else {
                    self.firebaseAuth.createUser(withEmail: email, password: password) { result, error in
                        if let error = error {
                            completion(.failure(error))
                        }
                        if let result = result {
                            
                            let uid = result.user.uid
                            let data = ["pseudoname" : pseudo,
                                        "uid" : uid,
                                        "university": university,
                                        "upvotedFeeds": [],
                                        "honey": 1,
                                        "randomInt": Int.random(in: 0...9)] as [String : Any]
                            
                            self.saveUserToCollection(uid: uid, university:university, data: data) { err in
                                completion(.failure(err))
                            }
                            self.saveUserUniversity(uid: uid, university: university) { err in
                                completion(.failure(err))
                            }
                            completion(.success(data))
                        }
                    }
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    private func saveUserToCollection(uid: String, university: String, data: [String:Any], completion: @escaping (Error) -> Void){
        
        db.collection("university").document(university).collection("users").document(uid).setData(data) { error in
            if let error = error {
                completion(error)
            }
        }
        
    }
    
    private func saveUserUniversity(uid: String, university: String, completion: @escaping (Error) -> Void) {
        db.collection("users-uni").document(uid).setData(["university": university]) { error in
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
    
    func checkPseudonameExist(pseudoname: String, university: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        
        let docRef = db.collection("university").document(university).collection("users").whereField("pseudoname", isEqualTo: pseudoname).limit(to: 1)
        
        docRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            if let doc = querySnapshot?.documents, !doc.isEmpty {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
            
        }
    }
    
}
