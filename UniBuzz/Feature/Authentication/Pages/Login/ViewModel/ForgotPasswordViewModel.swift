//
//  ForgotPasswordViewModel.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 11/10/22.
//

import Foundation


class ForgotPasswordViewModel {
    
    var errorPresentView: ((Error) -> Void)?
    var forgotPasswordSuccess: (() -> Void)?
    
    private let service: LoginService
    
    init(loginService: LoginService = LoginService()) {
        self.service = loginService
    }
    
    func forgotPassword(email: String) {
        service.forgotPassword(email: email) { result in
            switch result {
            case .success(let success):
                if success {
                    self.forgotPasswordSuccess?()
                }
            case .failure(let failure):
                self.errorPresentView?(failure)
            }
        }
    }
    
}
