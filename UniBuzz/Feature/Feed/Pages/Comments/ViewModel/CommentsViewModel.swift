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
    private var childCommentsCounter: [String: Int] = [:]
    
    var feedBuzzTapped: Buzz
    var parentFeed: Buzz
    var comments = [Buzz]()
    let commentsCollectionKey = "comments"
    
    init(feedBuzzTapped: Buzz){
        self.feedBuzzTapped = feedBuzzTapped
        self.parentFeed = feedBuzzTapped
    }
    
    func loadComments() {
        comments = [parentFeed]
        COLLECTION_FEEDS.document(parentFeed.feedID).collection(commentsCollectionKey).order(by: "timestamp").getDocuments { querySnapshot, err in
            guard let querySnapshot = querySnapshot else { return }
            querySnapshot.documents.forEach { document in
                var comment = Buzz(dictionary: document.data(), feedID: document.documentID)
                self.comments.append(comment)
            }
            self.delegate?.reloadTableView()
        }
    }
    
    func getDataForFeedCell(feed: Buzz, indexPath: IndexPath) -> FeedCellViewModel {
        return FeedCellViewModel(feed: feed, indexPath: indexPath)
    }
    
    func upVoteContent(model: UpvoteModel) {
        print("Upvoting ...")
        COLLECTION_FEEDS.document(model.feedToVoteID).getDocument { document, err in
            if let document = document, document.exists {
                print("DEBUG: Doc is exist")
                guard let data = document.data() else { return }
                guard var userIDs = data["userIDs"] as? [String] else { return }
                if !userIDs.contains(model.currenUserID) {
                    userIDs.append(model.currenUserID)
                } else {
                    userIDs.removeAll { $0 == model.currenUserID }
                }
                COLLECTION_FEEDS.document(model.feedToVoteID).updateData(["userIDs": userIDs, "upvoteCount": userIDs.count])
            } else {
                print("DEBUG: Doc is not exist, setting document")
                COLLECTION_FEEDS.document(model.feedToVoteID).updateData(["userIDs": [model.currenUserID], "upvoteCount": 1])
            }
        }
        
        COLLECTION_USERS.document(model.currenUserID).getDocument { document, err in
            guard let document = document else { return }
            guard let data = document.data() else { return }
            guard var upvotedFeeds = data["upvotedFeeds"] as? [String] else { return }
            if !upvotedFeeds.contains(model.feedToVoteID) {
                upvotedFeeds.append(model.feedToVoteID)
            } else {
                upvotedFeeds.removeAll { $0 == model.feedToVoteID }
            }
            COLLECTION_USERS.document(model.currenUserID).updateData(["upvotedFeeds": upvotedFeeds])
        }
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
                        
            switch from {
            case .feed:
                values["buzzType"] = BuzzType.comment.rawValue
                values["repliedFrom"] = feedID
                COLLECTION_FEEDS.document(feedID).collection(self.commentsCollectionKey).addDocument(data: values) { error in
                    if let error = error {
                        print(error)
                    } else {
                        self.incrementCommentCountForParent(parentID: self.feedBuzzTapped.feedID)
                    }
                }
            case .anotherComment(let anotherCommentID):
                values["buzzType"] = BuzzType.childComment.rawValue
                values["repliedFrom"] = anotherCommentID
                COLLECTION_FEEDS.document(feedID).collection(self.commentsCollectionKey).document(anotherCommentID).collection(self.commentsCollectionKey).addDocument(data: values)  { error in
                    if let error = error {
                        print(error)
                    } else {
                        self.incrementCommentCountForParent(parentID: self.feedBuzzTapped.repliedFrom)
                        self.incrementCommentCountForChildComment(childCommentID: anotherCommentID)
                    }
                }
            }
            self.delegate?.reloadTableView()
        }
    }
    
    func incrementCommentCountForParent(parentID: String) {
        COLLECTION_FEEDS.document(parentID).getDocument { doc, err in
            guard let doc = doc else { return }
            guard let data = doc.data() else { return }
            let commentCount = data["commentCount"] as? Int ?? 0
            COLLECTION_FEEDS.document(parentID).setData(["commentCount": commentCount + 1], merge: true)
            self.loadComments()
            self.delegate?.reloadTableView()
        }
    }
    
    func incrementCommentCountForChildComment(childCommentID: String) {
        COLLECTION_FEEDS.document(feedBuzzTapped.repliedFrom).collection(self.commentsCollectionKey).document(childCommentID).getDocument { doc, err in
            guard let doc = doc else { return }
            guard let data = doc.data() else { return }
            let commentCount = data["commentCount"] as? Int ?? 0
            COLLECTION_FEEDS.document(self.feedBuzzTapped.repliedFrom).collection(self.commentsCollectionKey).document(childCommentID).setData(["commentCount": commentCount + 1], merge: true)
        }
    }
    
    func showChildComment(from commentID: String, at index: IndexPath) {
        var childComments = [Buzz]()
        let toggledParent = toggleParentChildBool(parent: comments[index.row])
        comments.remove(at: index.row)
        comments.insert(toggledParent, at: index.row)
        COLLECTION_FEEDS.document(feedBuzzTapped.feedID).collection(self.commentsCollectionKey).document(commentID).collection(self.commentsCollectionKey).order(by: "timestamp").getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot else { return }
            querySnapshot.documents.forEach { docSnapshot in
                var child = Buzz(dictionary: docSnapshot.data(), feedID: docSnapshot.documentID)
                child.buzzType = .childComment
                childComments.append(child)
            }
            self.childCommentsCounter[commentID] = childComments.count
            self.comments.insert(contentsOf: childComments, at: index.row + 1)
            self.delegate?.reloadTableView()
        }
    }
    
    func hideChildComment(from commentID: String, at index: IndexPath) {
        guard let range = childCommentsCounter[commentID] else { return }
        
        let toggledParent = toggleParentChildBool(parent: comments[index.row])
        comments.remove(at: index.row)
        comments.insert(toggledParent, at: index.row)
        
        self.comments.removeSubrange(index.row+1...index.row+range)
        print("removing: \(index.row+1...index.row+range)")
        self.delegate?.reloadTableView()
    }
    
    func toggleParentChildBool(parent: Buzz) -> Buzz {
        var parentCopy = parent
        parentCopy.isChildCommentShown.toggle()
        return parentCopy
    }
    
    func appendChildComment(at index: Int, with numOfChildren: Int, childComment: Buzz) {
        comments.insert(childComment, at: index + numOfChildren + 1)
        guard var currentChildCount = childCommentsCounter[childComment.repliedFrom] else { return }
        currentChildCount += 1
        childCommentsCounter[childComment.repliedFrom] = currentChildCount
    }
    
    func toggleParentChildBool(parent: Buzz) -> Buzz {
        var parentCopy = parent
        parentCopy.isChildCommentShown.toggle()
        return parentCopy
    }
    
    
}
