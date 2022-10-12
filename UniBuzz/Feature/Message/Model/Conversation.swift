//
//  Conversation.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import Firebase

struct Conversation {
    let user: User
    let message: Message
    var unreadMessages: Int = 0
//    var notification: Int
}
