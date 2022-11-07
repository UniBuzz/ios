//
//  ProfileService.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/10/22.
//


import Firebase


class ProfileService {
    
    public static let shared = ProfileService()
    private let dbUsers = ServiceConstant.COLLECTION_USERS
    private let db = Firestore.firestore()

    internal func fetchUser(withUid uid: String, completion: @escaping (User)->Void) {
        ServiceConstant.COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    internal func getUserHoney() async -> Result<Int,CustomFeedError> {
        let honeyKey = "honey"
        let currentUseruid = Auth.auth().currentUser?.uid ?? ""
        do {
            let documentSnapshot = try await dbUsers.document(currentUseruid).getDocument()
            guard let data = documentSnapshot.data() else { return .failure(.dataNotFound)}
            guard let userHoney = data[honeyKey] as? Int else {
                try await dbUsers.document(currentUseruid).updateData(["honey": 1])
                return .success(1)
            }
            return .success(userHoney)
        } catch {
            return .failure(.dataNotFound)
        }
    }
    
    internal func decrementHoneyChangePseudoname() async {
        let currentUseruid = Auth.auth().currentUser?.uid ?? ""
        let userHoneyResult = await getUserHoney()
        switch userHoneyResult {
        case let .success(honey):
            do {
                try await dbUsers.document(currentUseruid).updateData(["honey": honey - 200])
            } catch {
                print(error)
            }
        case let .failure(error):
            print(error)
        }
    }
    
    internal func changeUserPseudoname(newName: String) async {
        let currentUseruid = Auth.auth().currentUser?.uid ?? ""
        do {
            try await dbUsers.document(currentUseruid).updateData(["pseudoname": newName])
        } catch {
            print(error)
        }
    }
    
    internal func checkPseudonameExist(pseudoname: String, university: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        
        let docRef = db.collection("university").document(university).collection("users").whereField("pseudoname", isEqualTo: pseudoname).limit(to: 1)
        
        docRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            if let doc = querySnapshot?.documents, !doc.isEmpty {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
            
        }
    }
}
