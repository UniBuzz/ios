//
//  CommentsViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 05/10/22.
//

import Foundation
import Firebase
import RxSwift
import RxRelay

enum CommentFrom {
    case feed
    case anotherComment(anotherCommentID: String)
}
class CommentsViewModel {
    
    var comments = BehaviorRelay(value: [Buzz]())
    let commentsCollectionKey = "comments"
    
    func loadComments(from feed: Buzz) {
        var commentsArray = [feed]
        COLLECTION_FEEDS.document(feed.feedID).collection(commentsCollectionKey).getDocuments { querySnapshot, err in
            guard let querySnapshot = querySnapshot else { return }
            querySnapshot.documents.forEach { document in
                commentsArray.append(Buzz(dictionary: document.data(), feedID: document.documentID))
            }
            self.comments.accept(commentsArray)
        }
    }
    
    func replyComments(from: CommentFrom, commentContent: String, feedID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var user = User(dictionary: [:])
        let userRef = COLLECTION_USERS.document(uid)
        
        var values = ["userName": user.pseudoname,
                      "uid": uid,
                      "timestamp": Int(Date().timeIntervalSince1970),
                      "content": commentContent,
                      "upvoteCount": 0,
                      "commentCount": 0,
                      "userIDs": [String](),
                      "repliedFrom": ""] as [String : Any]
        
        userRef.getDocument { document, err in
            if let document = document, document.exists {
                user = User(dictionary: document.data() ?? [:])
            }
            
            switch from {
            case .feed:
                values["repliedFrom"] = feedID
                COLLECTION_FEEDS.document(feedID).collection(self.commentsCollectionKey).addDocument(data: values)
            case .anotherComment(let anotherCommentID):
                values["repliedFrom"] = anotherCommentID
                COLLECTION_FEEDS.document(feedID).collection(self.commentsCollectionKey).document(anotherCommentID).collection(self.commentsCollectionKey).addDocument(data: values)
            }
        }
    }
}
