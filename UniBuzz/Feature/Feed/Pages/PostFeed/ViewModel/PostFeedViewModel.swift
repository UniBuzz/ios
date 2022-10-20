//
//  PostFeedViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 26/09/22.
//

import Firebase


class PostFeedViewModel {
    
    private let service = FeedService.shared

    func uploadFeed(content: String) async {
        await service.uploadFeed(content: content)
    }
}

