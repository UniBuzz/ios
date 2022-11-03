//
//  FeedService.swift
//  UniBuzz
//
//  Created by hada.muhammad on 19/10/22.
//

import Foundation
import Firebase

enum CustomFeedError: Error {
    case dataNotFound
    case dictKeyUnmatched
    case failedToGetShapshot
}

enum ReceiveHoneyType: Int {
    case ReceiveComment = 20
    case CommentUpvoted = 15
    case PostUpvoted = 5
    case GivingUpvote = 1
}

class FeedService {
    
    public static let shared = FeedService()
    private let firebaseAuth = Auth.auth()
    private let dbUsers = ServiceConstant.COLLECTION_USERS
    private let dbFeeds = ServiceConstant.COLLECTION_FEEDS
    
    private let commentsCollectionKey = "comments"
    
    private var upvoted: Bool = false {
        didSet {
            Task {
                await changeUserHoney(honeyType: .GivingUpvote)
            }
        }
    }
    
    
    
    internal func getFeedsData() async -> Result<[Buzz], CustomFeedError> {
        var buzzArray = [Buzz]()
        let upvotedFeedsResult = await getUpvotedFeedsForCurrentUser()
        switch upvotedFeedsResult {
        case let .success(upvotedFeeds):
            do {
                let documentSnapshots = try await dbFeeds.order(by: "timestamp", descending: true).getDocuments()
                documentSnapshots.documents.forEach { document in
                    var buzz = Buzz(dictionary: document.data(), feedID: document.documentID)
                    if upvotedFeeds.contains(document.documentID) { buzz.isUpvoted = true }
                    buzzArray.append(buzz)
                }
                return .success(buzzArray)
            } catch {
                return .failure(.failedToGetShapshot)
            }
        case .failure:
            return .failure(.dataNotFound)
        }
    }
    
    internal func uploadFeed(content: String) async {
        let userResult = await getCurrentUserData()
        print(userResult)
        switch userResult {
        case let .success(user):
            let values = ["userName": user.pseudoname,
                          "uid": user.uid,
                          "timestamp": Int(Date().timeIntervalSince1970),
                          "content": content,
                          "upvoteCount": 0,
                          "commentCount": 0,
                          "buzzType": BuzzType.feed.rawValue,
                          "userIDs": [String](),
                          "randomIntBackground": user.randomInt] as [String : Any]
            dbFeeds.addDocument(data: values)
        case .failure:
            fatalError("Could not get user data to upload feed")
        }
    }
    
    internal func getCurrentUserData() async -> Result<User, CustomFeedError> {
        do {
            let currentUseruid = Auth.auth().currentUser?.uid ?? ""
            let documentSnapshot = try await dbUsers.document(currentUseruid).getDocument()
            guard let data = documentSnapshot.data() else { return .failure(.dataNotFound)}
                    return .success(User(dictionary: data))
        } catch {
            return .failure(.dataNotFound)
        }
    }
    
    private func getUpvotedFeedsForCurrentUser() async -> Result<[String], CustomFeedError> {
        let upvotedFeedsKey = "upvotedFeeds"
        do {
            let currentUseruid = Auth.auth().currentUser?.uid ?? ""
            let documentSnapshot = try await dbUsers.document(currentUseruid).getDocument()
            guard let data = documentSnapshot.data() else { return .failure(.dataNotFound)}
            guard let upvotedFeeds = data[upvotedFeedsKey] as? [String] else { return .failure(.dictKeyUnmatched) }
            return .success(upvotedFeeds)
        } catch {
            return .failure(.dataNotFound)
        }
    }
    
    internal func upvoteContent(model: UpvoteModel, index: IndexPath, parentID: String) async {
        await updateUpvotedFeedsForUser(feedID: model.feedToVote)
        await updateUserIDsForFeed(model: model, parentID: parentID)
    }
    
    internal func updateUserIDsForFeed(model: UpvoteModel, parentID: String) async {
        switch model.buzzType {
        case .feed:
            let docRef = dbFeeds.document(model.feedToVote)
            await updateUpvoteCountFirebase(documentReference: docRef)
        case .comment:
            let docRef = dbFeeds.document(model.repliedFrom).collection(commentsCollectionKey).document(model.feedToVote)
            await updateUpvoteCountFirebase(documentReference: docRef)
        case .childComment:
            let docRef = dbFeeds.document(parentID).collection(commentsCollectionKey).document(model.repliedFrom).collection(commentsCollectionKey).document(model.feedToVote)
            await updateUpvoteCountFirebase(documentReference: docRef)
        }
    }
    
