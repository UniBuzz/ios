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
    
    func fetchFeed() {
        var feedsDataArray = [FeedModel]()
        COLLECTION_FEEDS.order(by: "timestamp", descending: true).getDocuments { querySnapshot, err in
            querySnapshot?.documents.forEach({ document in
                feedsDataArray.append(FeedModel(dictionary: document.data()))
            })
            self.feedsData.accept(feedsDataArray)
        }

    }
    
    func refreshFeed() {
        
    }
    
    func upVoteContent() {
        
    }
    
    func loadComments() {
        
    }
    
    func sendMessageToSender() {
        
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
