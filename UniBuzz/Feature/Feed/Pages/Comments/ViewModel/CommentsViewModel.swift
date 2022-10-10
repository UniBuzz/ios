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

protocol CommentsViewModelDelegate: ViewModelDelegate {
    func insertRowsTableView(at: IndexPath, range: Int)
    func removeRowsTableView(at: IndexPath, range: Int)
}

class CommentsViewModel {
    
    weak var delegate: CommentsViewModelDelegate?
    var feedBuzzTapped: Buzz
    var comments = [Buzz]()
    private var childCommentsCounter: [String: Int] = [:]
    let commentsCollectionKey = "comments"
    
    init(feedBuzzTapped: Buzz){
        self.feedBuzzTapped = feedBuzzTapped
    }
    
    func loadComments() {
        comments = [feedBuzzTapped]
        COLLECTION_FEEDS.document(feedBuzzTapped.feedID).collection(commentsCollectionKey).getDocuments { querySnapshot, err in
            guard let querySnapshot = querySnapshot else { return }
            querySnapshot.documents.forEach { document in
                var comment = Buzz(dictionary: document.data(), feedID: document.documentID)
                self.comments.append(comment)
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
                          "buzzType": "",
                          "repliedFrom": ""] as [String : Any]
            
            self.incrementCommentCountForParent()
            
            switch from {
            case .feed:
                values["buzzType"] = BuzzType.comment.rawValue
                values["repliedFrom"] = feedID
                COLLECTION_FEEDS.document(feedID).collection(self.commentsCollectionKey).addDocument(data: values) { error in
                    if let error = error {
                        print(error)
                    } else {
                        self.loadComments()
                    }
                }
            case .anotherComment(let anotherCommentID):
                values["buzzType"] = BuzzType.childComment.rawValue
                values["repliedFrom"] = anotherCommentID
                COLLECTION_FEEDS.document(feedID).collection(self.commentsCollectionKey).document(anotherCommentID).collection(self.commentsCollectionKey).addDocument(data: values)  { error in
                    if let error = error {
                        print(error)
                    } else {
                        self.incrementCommentCountForChildComment(childCommentID: anotherCommentID)
                        self.loadComments()
                    }
                }
            }
            self.delegate?.reloadTableView()
        }
    }
    
    func incrementCommentCountForParent() {
        COLLECTION_FEEDS.document(feedBuzzTapped.feedID).getDocument { doc, err in
            guard let doc = doc else { return }
            guard let data = doc.data() else { return }
            let commentCount = data["commentCount"] as? Int ?? 0
            COLLECTION_FEEDS.document(self.feedBuzzTapped.feedID).setData(["commentCount": commentCount + 1], merge: true)
        }
    }
    
    func incrementCommentCountForChildComment(childCommentID: String) {
        COLLECTION_FEEDS.document(feedBuzzTapped.feedID).collection(self.commentsCollectionKey).document(childCommentID).getDocument { doc, err in
            guard let doc = doc else { return }
            guard let data = doc.data() else { return }
            let commentCount = data["commentCount"] as? Int ?? 0
            COLLECTION_FEEDS.document(self.feedBuzzTapped.feedID).collection(self.commentsCollectionKey).document(childCommentID).setData(["commentCount": commentCount + 1], merge: true)
        }
    }
    
    func showChildComment(from commentID: String, at index: IndexPath) {
        var childComments = [Buzz]()
        
        COLLECTION_FEEDS.document(feedBuzzTapped.feedID).collection(self.commentsCollectionKey).document(commentID).collection(self.commentsCollectionKey).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot else { return }
            querySnapshot.documents.forEach { docSnapshot in
                var child = Buzz(dictionary: docSnapshot.data(), feedID: docSnapshot.documentID)
                child.buzzType = .childComment
                childComments.append(child)
            }
            self.childCommentsCounter[commentID] = childComments.count
            self.comments.insert(contentsOf: childComments, at: index.row + 1)
            self.delegate?.insertRowsTableView(at: index, range: childComments.count)
        }
    }
    
    func hideChildComment(from commentID: String, at index: IndexPath) {
        guard let range = childCommentsCounter[commentID] else { return }
        self.comments.removeSubrange(index.row+1...index.row+range)
        self.delegate?.removeRowsTableView(at: index, range: range)
    }
    
}
