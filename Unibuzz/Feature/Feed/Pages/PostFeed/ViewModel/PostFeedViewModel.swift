//
//  PostFeedViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 26/09/22.
//

import Firebase
import Mixpanel

class PostFeedViewModel {
    private let service = FeedService.shared
    private let tracker = TrackerService.shared

    func uploadFeed(content: String) async {
        await service.uploadFeed(content: content)
        trackEvent(event: "create_post", properties: ["content": content,
                                                      "from": Auth.auth().currentUser?.uid ?? ""])
    }
    
    private func trackEvent(event: String, properties: Properties?) {
        tracker.trackEvent(event: event, properties: properties)
    }
}

