//
//  User.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 24/09/22.
//

import Foundation

struct User {
    let uid: String
    let pseudoname: String
    let upvotedFeeds: [String]
    let randomInt: Int
    let university: String
    let honey: Int
    let blockedUsers: [String]
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.pseudoname = dictionary["pseudoname"] as? String ?? ""
        self.upvotedFeeds = dictionary["upvotedFeeds"] as? [String] ?? []
        self.randomInt = dictionary["randomInt"] as? Int ?? 0
        self.university = dictionary["university"] as? String ?? ""
        self.honey = dictionary["honey"] as? Int ?? 1
        self.blockedUsers = dictionary["blockedUser"] as? [String] ?? []
    }
}
