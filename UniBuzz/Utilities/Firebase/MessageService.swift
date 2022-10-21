//
//  MessageService.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/10/22.
//

import Firebase


class MessageService {
    
    public static let shared = MessageService()
    
    internal func fetchUser(withUid uid: String, completion: @escaping (User)->Void) {
        ServiceConstant.COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    
    internal func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()

        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        let query = ServiceConstant.COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")

        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    internal func uploadMessage(_ message: String, to user: User, completion: ((Error?)->Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return  }

        let data = ["text": message,
                    "fromId": currentUid,
                    "toId": user.uid,
                    "timestamp": Timestamp(date:Date())] as [String : Any]
        ServiceConstant.COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).getDocument(source: .server) { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            var dataNotif = DataNotification(dictionary: dictionary)
            print("DEBUG DATA NOTIF: \(dataNotif)")
            if dataNotif.unreadMessages.isEmpty {
                dataNotif.unreadMessages = [message]
            }else {
                dataNotif.unreadMessages.append(message)
            }
            let newData = ["unreadMessages": dataNotif.unreadMessages] as [String : Any]
            print("DEBUG NEW DATA: \(newData)")
            ServiceConstant.COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(newData, merge: true)
            print("DEBUG NEW DATA POST: \(newData)")
        }
        ServiceConstant.COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            ServiceConstant.COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            ServiceConstant.COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            ServiceConstant.COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data,merge: true)
        }
    }
    
    internal func notifyReadMessage(to user: User) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return  }

        let data = ["unreadMessages": []] as [String : Any]
        ServiceConstant.COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data, merge: true)
    }
}
