//
//  CommentsViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 05/10/22.
//

import Foundation
import Firebase

enum CommentFrom {
    case feed
    case anotherComment(anotherCommentID: String)
}
class CommentsViewModel {
    
    weak var delegate: ViewModelDelegate?
    var feedBuzzTapped: Buzz
    var comments = [Buzz]()
    let commentsCollectionKey = "comments"
    
    init(feedBuzzTapped: Buzz){
        self.feedBuzzTapped = feedBuzzTapped
    }
    
    func getUser() {
        
    }
    
    func loadComments() {
        comments = [feedBuzzTapped]
        COLLECTION_FEEDS.document(feedBuzzTapped.feedID).collection(commentsCollectionKey).getDocuments { querySnapshot, err in
            guard let querySnapshot = querySnapshot else { return }
            querySnapshot.documents.forEach { document in
                self.comments.append(Buzz(dictionary: document.data(), feedID: document.documentID))
            }
            self.delegate?.reloadTableView()
        }
    }
    
    func getDataForFeedCell(feed: Buzz) -> FeedCellViewModel {
        return FeedCellViewModel(feed: feed)
    }
    
    func replyComments(from: CommentFrom, commentContent: String, feedID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var user = User(dictionary: [:])
        let userRef = COLLECTION_USERS.document(uid)
 
        userRef.getDocument { document, err in
            if let document = document, document.exists {
                user = User(dictionary: document.data() ?? [:])
            }
            
            var values = ["userName": user.pseudoname,
                          "uid": uid,
                          "timestamp": Int(Date().timeIntervalSince1970),
                          "content": commentContent,
                          "upvoteCount": 0,
                          "commentCount": 0,
                          "userIDs": [String](),
                          "buzzType": BuzzType.comment.rawValue,
                          "repliedFrom": ""] as [String : Any]
            
            switch from {
            case .feed:
                print(feedID)
                values["repliedFrom"] = feedID
                COLLECTION_FEEDS.document(feedID).collection(self.commentsCollectionKey).addDocument(data: values) { error in
                    if let error = error {
                        print(error)
                    } else { self.loadComments() }
                }
            case .anotherComment(let anotherCommentID):
                values["repliedFrom"] = anotherCommentID
                COLLECTION_FEEDS.document(feedID).collection(self.commentsCollectionKey).document(anotherCommentID).collection(self.commentsCollectionKey).addDocument(data: values)  { error in
                    if let error = error {
                        print(error)
                    } else { self.loadComments() }
                }
            }
        }
    }
}
