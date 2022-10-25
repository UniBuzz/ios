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
    
    internal func fetchSeedMessages(forUser user: User, completion: @escaping([Message]?, QueryDocumentSnapshot?, QueryDocumentSnapshot?) -> Void) {
        var messages = [Message]()

        let query = dbMessage.document(currentUseruid).collection(user.uid).order(by: "timestamp", descending: true).limit(to: 15)
        
        query.getDocuments() { snapshot, error in
            print("DEBUG SNAPSHOT : \(String(describing: snapshot?.documents))")

            if let snapshot {
                print("DEBUG SNAPSHOT FIRST")
                for documentData in snapshot.documents {
                    let dictionary = documentData.data()
                    messages.append(Message(dictionary: dictionary))
                }
                messages.reverse()
                
                let topSnapshot = snapshot.documents.last
                print("DEBUG SNAPSHOT FIRST2")

                if let bottomSnapshot = snapshot.documents.first {
                    print("DEBUG SNAPSHOT FIRST3")

                    let nextQuery = self.dbMessage.document(self.currentUseruid).collection(user.uid).order(by: "timestamp").start(afterDocument: bottomSnapshot)
                    
                    nextQuery.addSnapshotListener { newSnapshot, error in
                        print("DEBUG SNAPSHOT FIRST4")

                        if let error {
                            print("ERROR DEBUG QUERY: \(error)")
                        } else {
                            newSnapshot?.documentChanges.forEach({ change in
                                if change.type == .added {
                                    let dictionary = change.document.data()
                                    messages.append(Message(dictionary: dictionary))
                                    completion(messages, change.document, nil)
                                }
                                
                            })
                            completion(messages, bottomSnapshot, topSnapshot)
                        }
                    }
                } else {
                    print("DEBUG SNAPSHOT SECOND")

                    let query = self.dbMessage.document(self.currentUseruid).collection(user.uid).order(by: "timestamp")

                    query.addSnapshotListener { newSnapshot, error in
                        newSnapshot?.documentChanges.forEach({ change in
                            if change.type == .added {
                                let dictionary = change.document.data()
                                messages.append(Message(dictionary: dictionary))
                                
                                guard let bottomSnapshot = newSnapshot?.documents.first else {
                                        return
                                    }
                                guard let topSnapshot = snapshot.documents.last else {
                                        return
                                    }
                                print("DEBUG SNAPSHOT THIRD")

                                completion(messages, bottomSnapshot, topSnapshot)
                            }
                        })
                        print("DEBUG SNAPSHOT FOURTH")

                        completion(messages, nil, nil)
                    }
                }
                
                
                
            } else {
                
            }
        }
    }
    
    internal func fetchOldMessages(forUser user: User, before topSnapshot: QueryDocumentSnapshot, completion: @escaping([Message]?, QueryDocumentSnapshot?) -> Void) {
        
        var messages = [Message]()
        
        let nextQuery = self.dbMessage.document(self.currentUseruid).collection(user.uid).order(by: "timestamp", descending: true).start(afterDocument: topSnapshot).limit(to: 10)
        
        nextQuery.getDocuments() { snapshot, error in
            if let snapshot {
                for documentData in snapshot.documents {
                    let dictionary = documentData.data()
                    messages.append(Message(dictionary: dictionary))
                }
                messages.reverse()
                
                guard let newTopSnapshot = snapshot.documents.last else {
                    return
                }
                completion(messages, newTopSnapshot)
            } else {
                completion (nil, nil)
            }
        }
        
    }
    
    internal func fetchMessages(forUser user: User, completion: @escaping([Message]?) -> Void) {
        var messages = [Message]()

        let query = dbMessage.document(currentUseruid).collection(user.uid).order(by: "timestamp")

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
