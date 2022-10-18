//
//  RegistrationViewModel.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 28/09/22.
//

import Foundation
import Firebase

class RegistrationViewModel {
    
    //Properties
    var service: AuthService
    var dataService: DataService = DataService()
    var universityList: [University] = []
    var universitySelected: University? {
        didSet {
            enableButton?()
        }
    }
    
    //For Updating View Properties
    var updateUniversityView: (() -> Void)?
    var enableButton: (() -> Void)?
    var errorRegisterView: ((Error) -> Void)?
    var successRegisterView: (() -> Void)?
    var errorEmailNotValid: (() -> Void)?
    var pseudonameNotPassed: (() -> Void)?
    var pseudonameExists: (() -> Void)?
    
    
    init(service: AuthService = AuthService()) {
        self.service = service
    }
    
    func registerUser(withEmail email: String, pseudo: String, password: String){
        
        if !checkPseudoNameCount(pseudo: pseudo){
            return
        }
        
        if pseudo.contains(" ") {
            pseudonameNotPassed?()
            return
        }
        
        guard let universitySelected = universitySelected else { return }
        if !email.contains(universitySelected.domain) {
            self.errorEmailNotValid?()
            return
        }
        
        service.registerUser(withEmail: email, pseudo: pseudo, university: universitySelected.shortname, password: password) { result in
            switch result {
            case .success(_):
                self.successRegisterView?()
            case .failure(let failure):
                if failure as? AuthError == AuthError.pseudonameExists {
                    self.pseudonameExists?()
                } else {
                    self.errorRegisterView?(failure)
                }
            }
        }
       
    }
    
    func checkPseudoNameCount(pseudo: String) -> Bool{
        if pseudo.count < 2 || pseudo.count > 20 {
            pseudonameNotPassed?()
            return false
        }
        return true
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
