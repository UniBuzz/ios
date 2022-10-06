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
    var dataService: DataService = DataService()
    var universityList: [University] = []
    var updateUniversityView: (() -> Void)?
    var universitySelected: University?
    
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
    
    func getUniversityList() {
        service.getUniversity { result in
            switch result {
            case .success(let querySnapshot):
                for document in querySnapshot.documents{
                    let university = University(dictionary: document.data())
                    self.universityList.append(university)                    
                }
                self.updateUniversityView?()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func getUniversityImage(link: String, completion: @escaping (Data) -> Void) {
        dataService.getUniversityImage(imageLink: link) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func sendVerificationEmail() {
        service.sendVerificationEmail { error in
            print("DEBUG EMAIL VERIFICATION: \(error)")
        }
    }
    
    
    
    
}
