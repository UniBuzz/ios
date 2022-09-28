//
//  FeedModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import Foundation
import RxSwift

struct FeedModel {
    var userName: String
    var content: String
    var upvoteCount: Int
    var commentCount: Int
    var uid: String
    var feedID: String
    var timestamp: Int
    var isUpvoted = false
    
    init(dictionary: [String:Any], feedID: String) {
        self.userName = dictionary["userName"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.upvoteCount = dictionary["upvoteCount"] as? Int ?? 0
        self.commentCount = dictionary["commentCount"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Int ?? 0
        self.feedID = feedID 
    }
}

struct UpvoteModel {
    var feedToVoteID: String
    var currenUserID: String
}

struct CommentModel {
    
}
