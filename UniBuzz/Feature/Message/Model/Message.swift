//
//  Message.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/09/22.
//

import Firebase

struct Message {
    let text: String
    let toId: String
    let fromId: String
    var timestamp: Timestamp!
    var user: User?
    var unreadMessages: [String]
    
    let isFromCurrentUser: Bool
    
    var chatPartnerId: String {
        return isFromCurrentUser ? toId : fromId
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.unreadMessages = dictionary["unreadMessages"] as? [String] ?? []
        
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}
