//
//  FeedViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import Foundation
import RxSwift
import RxRelay
import Firebase

protocol ViewModelDelegate: AnyObject {
    func reloadTableView()
    func stopRefresh()
}

class FeedViewModel {
    
    var feedsData = [Buzz]()
    weak var delegate: ViewModelDelegate?

    func fetchData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        feedsData = [Buzz]()
        COLLECTION_USERS.document(uid).getDocument { documentSnapshot, err in
            guard let data = documentSnapshot?.data() else { return }
            guard let upvotedFeeds = data["upvotedFeeds"] as? [String] else { return }
            
            COLLECTION_FEEDS.order(by: "timestamp", descending: true).getDocuments { querySnapshot, err in
                guard let querySnapshot = querySnapshot else { return }
                querySnapshot.documents.forEach { document in
                    var buzz = Buzz(dictionary: document.data(), feedID: document.documentID)
                    if upvotedFeeds.contains(document.documentID) { buzz.isUpvoted = true }
                    self.feedsData.append(buzz)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    self?.delegate?.stopRefresh()
                }
                self.delegate?.reloadTableView()
            }
        }
    }
    
    func getDataForFeedCell(feed: Buzz, indexPath: IndexPath) -> FeedCellViewModel {
        return FeedCellViewModel(feed: feed, indexPath: indexPath)
    }
    
    func updateForTheLatestData() {
        COLLECTION_FEEDS.order(by: "timestamp", descending: true).limit(to: 1)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print(err)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    switch change.type {
                    case .added:
                        self.fetchData()
                    case .modified:
                        print("modified")
                    case .removed:
                        print("removed")
                    }
                })
            }
    }
    
    func upVoteContent(model: UpvoteModel, index: IndexPath) {
        var buzzCopy = feedsData[index.row]
        print("Upvoting ...")
        COLLECTION_FEEDS.document(model.feedToVoteID).getDocument { document, err in
            if let document = document, document.exists {
                print("DEBUG: Doc is exist")
                guard let data = document.data() else { return }
                guard var userIDs = data["userIDs"] as? [String] else { return }
                if !userIDs.contains(model.currenUserID) {
                    userIDs.append(model.currenUserID)
                    buzzCopy.isUpvoted = true
                } else {
                    userIDs.removeAll { $0 == model.currenUserID }
                    buzzCopy.isUpvoted = false
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
                buzzCopy.isUpvoted = true
            } else {
                upvotedFeeds.removeAll { $0 == model.feedToVoteID }
                buzzCopy.isUpvoted = false
            }
            COLLECTION_USERS.document(model.currenUserID).updateData(["upvotedFeeds": upvotedFeeds])
        }
    }
    
    func feedOption() {
        
    }
    
}