    private func updateUpvoteCountFirebase(documentReference: DocumentReference) async {
        let currentUseruid = Auth.auth().currentUser?.uid ?? ""
        do {
            let documentSnapshot = try await documentReference.getDocument()
            if documentSnapshot.exists {
                guard let data = documentSnapshot.data() else { return }
                guard var userIDs = data["userIDs"] as? [String] else { return }
                if !userIDs.contains(currentUseruid) {
                    userIDs.append(currentUseruid)
                } else {
                    userIDs.removeAll { $0 == currentUseruid }
                }
                try await documentReference.updateData([
                    "userIDs": userIDs,
                    "upvotedCount": userIDs.count
                ])
            } else {
                try await documentReference.updateData([
                    "userIDs": [currentUseruid],
                    "upvotedCount": 1
                ])
            }
        } catch {
            fatalError("Could not update UserIDs for feed")
        }
    }
    
    //gausah di edit
    private func updateUpvotedFeedsForUser(feedID: String) async {
        let currentUseruid = Auth.auth().currentUser?.uid ?? ""
        do {
            let upvotedResult = await getUpvotedFeedsForCurrentUser()
            switch upvotedResult {
            case let .success(upvotedFeeds):
                var upvotedFeedsCopy = upvotedFeeds
                if !upvotedFeeds.contains(feedID) {
                    upvotedFeedsCopy.append(feedID)
                    upvoted = true
                } else {
                    upvotedFeedsCopy.removeAll { $0 == feedID }
                    upvoted = false
                }
                try await dbUsers.document(currentUseruid).updateData(["upvotedFeeds": upvotedFeedsCopy])
            case let .failure(error):
                fatalError("Error with message \(error)")
            }
        } catch {
            fatalError("Could not update upvoted feeds for user")
        }

    }
    
    private func getUserHoney(currentUseruid: String) async -> Result<Int,CustomFeedError> {
        let honeyKey = "honey"
        do {
            let documentSnapshot = try await dbUsers.document(currentUseruid).getDocument()
            guard let data = documentSnapshot.data() else { return .failure(.dataNotFound)}
            guard let userHoney = data[honeyKey] as? Int else {
                try await dbUsers.document(currentUseruid).updateData(["honey": 1])
                return .success(1)
            }
            return .success(userHoney)
        } catch {
            return .failure(.dataNotFound)
        }
    }
    
    internal func changeUserHoney(honeyType: ReceiveHoneyType) async {
        let currentUseruid = Auth.auth().currentUser?.uid ?? ""
        let userHoneyResult = await getUserHoney(currentUseruid: currentUseruid)
        switch userHoneyResult {
        case .success(let userHoney):
            var userHoneyCopy = userHoney
            switch honeyType {
            case .PostUpvoted:
                break
                //TODO: User's Post getting upvoted by another user
            case .CommentUpvoted:
                break
                //TODO: User's Comment getting upvoted by another user
            case .GivingUpvote:
                if upvoted {
                    userHoneyCopy += honeyType.rawValue
                } else {
                    if userHoneyCopy <= 0 {
                        userHoneyCopy = 0
                    } else {
                        userHoneyCopy -= honeyType.rawValue
                    }
                }
            case .ReceiveComment:
                break
                //TODO: User's Post getting commented by another user
            }
            do {
                try await dbUsers.document(currentUseruid).updateData(["honey": userHoneyCopy])
            } catch {
                print(error)
            }
        case .failure(let error):
            fatalError("Error with message \(error)")
        }
    }
    
    internal func loadComments(feedID: String) async -> Result<([Buzz], [String:Int]), CustomFeedError> {
        var childCommentsCounter = [String:Int]()
        var comments = [Buzz]()
        let currentUseruid = Auth.auth().currentUser?.uid ?? ""
        do {
            let documentSnapshots = try await dbFeeds.document(feedID).collection(commentsCollectionKey).order(by: "timestamp").getDocuments()
            documentSnapshots.documents.forEach { document in
                var comment = Buzz(dictionary: document.data(), feedID: document.documentID)
                if comment.userIDs.contains(currentUseruid) {
                    comment.isUpvoted = true
                }
                childCommentsCounter[comment.feedID] = comment.commentCount
                comments.append(comment)
            }
            return .success((comments, childCommentsCounter))
        } catch {
            return .failure(.failedToGetShapshot)
        }
    }
    
