//
//  LoginService.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 11/10/22.
//

import Firebase


class LoginService {
    
    public static let shared = LoginService()
    private let firebaseAuth = Auth.auth()
    private let db = Firestore.firestore()
    
    func signIn(email: String, password: String, completion: @escaping (Result<User,Error>) -> Void){
        firebaseAuth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            if let result = result {
                self.getUserData(uid: result.user.uid) { result in
                    switch result {
                    case .success(let user):
                        completion(.success(user))
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                }
                
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
    
    func logOut() {
        if firebaseAuth.currentUser?.uid != nil{
            do {
                try firebaseAuth.signOut()
            } catch {
                print("Error for logout")
            }
        }
    }
    
    func checkEmailVerified() -> Bool {
        guard let verified = firebaseAuth.currentUser?.isEmailVerified else { return false }
        return verified
    }
    
    func forgotPassword(email: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        firebaseAuth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func getUserUniversity(uid: String, completion: @escaping (Result<String,Error>) -> Void) {
        let docRef = db.collection("users-uni").document(uid)
        
        docRef.getDocument { querySnapshot, error in
            if let error {
                print(error)
            }
            if let querySnapshot {
                guard let universityData = querySnapshot.data() else { return }
                let university = universityData["university"] as? String ?? ""
                completion(.success(university))
            }
        }
        
    }
    
    func getUserData(uid: String, completion: @escaping (Result<User,Error>) -> Void) {
        getUserUniversity(uid: uid) { result in
            switch result {
            case .success(let universityName):
                let docRef = self.db.collection("university").document(universityName).collection("users").document(uid)
                docRef.getDocument { querySnapshot, error in
                    if let error {
                        completion(.failure(error))
                    }
                    if let querySnapshot {
                        guard let userData = querySnapshot.data() else { return }
                        let user = User(dictionary: userData)
                        completion(.success(user))
                    }
                }
                
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
    }
    
}
