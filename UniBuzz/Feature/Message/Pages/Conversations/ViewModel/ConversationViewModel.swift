//
//  ConversationViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 20/09/22.
//

import RxSwift
import Foundation

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    func isNotificationEmpty(_ conversation: Conversation) -> Bool {
//        if conversation.notification == 0 {
//            return true
//        }else {
//            return false
//        }
        return true
    }
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation){
        self.conversation = conversation
    }
    
}
