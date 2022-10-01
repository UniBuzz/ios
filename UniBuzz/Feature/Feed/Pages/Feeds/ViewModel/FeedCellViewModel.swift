//
//  FeedCellViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 29/09/22.
//

import Foundation

class FeedCellViewModel {
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
}
