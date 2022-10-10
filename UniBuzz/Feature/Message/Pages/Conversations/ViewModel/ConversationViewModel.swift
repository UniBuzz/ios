//
//  ConversationViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 20/09/22.
//

import Foundation
import Firebase

class ConversationViewModel {
    
    var messagesForId = [String:[Message]]()
    
    
    func fectMessagesForUser(user: User, completion: @escaping([Message]?) -> Void) {
        
        if self.messagesForId[user.uid] == nil {
            self.messagesForId[user.uid] = [Message]()
        }
         
        guard let currentUid = Auth.auth().currentUser?.uid else { return  }
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                print("DEBUG CHANGE HERE")
                print("DEBUG CHANGE TYPE: \(change.type)")
                print("DEBUG CHANGE DATA: \(change.document.data())")

                if change.type == .added {
                    let dictionary = change.document.data()
                    self.messagesForId[user.uid]!.append(Message(dictionary: dictionary))
                }
            })
            completion(self.messagesForId[user.uid])
        }
//
//
//
//
//        Service.fetchMessages(forUser: user) { messages in
//            self.messagesForId[user.uid] = messages
//            completion(self.messagesForId[user.uid])
//        }
    }
    
}
