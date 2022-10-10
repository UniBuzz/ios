//
//  ConversationCellViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 10/10/22.
//

import Foundation

class ConversationCellViewModel {
        
    private let conversation: Conversation
    
    func isNotificationEmpty(_ conversation: Conversation) -> Bool {
        return true
    }
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
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
    
    func pseudonameString() -> String {
        return conversation.user.pseudoname
    }
    
    func randomInt() -> Int {
        return conversation.user.randomInt
    }
    
    func messageString() -> String {
        return conversation.message.text
    }
    
}

