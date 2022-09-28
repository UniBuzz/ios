//
//  PostFeedViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 26/09/22.
//

import Firebase

class PostFeedViewModel {
    func uploadFeed(content: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var user = User(dictionary: [:])
        let userRef = COLLECTION_USERS.document(uid)
        userRef.getDocument { document, err in
            if let document = document, document.exists {
                user = User(dictionary: document.data() ?? [:])
            }
            
            let values = ["userName": user.pseudoname,
                          "uid": uid,
                          "timestamp": Int(Date().timeIntervalSince1970),
                          "content": content,
                          "upvoteCount": 0,
                          "commentCount": 0] as [String : Any]

            COLLECTION_FEEDS.addDocument(data: values)
        }
    }
}

