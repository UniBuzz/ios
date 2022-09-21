//
//  ConversationViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 20/09/22.
//

import RxSwift

struct ConversationViewModel {
    
    var items = Observable<[Conversation]>.just([
        Conversation(username: "neodroid", message: "Halo nama kamu siapa?", timeStamp: "2h", notification: 1),
        Conversation(username: "pineapple", message: "testing 123", timeStamp: "2h", notification: 0),
        Conversation(username: "koze_fam", message: "p", timeStamp: "2h", notification: 0),
        Conversation(username: "mabahoki123", message: "WOOOOOOOI dsa asd asd asd sad asd asdas da sdqwa dasd a w d adw", timeStamp: "2h", notification: 3),
        Conversation(username: "teknikuwiw", message: "Lorem Ipsum", timeStamp: "2h", notification: 1),
        Conversation(username: "neodroid", message: "Halo nama kamu siapa?", timeStamp: "2h", notification: 2),
        Conversation(username: "pineapple", message: "testing 123", timeStamp: "2h", notification: 0),
        Conversation(username: "koze_fam", message: "p", timeStamp: "2h", notification: 0),
        Conversation(username: "mabahoki123", message: "WOOOOOOOI", timeStamp: "2h", notification: 1),
        Conversation(username: "teknikuwiw", message: "Lorem Ipsum", timeStamp: "2h", notification: 1)
    ])
    
    func isNotificationEmpty(_ conversation: Conversation) -> Bool {
        if conversation.notification == 0 {
            return true
        }else {
            return false
        }
    }
    
}
