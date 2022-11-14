//
//  FeedCellViewModel.swift
//  UniBuzz
//
//  Created by hada.muhammad on 10/10/22.
//

import Foundation
import Mixpanel

class FeedCellViewModel {
    let trackerService = TrackerService.shared
    var feed: Buzz
    var indexPath: IndexPath
    
    init(feed: Buzz, indexPath: IndexPath) {
        self.feed = feed
        self.indexPath = indexPath
    }
    
    func trackEvent(event: String, properties: Properties?) {
        trackerService.trackEvent(event: event, properties: properties)
    }
}
