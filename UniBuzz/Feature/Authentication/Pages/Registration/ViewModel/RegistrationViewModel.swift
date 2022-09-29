//
//  RegistrationViewModel.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 28/09/22.
//

import Foundation
import Firebase

class RegistrationViewModel {
    
    var errorRegisterView: ((Error) -> Void)?
    var successRegisterView: (() -> Void)?
    var service: AuthService
    
    init(service: AuthService = AuthService()) {
        self.service = service
    }
    
    func registerUser(withEmail email: String, pseudo: String, password: String){
        
        service.registerUser(withEmail: email, pseudo: pseudo, password: password) { result in
            switch result {
            case .success(_):
                self.successRegisterView?()
            case .failure(let failure):
                print(failure)
                self.errorRegisterView?(failure)
            }
        }
       
    }
}
