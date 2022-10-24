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
}

protocol FeedViewModelDelegate: ViewModelDelegate {
    func stopRefresh()
}

class FeedViewModel: UpdateDataSourceDelegate {

    public var feedsData = [Buzz]()
    private var service = FeedService.shared
    weak var delegate: FeedViewModelDelegate?
    
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
    
    func update(newData: Buzz, index: IndexPath) {
        feedsData.remove(at: index.row)
        feedsData.insert(newData, at: index.row)
        delegate?.reloadTableView()
    }
    
    func feedOption() {
        
    }
    
}

