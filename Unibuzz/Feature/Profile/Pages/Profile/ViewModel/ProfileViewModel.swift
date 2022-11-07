//
//  ProfileViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 09/10/22.
//

import Foundation
import Firebase

class ProfileViewModel {
    
    private let service = ProfileService.shared
    
    func fetchCurrentUser(completion: @escaping(User)->Void) {
        let uid = Auth.auth().currentUser?.uid
        ProfileService.shared.fetchUser(withUid: uid ?? "") { user in
            completion(user)
        }
    }
    
    internal func getCurrentUserHoney() async -> Int {
        let result = await service.getUserHoney()
        switch result {
        case let .success(honey):
            return honey
        case let .failure(error):
            print(error)
            return 0
        }
    }
    
    internal func decrementHoneyChangePseudoname() async {
        await service.decrementHoneyChangePseudoname()
    }
    
    internal func changePseudoname(newName: String) async {
        await service.changeUserPseudoname(newName: newName)
    }
    
}
