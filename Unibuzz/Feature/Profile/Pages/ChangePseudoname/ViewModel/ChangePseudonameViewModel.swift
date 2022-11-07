//
//  ChangePseudonameViewModel.swift
//  Unibuzz
//
//  Created by Kevin ahmad on 07/11/22.
//

import Foundation
import Firebase

class ChangePseudonameViewModel {
    
    private let service = ProfileService.shared

    var pseudonameNotPassed: (() -> Void)?
    var pseudonameExists: (() -> Void)?
    
    func fetchCurrentUser(completion: @escaping(User)->Void) {
        let uid = Auth.auth().currentUser?.uid
        ProfileService.shared.fetchUser(withUid: uid ?? "") { user in
            completion(user)
        }
    }
    
    func checkPseudonameValid(pseudo: String) -> Bool{
        if pseudo.contains(" ") {
            pseudonameNotPassed?()
            return false
        }
        if pseudo.count < 2 || pseudo.count > 20 {
            pseudonameNotPassed?()
            return false
        }
        return true
    }
    
    func checkPseudonameExist(pseudo: String, completion: @escaping(Bool)->Void){
        fetchCurrentUser { user in
            self.service.checkPseudonameExist(pseudoname: pseudo, university: user.university) { result in
                switch result {
                case .success(let exist):
                    if exist {
                        self.pseudonameExists?()
                        completion(false)
                    } else {
                        completion(true)
                    }
                case .failure(_):
                    completion(false)
                }
            }
        }
    }
}
