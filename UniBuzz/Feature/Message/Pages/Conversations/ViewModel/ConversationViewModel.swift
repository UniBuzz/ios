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
//        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "d"
        let stampDate = Int(dateFormatter.string(from: date))
        let todayDate = Int(dateFormatter.string(from: Date()))!
        if  stampDate == todayDate {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }else if stampDate == (todayDate) - 1 {
            return "yesterday"
        }else {
            dateFormatter.dateFormat = "MM/dd/yy"
            return dateFormatter.string(from: date)
        }
        
    }
    
    init(conversation: Conversation){
        self.conversation = conversation
    }
    
}
