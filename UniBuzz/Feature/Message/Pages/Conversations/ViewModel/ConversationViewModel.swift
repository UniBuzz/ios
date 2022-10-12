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
    var conversations = [Conversation]()
    var conversationsDictionary = [String: Conversation]()
    func fectMessagesForUser(user: User, completion: @escaping([Message]?) -> Void) {
        
        if self.messagesForId[user.uid] == nil {
            self.messagesForId[user.uid] = [Message]()
        }
        guard let currentUid = Auth.auth().currentUser?.uid else { return  }
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    self.messagesForId[user.uid]!.append(Message(dictionary: dictionary))
                }
            })
            completion(self.messagesForId[user.uid])
        }
    }
    
    func isThereANotification(_ notification: Int?) -> String? {
        guard let notification else {return nil}
        if notification > 0 {
            return String(notification)
        } else {
            return nil
        }
    }
    
}
