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

    func fetchAllData(completion: @escaping([FeedModel]) -> Void) {
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
                    self.getUpvoteCount(feedID: document.documentID) { userIDs in
                        var feedModel = FeedModel(dictionary: document.data(), feedID: document.documentID)
                        feedModel.upvoteCount = userIDs.count
                        feedModel.isUpvoted = userIDs.contains(currentUserUID)
                        print(feedModel.isUpvoted, userIDs)
                        self.feedsDataArray.append(feedModel)
                        completion(self.feedsDataArray)
                    }
                })
            }
        }
    
    func getUpvoteCount(feedID: String, completion: @escaping([String]) -> Void) {
        var userIDs: [String] = [String]()
        COLLECTION_FEEDS_UPVOTES.document(feedID).getDocument { document, err in
            if let document = document, document.exists {
                userIDs = document.data()!["userIDs"] as! [String]
                completion(userIDs)
            } else {
                completion([])
            }
        }
    }
    
    func updateForTheLatestData() {
        COLLECTION_FEEDS.order(by: "timestamp", descending: true)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print(err)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    switch change.type {
                    case .added:
                        print("added")
                        self.fetchAllData { data in
                            self.feedsData.accept(data)
                        }
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
