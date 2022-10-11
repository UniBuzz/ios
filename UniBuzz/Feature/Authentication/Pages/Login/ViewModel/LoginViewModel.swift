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
    var notVerified: (() -> Void)?
    
    init(user: User? = nil, authService: AuthService = AuthService()) {
        self.user = user
        self.authService = authService
    }    
    
    func signIn(withEmail email: String, password: String){
        authService.signIn(email: email, password: password) { result in
            switch result {
            case .success(_):
                if self.authService.checkEmailVerified() {
                    self.authSuccess?()
                } else {
                    self.notVerified?()
                }
            case .failure(let error):
                self.errorPresentView?(error)
            }
        }
    }
    
    func resendVerificationEmail() {
        authService.sendVerificationEmail { error in
            self.errorPresentView?(error)
        }
        authService.logOut()
    }
    
}
