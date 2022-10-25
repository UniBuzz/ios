//
//  MessageViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 25/09/22.
//

import UIKit

struct MessageViewModel {
    
    private let message:Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? UIColor.creamyYellow : UIColor.stoneGrey
        
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? UIColor.eternalBlack : UIColor.heavenlyWhite
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    init(message: Message){
        self.message = message
    }
}
