//
//  FeedViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import Foundation
import RxSwift
import RxRelay

class FeedViewModel {
    
    var feedsData = BehaviorRelay(value: [FeedModel]())
    var feedsDataArray = [FeedModel]()

    func fetchAllData() {
        feedsDataArray = []
        COLLECTION_FEEDS
            .order(by: "timestamp", descending: true)
            .limit(to: 5)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print(err)
                    return
                }
                querySnapshot?.documents.forEach({ document in
                    self.getUpvoteCount(feedID: document.documentID) { voteCount in
                        var feedModel = FeedModel(dictionary: document.data(), feedID: document.documentID)
                        feedModel.upvoteCount = voteCount
                        self.feedsDataArray.append(feedModel)
                    }
                })
                self.feedsData.accept(self.feedsDataArray)
            }
        }
    
    func updateForTheLatestData() {
        COLLECTION_FEEDS.order(by: "timestamp", descending: true)
            .limit(to: 5)
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print(err)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    switch change.type {
                    case .added:
                        self.fetchAllData()
                    case .modified:
                        print("modified")
                    case .removed:
                        print("removed")
                    }
                })
            }
    }
    
    func getUpvoteCount(feedID: String, completion: @escaping(Int) -> Void) {
        var userIDs: [String] = [String]()
        COLLECTION_FEEDS_UPVOTES.document(feedID).getDocument { document, err in
            if let document = document, document.exists {
                userIDs = document.data()!["userIDs"] as! [String]
                print(document.data())
                completion(userIDs.count)
            }
        }
        completion(0)
    }
    
    func pullToRefreshFeed() {
        
    }
    
    func upVoteContent(model: UpvoteModel) {
        var userIDs: [String] = [String]()
        print("Upvoting ...")
        COLLECTION_FEEDS_UPVOTES.document(model.feedID).getDocument { document, err in
            if let document = document, document.exists {
                print("DEBUG: Doc is exist")
                userIDs = document.data()!["userIDs"] as! [String]
                userIDs.append(model.userID)
                COLLECTION_FEEDS_UPVOTES.document(model.feedID).setData(["userIDs": userIDs])
            } else {
                print("DEBUG: Doc is not exist, setting document")
                COLLECTION_FEEDS_UPVOTES.document(model.feedID).setData(["userIDs": [model.userID]])
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
