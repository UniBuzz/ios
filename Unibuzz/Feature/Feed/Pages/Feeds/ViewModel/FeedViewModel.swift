//
//  FeedViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import Foundation
import Firebase
import Mixpanel

protocol ViewModelDelegate: AnyObject {
    func reloadTableView()
}

protocol FeedViewModelDelegate: ViewModelDelegate {
    func stopRefresh()
}

class FeedViewModel: UpdateDataSourceDelegate {

    private let service = FeedService.shared
    private let reportService = ReportService.shared
    private var trackerService = TrackerService.shared
    weak var delegate: FeedViewModelDelegate?
    
    public var feedsData = [Buzz]()
    private var query: Query!
    private var documents = [QueryDocumentSnapshot]()
    
    internal func fetchData() {
        Task.init {
            let feedsResult = await service.getFeedsData(query: query)
            switch feedsResult {
            case let .success(responseArray):
                feedsData = responseArray.0
                documents = responseArray.1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self?.delegate?.stopRefresh()
                    self?.delegate?.reloadTableView()
                }
            case .failure:
                fatalError("Could not get the feeds data")
            }
        }
    }
    
    internal func paginate() {
        query = query.start(afterDocument: documents.last!).limit(to: 15)
        fetchForPaginate()
    }
    
    internal func fetchForPaginate() {
        Task.init {
            let feedsResult = await service.getFeedsData(query: query)
            switch feedsResult {
            case let .success(responseArray):
                feedsData += responseArray.0
                documents += responseArray.1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
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
            await service.upvoteContent(model: model, index: index, parentID: "")
        }
    }
    
    func update(newData: Buzz, index: IndexPath) {
        feedsData.remove(at: index.row)
        feedsData.insert(newData, at: index.row)
        delegate?.reloadTableView()
    }
    
    func setInitialQuery() {
        query = service.dbFeeds.order(by: "timestamp", descending: true).limit(to: 15)
    }
  
    func reportUser(reason: String, feed: Buzz) {
        if feed.buzzType == .feed {
            reportService.reportUser(targetUid: feed.uid, reportFrom: .Buzz, reportReason: reason)
        } else {
            reportService.reportUser(targetUid: feed.uid, reportFrom: .Comment, reportReason: reason)
        }
        let properties = ["buzzid": feed.feedID,
                          "buzztype": feed.buzzType.rawValue,
                          "buzzcreatorid": feed.uid,
                          "reason": reason,
                          "buzz_content": feed.content]
        trackEvent(event: "report_account_hive", properties: properties)
    }
    
    func reportHive(reason: String, feed: Buzz) {
        guard let currentUseruid = Auth.auth().currentUser?.uid else { return }
        let reportBuzzModel = ReportBuzzModel(
            uidBuzz: feed.feedID,
            uidReporter: currentUseruid,
            buzzType: feed.buzzType,
            timeStamp: Int(Date().timeIntervalSince1970),
            uidTarget: feed.uid
        )
        let properties = ["buzzid": feed.feedID,
                          "buzztype": feed.buzzType.rawValue,
                          "buzzcreatorid": feed.uid,
                          "reason": reason,
                          "buzz_content": feed.content]
        Task.init {
            await reportService.reportBuzz(reportModel: reportBuzzModel, reportReason: reason)
            trackEvent(event: "report_post", properties: properties)
        }
    }
    
    func blockAccount(feed: Buzz) {
        let properties = ["buzzid": feed.feedID,
                          "buzztype": feed.buzzType.rawValue,
                          "buzzcreatorid": feed.uid,
                          "buzz_content": feed.content]
        Task.init {
            await reportService.blockUser(targetUid: feed.uid)
            trackEvent(event: "block_user", properties: properties)
        }
        
    }
    
    func trackEvent(event: String,properties: Properties?) {
        trackerService.trackEvent(event: event, properties: properties)
    }
    
}

