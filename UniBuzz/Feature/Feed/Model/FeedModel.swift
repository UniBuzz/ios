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
    
    init(dictionary: [String:Any]) {
        self.userName = dictionary["userName"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.upvoteCount = dictionary["upvoteCount"] as? Int ?? 0
        self.commentCount = dictionary["commentCount"] as? Int ?? 0
    }
}

