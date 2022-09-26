//
//  ConversationViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 20/09/22.
//

import RxSwift

struct ConversationViewModel {
    
    //dummy chat item
    var items = Observable<[Conversation]>.just([
        Conversation(user: User(dictionary: ["uid": "yUeZmvI1k5VA8bmTXXhCtIEPD9o1", "pseudoname": "Udin_petot", "email": "Lol@gmail.id"]), message: Message(dictionary: ["text": "test", "toId": "notme", "fromId": "me"]))
    ])
    
    func isNotificationEmpty(_ conversation: Conversation) -> Bool {
//        if conversation.notification == 0 {
//            return true
//        }else {
//            return false
//        }
        return true
    }
    
}
