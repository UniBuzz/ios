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
    
    public var feedsData = [Buzz]()
    private var service = FeedService.shared
    weak var delegate: ViewModelDelegate?
    
    internal func fetchData() {
        Task.init {
            let feedsResult = await service.getFeedsData()
            switch feedsResult {
            case let .success(buzzArray):
                feedsData = buzzArray
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    self?.delegate?.stopRefresh()
                    self?.delegate?.reloadTableView()
                }
            case .failure:
                fatalError("Could not get the feeds data")
            }
        }
    }
    
    internal func getDataForFeedCell(feed: Buzz, indexPath: IndexPath) -> FeedCellViewModel {
        return FeedCellViewModel(feed: feed, indexPath: indexPath)
    }
    
    internal func upVoteContent(model: UpvoteModel, index: IndexPath) {
        Task.init {
            await service.upvoteContent(model: model, index: index)
        }
    }
    
    // TO-DO for below function!
    // 1. wait post to complete with await -> refresh data (no need to listen for document changes)
    func updateForTheLatestData() {
        ServiceConstant.COLLECTION_FEEDS.order(by: "timestamp", descending: true).limit(to: 1)
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

    func feedOption() {
        
    }
    
}

