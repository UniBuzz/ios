//
//  ConversationService.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/10/22.
//

import Firebase


class ConversationService {
    
    public static let shared = ConversationService()
    private let dbUsers = ServiceConstant.COLLECTION_USERS
    private let dbMessages = ServiceConstant.COLLECTION_MESSAGES
    private let firebaseAuth = Auth.auth()
    
    private let currentUserUid: String = {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        return uid
    }()
    
    
    
    internal func fetchUser(withUid uid: String, completion: @escaping (User)->Void) {
        dbUsers.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    internal func fetchConversations(completion: @escaping(([Conversation])-> Void)){
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return  }

        let query = ServiceConstant.COLLECTION_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp", descending: false)

        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)

                self.fetchUser(withUid: message.chatPartnerId) { user in
                    let conversation = Conversation(user: user, message: message, unreadMessages: message.unreadMessages.count)
                    conversations.append(conversation)
                    
                    completion(conversations)
                }
            })
        }
    }
}
