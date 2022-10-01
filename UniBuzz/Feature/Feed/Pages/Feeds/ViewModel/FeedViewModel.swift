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

class FeedViewModel {
    
    var feedsData = BehaviorRelay(value: [FeedModel]())
    var feedsDataArray = [FeedModel]()

    func fetchAllData() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        feedsDataArray = []    
        COLLECTION_FEEDS
            .order(by: "timestamp", descending: true)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print(err)
                    return
                }
                querySnapshot?.documents.forEach({ document in
                    let feedModel = FeedModel(dictionary: document.data(), feedID: document.documentID)
                    self.feedsDataArray.append(feedModel)
                })
                self.feedsData.accept(self.feedsDataArray)
            }
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
                        self.fetchAllData()
                        print("added \(change.document.data())")
                    case .modified:
                        print("modified")
                    case .removed:
                        print("removed")
                    }
                })
            }
    }
    
    
    func pullToRefreshFeed() {
        
    }
    
    func upVoteContent(model: UpvoteModel) {
        var userIDs: [String] = [String]()
        print("Upvoting ...")
        COLLECTION_FEEDS_UPVOTES.document(model.feedToVoteID).getDocument { document, err in
            if let document = document, document.exists {
                print("DEBUG: Doc is exist")
                userIDs = document.data()!["userIDs"] as! [String]
                if !userIDs.contains(model.currenUserID) {
                    userIDs.append(model.currenUserID)
                } else {
                    userIDs.removeAll { $0 == model.currenUserID }
                }
                COLLECTION_FEEDS_UPVOTES.document(model.feedToVoteID).setData(["userIDs": userIDs])
                COLLECTION_FEEDS.document(model.feedToVoteID).updateData(["upvoteCount": userIDs.count]) { err in
                    if let err = err {
                        print(err)
                    } else { print("success update data") }
                }
            } else {
                print("DEBUG: Doc is not exist, setting document")
                COLLECTION_FEEDS_UPVOTES.document(model.feedToVoteID).setData(["userIDs": [model.currenUserID]])
                COLLECTION_FEEDS.document(model.feedToVoteID).updateData(["upvoteCount": 1]) { err in
                    if let err = err {
                        print(err)
                    } else { print("success update data") }
                }
            }
        }
    }
    
    func loadComments() {
        
    }
    
    func feedOption() {
        
    }
    
}

extension FeedViewModel {
//    func fetchDummyData() {
//        let data = [
//            FeedModel(userName: "Mabahoki123",
//                             content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
//                             upvoteCount: 13,
//                             commentCount: 8),
//            FeedModel(userName: "Mabahoki123",
//                             content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
//                             upvoteCount: 13,
//                             commentCount: 8),
//            FeedModel(userName: "Mabahoki123",
//                             content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
//                             upvoteCount: 13,
//                             commentCount: 8)
//            ]
//
//        feedsData.accept(data)
//    }
}