    internal func replyComments(from: CommentFrom, commentContent: String, feedID: String) async -> Result<(Buzz, String), CustomFeedError> {
        let userResult = await getCurrentUserData()
        switch userResult {
        case let .success(user):
            var values = ["userName": user.pseudoname,
                          "uid": user.uid,
                          "timestamp": Int(Date().timeIntervalSince1970),
                          "content": commentContent,
                          "upvoteCount": 0,
                          "commentCount": 0,
                          "userIDs": [String](),
                          "buzzType": "",
                          "repliedFrom": "",
                          "randomIntBackground": user.randomInt] as [String : Any]
            switch from {
            case .feed:
                // get docRef id to track child comments
                let docRef = dbFeeds.document(feedID).collection(commentsCollectionKey).document()
                let id = docRef.documentID
                values["buzzType"] = BuzzType.comment.rawValue
                values["repliedFrom"] = feedID
                let buzz = Buzz(dictionary: values, feedID: id)
                do {
                    try await docRef.setData(values)
                    return .success((buzz, id))
                } catch {
                    fatalError("Could not set comment data \(error)")
                }
            case let .anotherComment(anotherCommentID):
                values["buzzType"] = BuzzType.childComment.rawValue
                values["repliedFrom"] = anotherCommentID
                dbFeeds.document(feedID).collection(commentsCollectionKey).document(anotherCommentID).collection(commentsCollectionKey).addDocument(data: values)
                let buzz = Buzz(dictionary: values, feedID: feedID)
                return .success((buzz, ""))
            }
        case .failure:
            fatalError("Could not get user data")
        }
    }
    
    internal func getCommentCountForParent(parentID: String) async -> Int {
        do {
            let documentSnapshot = try await dbFeeds.document(parentID).getDocument()
            guard let data = documentSnapshot.data() else { fatalError("Could not get document data") }
            return data["commentCount"] as? Int ?? 0
        } catch {
            fatalError("Could not get comment count")
        }
    }
    
    internal func getCommentCountForChildComment(parentID: String, childCommentID: String) async -> Int {
        do {
            let documentSnapshot = try await dbFeeds.document(parentID).collection(commentsCollectionKey).document(childCommentID).getDocument()
            guard let data = documentSnapshot.data() else { fatalError("Could not get document data") }
            return data["commentCount"] as? Int ?? 0
        } catch {
            fatalError("Could not get comment count")
        }
    }
    
    internal func setDataForChildComment(parentID: String, childCommentID: String, currentCommentCount: Int) async {
        do {
            try await dbFeeds.document(parentID).collection(commentsCollectionKey).document(childCommentID).setData(["commentCount": currentCommentCount + 1], merge: true)
        } catch {
            fatalError("Could not set data for child comment")
        }
        
    }
    
    internal func setDataForParentComment(parentID: String, currentCommentCount: Int) async {
        do {
            try await dbFeeds.document(parentID).setData(["commentCount": currentCommentCount + 1], merge: true)
        } catch {
            fatalError("Could not set data for parent comment")
        }
    }
    
    internal func getChildComments(parentID: String, commentID: String) async -> Result<[Buzz], CustomFeedError> {
        var childComments = [Buzz]()
        let currentUseruid = Auth.auth().currentUser?.uid ?? ""
        do {
            let documentSnapshots = try await dbFeeds.document(parentID).collection(commentsCollectionKey).document(commentID).collection(commentsCollectionKey).order(by: "timestamp").getDocuments()
            documentSnapshots.documents.forEach { document in
                var buzz = Buzz(dictionary: document.data(), feedID: document.documentID)
                if buzz.userIDs.contains(currentUseruid) {
                    buzz.isUpvoted = true
                } else { buzz.isUpvoted = false }
                buzz.buzzType = .childComment
                childComments.append(buzz)
            }
            return .success(childComments)
        } catch {
            return .failure(.failedToGetShapshot)
        }
    }

}
