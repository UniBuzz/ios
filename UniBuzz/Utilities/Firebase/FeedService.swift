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

class FeedService {
    
    public static let shared = FeedService()
    private let firebaseAuth = Auth.auth()
    private let dbUsers = ServiceConstant.COLLECTION_USERS
    private let dbFeeds = ServiceConstant.COLLECTION_FEEDS
    
    private let currentUseruid: String = {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        return uid
    }()
    
    internal func getFeedsData() async -> Result<[Buzz], CustomFeedError> {
        var buzzArray = [Buzz]()
        let upvotedFeedsResult = await getUpvotedFeedsForCurrentUser()
        switch upvotedFeedsResult {
        case let .success(upvotedFeeds):
            do {
                let documentSnapshots = try await dbFeeds.order(by: "timestamp").getDocuments()
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
    
    private func getUpvotedFeedsForCurrentUser() async -> Result<[String], CustomFeedError> {
        let upvotedFeedsKey = "upvotedFeeds"
        do {
            let documentSnapshot = try await dbUsers.document(currentUseruid).getDocument()
            guard let data = documentSnapshot.data() else { return .failure(.dataNotFound)}
            guard let upvotedFeeds = data[upvotedFeedsKey] as? [String] else { return .failure(.dictKeyUnmatched) }
            return .success(upvotedFeeds)
        } catch {
            return .failure(.dataNotFound)
        }
    }
    
    internal func upvoteContent(model: UpvoteModel, index: IndexPath) async {
        await updateUpvotedFeedsForUser(feedID: model.feedToVoteID)
        await updateUserIDsForFeed(feedID: model.feedToVoteID)
    }
    
    private func updateUpvotedFeedsForUser(feedID: String) async {
        do {
            var upvotedResult = await getUpvotedFeedsForCurrentUser()
            switch upvotedResult {
            case let .success(upvotedFeeds):
                var upvotedFeedsCopy = upvotedFeeds
                if !upvotedFeeds.contains(feedID) {
                    upvotedFeedsCopy.append(feedID)
                } else {
                    upvotedFeedsCopy.removeAll { $0 == feedID }
                }
                try await dbUsers.document(currentUseruid).updateData(["upvotedFeeds": upvotedFeedsCopy])
            case let .failure(error):
                fatalError("Error with message \(error)")
            }
        } catch {
            fatalError("Could not update upvoted feeds for user")
        }

    }
    
    private func updateUserIDsForFeed(feedID: String) async {
        do {
            let documentSnapshot = try await dbFeeds.document(feedID).getDocument()
            if documentSnapshot.exists {
                guard let data = documentSnapshot.data() else { return }
                guard var userIDs = data["userIDs"] as? [String] else { return }
                if !userIDs.contains(currentUseruid) {
                    userIDs.append(currentUseruid)
                    // update local to true
                } else {
                    userIDs.removeAll { $0 == currentUseruid }
                    // update local buzz to false
                }
                try await dbFeeds.document(feedID).updateData(["userIDs": userIDs, "upvotedCount": userIDs.count])
            } else {
                try await dbFeeds.document(feedID).updateData(["userIDs": [currentUseruid], "upvotedCount": 1])
            }
        } catch {
            fatalError("Could not update UserIDs for feed")
        }
    }
    
}
