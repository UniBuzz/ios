//
//  ConversationViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 20/09/22.
//

import RxSwift

struct ConversationViewModel {
    
    var items = Observable<[Conversation]>.just([
        Conversation(username: "neodroid", message: "Halo nama kamu siapa?", timeStamp: "2h"),
        Conversation(username: "pineapple", message: "testing 123", timeStamp: "2h"),
        Conversation(username: "koze_fam", message: "p", timeStamp: "2h"),
        Conversation(username: "mabahoki123", message: "WOOOOOOOI", timeStamp: "2h"),
        Conversation(username: "teknikuwiw", message: "Lorem Ipsum", timeStamp: "2h"),
        Conversation(username: "neodroid", message: "Halo nama kamu siapa?", timeStamp: "2h"),
        Conversation(username: "pineapple", message: "testing 123", timeStamp: "2h"),
        Conversation(username: "koze_fam", message: "p", timeStamp: "2h"),
        Conversation(username: "mabahoki123", message: "WOOOOOOOI", timeStamp: "2h"),
        Conversation(username: "teknikuwiw", message: "Lorem Ipsum", timeStamp: "2h")
    ])
    
}
