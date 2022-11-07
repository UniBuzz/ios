//
//  DataNotification.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 12/10/22.
//

import Foundation

struct DataNotification {
    var unreadMessages: [String]
    
    init(dictionary: [String:Any]){
        self.unreadMessages = dictionary["unreadMessages"] as? [String] ?? []
    }
}
