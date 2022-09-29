//
//  LoginViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 23/09/22.
//

import Foundation
import Firebase

class LoginViewModel {
    
    var user: User?
    var authService: AuthService
    
    var errorPresentView: ((Error) -> Void)?
    var authSuccess: (() -> Void)?
    
    init(user: User? = nil, authService: AuthService = AuthService()) {
        self.user = user
        self.authService = authService
    }    
    
    func signIn(withEmail email: String, password: String){
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                self.errorPresentView?(error)
//            }
//            if let result = result {
//                self.authSuccess?()
//            }
//
//        }
        
        authService.signIn(email: email, password: password) { result in
            switch result {
            case .success(_):
                self.authSuccess?()
            case .failure(let error):
                self.errorPresentView?(error)
            }
        }
    }
    
    
}
