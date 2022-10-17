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
    var service: LoginService
    
    var errorPresentView: ((Error) -> Void)?
    var authSuccess: (() -> Void)?
    var notVerified: (() -> Void)?
    
    init(user: User? = nil, loginService: LoginService = LoginService()) {
        self.user = user
        self.service = loginService
    }    
    
    func signIn(withEmail email: String, password: String){
        service.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                if self.service.checkEmailVerified() {
                    ServiceConstant.universityName = user.university
                    UserDefaults.standard.set(user.university, forKey: "university")
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
        service.sendVerificationEmail { error in
            self.errorPresentView?(error)
        }
        service.logOut()
    }
    
    
    
}
