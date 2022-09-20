//
//  FeedModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import Foundation
import RxSwift

struct FeedModel {
    let userName: String
    let content: String
    let upvoteCount: Int
    let commentCount: Int
}

struct DummyData {
    func getDummyData() -> Observable<FeedModel> {
        return Observable.just(FeedModel(userName: "Mabahoki123",
                                         content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
                                         upvoteCount: 13,
                                         commentCount: 8))
    }
}
