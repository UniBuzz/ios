//
//  Conversation.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import Firebase

struct Conversation {
    let username: String
    let message: String
    var timeStamp: String
}

let dummyConversations: [Conversation] = [
    Conversation(username: "neodroid", message: "Halo nama kamu siapa?", timeStamp: "2h"),
    Conversation(username: "pineapple", message: "testing 123", timeStamp: "2h"),
    Conversation(username: "koze_fam", message: "p", timeStamp: "2h"),
    Conversation(username: "mabahoki123", message: "WOOOOOOOI", timeStamp: "2h"),
    Conversation(username: "teknikuwiw", message: "Lorem Ipsum", timeStamp: "2h"),
    Conversation(username: "neodroid", message: "Halo nama kamu siapa?", timeStamp: "2h"),
    Conversation(username: "pineapple", message: "testing 123", timeStamp: "2h"),
    Conversation(username: "koze_fam", message: "p", timeStamp: "2h"),
    Conversation(username: "mabahoki123", message: "WOOOOOOOI", timeStamp: "2h"),
    Conversation(username: "teknikuwiw", message: "Lorem Ipsum", timeStamp: "2h"),
]
