//
//  MessageService.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/10/22.
//

import Firebase

enum CustomMessageError: Error {
    case dataNotFound
}


class MessageService {
    
    public static let shared = MessageService()
    private let dbMessage = ServiceConstant.COLLECTION_MESSAGES
    private let currentUseruid: String = {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        return uid
    }()
    
    internal func fetchUser(withUid uid: String, completion: @escaping (User)->Void) {
        dbMessage.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    internal func fetchMessages(forUser user: User, completion: @escaping([Message]?) -> Void) {
        var messages = [Message]()

        let query = dbMessage.document(currentUseruid).collection(user.uid).order(by: "timestamp", descending: true).limit(to: 15).order(by: "timestamp")

        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
            completion(nil)
        }
    }
    
    internal func uploadMessage(_ message: String, to user: User, completion: ((Error?)->Void)?) async {

        let data = ["text": message,
                    "fromId": currentUseruid,
                    "toId": user.uid,
                    "timestamp": Timestamp(date:Date())] as [String : Any]
        
        let notReadByUser = await getNotReadMessageOf(user: user)
        switch notReadByUser {
        case let .success(unreadMessagesData):
            var unreadMessagesDataCopy = unreadMessagesData
            unreadMessagesDataCopy.append(message)
            
            try? await dbMessage.document(user.uid).collection("recent-messages").document(self.currentUseruid).setData(["unreadMessages": unreadMessagesDataCopy], merge: true)
        case let .failure(error):
            fatalError("Error with message \(error)")
        }
        
        
        
        dbMessage.document(currentUseruid).collection(user.uid).addDocument(data: data) { _ in
            self.dbMessage.document(user.uid).collection(self.currentUseruid).addDocument(data: data, completion: completion)
            self.dbMessage.document(self.currentUseruid).collection("recent-messages").document(user.uid).setData(data)
            self.dbMessage.document(user.uid).collection("recent-messages").document(self.currentUseruid).setData(data,merge: true)
        }
    }
    
    internal func getNotReadMessageOf(user: User) async -> Result<[String], CustomMessageError> {
        do {
            let documentSnapshot = try await dbMessage.document(user.uid).collection("recent-messages").document(currentUseruid).getDocument(source: .server)
            
            guard let data = documentSnapshot.data() else { return .success([]) }
            let dictData = DataNotification(dictionary: data)
            if dictData.unreadMessages.isEmpty {
                return .success([])
                }else {
                return .success(dictData.unreadMessages)
                }
            
        } catch {
            return .failure(.dataNotFound)
        }
        
    }
    
    internal func notifyReadMessage(to user: User) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return  }

        let data = ["unreadMessages": []] as [String : Any]
        ServiceConstant.COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data, merge: true)
    }
}
