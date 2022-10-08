//
//  Buzz.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import Foundation
import RxSwift

enum Destination: String {
    case openCommentPage,loadComment
}

enum BuzzType: String {
    case comment, feed
}

struct Buzz {
    var userName: String
    var content: String
    var upvoteCount: Int
    var commentCount: Int
    var uid: String
    var feedID: String
    var timestamp: Int
    var isUpvoted = false
    var forPage: Destination = .openCommentPage
    var buzzType: BuzzType
    var userIDs: [String]
    var repliedFrom: String
    
    init(dictionary: [String:Any], feedID: String) {
        self.userName = dictionary["userName"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.userIDs = dictionary["userIDs"] as? [String] ?? []
        self.upvoteCount = userIDs.count
        self.commentCount = dictionary["commentCount"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Int ?? 0
        self.feedID = feedID
        let rawValueBuzzType = dictionary["buzzType"] as? String ?? ""
        self.buzzType = BuzzType(rawValue: rawValueBuzzType) ?? .feed
        self.repliedFrom = dictionary["repliedFrom"] as? String ?? ""
    }
}

struct UpvoteModel {
    var feedToVoteID: String
    var currenUserID: String
}

