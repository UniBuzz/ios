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
    
}
