//
//  CommentsViewModel.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 05/10/22.
//

import Foundation
import Firebase

enum CommentFrom {
    case feed
    case anotherComment(anotherCommentID: String)
}

protocol CommentViewModelDelegate: ViewModelDelegate {
    func scrollTableView(to index: IndexPath)
}

class CommentsViewModel {
    
    internal weak var delegate: CommentViewModelDelegate?
    private let service = FeedService.shared
    private let reportService = ReportService.shared
    
    private var childCommentsCounter: [String: Int] = [:]
    internal var feedBuzzTapped: Buzz
    internal var indexTapped: Int = 0
    internal let parentFeed: Buzz
    internal var comments = [Buzz]()
    private let commentsCollectionKey = "comments"
    
    internal init(feedBuzzTapped: Buzz){
        self.feedBuzzTapped = feedBuzzTapped
        self.parentFeed = feedBuzzTapped
    }
    
    internal func loadComments() {
        comments = [parentFeed]
        Task.init {
            let commentsResult = await service.loadComments(feedID: parentFeed.feedID)
            switch commentsResult {
            case let .success(response):
                comments.append(contentsOf: response.0)
                childCommentsCounter = response.1
            case .failure:
                fatalError("Could not load comments")
            }
            DispatchQueue.main.async {
                self.delegate?.reloadTableView()
            }
        }
    }
    
    internal func getDataForFeedCell(feed: Buzz, indexPath: IndexPath) -> FeedCellViewModel {
        return FeedCellViewModel(feed: feed, indexPath: indexPath)
    }
    
    internal func upvoteContent(model: UpvoteModel, index: IndexPath) {
        updateUpvoteCountLocal(index: index)
        Task.init {
            await service.upvoteContent(model: model, index: index, parentID: parentFeed.feedID)
        }
    }
    
    internal func _upvoteContent(buzzType: BuzzType, feedID: String) {
        // yang gua tau = 1. parent, 2. repliedTo
        Task.init {
            switch buzzType {
            case .feed:
                break
            case .comment:
                break
            case .childComment:
                break
            }
        }
    }
    
    internal func replyComments(from: CommentFrom, commentContent: String, feedID: String) {
        Task.init {
            let results = await service.replyComments(from: from, commentContent: commentContent, feedID: feedID)
            await self.incrementCommentCountForParentFirebase(parentID: self.parentFeed.feedID)
            incrementCommentCountLocal()
            switch results {
            case let .success(response):
                switch from {
                case .feed:
                    DispatchQueue.main.async {
                        self.childCommentsCounter[response.1] = 0
                        self.comments.append(response.0)
                    }
                case let .anotherComment(anotherCommentID):
                    await self.incrementCommentCountForChildCommentFirebase(childCommentID: anotherCommentID)
                    DispatchQueue.main.async {
                        if !self.comments[self.indexTapped].isChildCommentShown {
                            self.showChildComment(from: anotherCommentID, at: IndexPath(row: self.indexTapped, section: 0))
                        } else {
                            self.appendChildComment(childComment: response.0)
                        }
                    }
                }
            case .failure:
                fatalError("Could not reply comments")
            }
        }
    }
    
    private func incrementCommentCountForParentFirebase(parentID: String) async {
        Task.init {
            let currentCommentCount = await service.getCommentCountForParent(parentID: parentID)
            await service.setDataForParentComment(parentID: parentID, currentCommentCount: currentCommentCount)
            DispatchQueue.main.async {
                self.delegate?.reloadTableView()
            }
        }
    }
    
    private func incrementCommentCountForChildCommentFirebase(childCommentID: String) async {
        Task.init {
            let parentID = feedBuzzTapped.repliedFrom
            let currentCommentCount = await service.getCommentCountForChildComment(parentID: parentID, childCommentID: childCommentID)
            await service.setDataForChildComment(parentID: parentID, childCommentID: childCommentID, currentCommentCount: currentCommentCount)
            DispatchQueue.main.async {
                self.delegate?.reloadTableView()
            }
        }
    }
    
    private func incrementCommentCountLocal() {
        // for parent
        var updatedParentBuzz = comments[0]
        comments.remove(at: 0)
        updatedParentBuzz.commentCount += 1
        comments.insert(updatedParentBuzz, at: 0)
        // for child
        if indexTapped != 0 {
            var updatedBuzz = comments[indexTapped]
            comments.remove(at: indexTapped)
            updatedBuzz.commentCount += 1
            comments.insert(updatedBuzz, at: indexTapped)
        }
    }
    
    private func updateUpvoteCountLocal(index: IndexPath) {
        var updatedParentBuzz = comments[index.row]
        comments.remove(at: index.row)
        if updatedParentBuzz.isUpvoted {
            updatedParentBuzz.upvoteCount -= 1
            updatedParentBuzz.isUpvoted = false
        } else {
            updatedParentBuzz.upvoteCount += 1
            updatedParentBuzz.isUpvoted = true
        }
        comments.insert(updatedParentBuzz, at: index.row)
    }
    
    internal func showChildComment(from commentID: String, at index: IndexPath) {
        var updatedBuzz = comments[index.row]
        updatedBuzz.isChildCommentShown = true
        comments.remove(at: index.row)
        comments.insert(updatedBuzz, at: index.row)
        
        Task.init {
            let results = await service.getChildComments(parentID: parentFeed.feedID, commentID: commentID)
            switch results {
            case let .success(childComments):
                self.childCommentsCounter[commentID] = childComments.count
                self.comments.insert(contentsOf: childComments, at: index.row + 1)
                DispatchQueue.main.async {             self.delegate?.reloadTableView() }
            case .failure:
                fatalError("Failed to get child comments")
            }
        }
    }
    
    internal func hideChildComment(from commentID: String, at index: IndexPath) {
        guard let range = childCommentsCounter[commentID] else { return }
        var updatedBuzz = comments[index.row]
        updatedBuzz.isChildCommentShown = false
        comments.remove(at: index.row)
        comments.insert(updatedBuzz, at: index.row)
        
        self.comments.removeSubrange(index.row+1...index.row+range)
        print("removing: \(index.row+1...index.row+range)")
        self.delegate?.reloadTableView()
    }
    
    private func appendChildComment(childComment: Buzz) {
        guard var currentChildCount = childCommentsCounter[childComment.repliedFrom] else { return }
        var updatedBuzz = comments[indexTapped]
        let indexToInsert = indexTapped + currentChildCount + 1
        updatedBuzz.isChildCommentShown = true
        comments.remove(at: indexTapped)
        comments.insert(updatedBuzz, at: indexTapped)
        
        if indexToInsert > comments.count {
            comments.append(childComment)
        } else {
            comments.insert(childComment, at: indexToInsert)
        }
        
        self.delegate?.reloadTableView()
        currentChildCount += 1
        childCommentsCounter[childComment.repliedFrom] = currentChildCount
    }
    
    func reportUser(reason: String, feed: Buzz) {
        if feed.buzzType == .feed {
            reportService.reportUser(targetUid: feed.uid, reportFrom: .Buzz, reportReason: reason)
        } else {
            reportService.reportUser(targetUid: feed.uid, reportFrom: .Comment, reportReason: reason)
        }
    }
    
    func blockAccount(targetAccountUid: String) {
        Task.init {
            await reportService.blockUser(targetUid: targetAccountUid)
        }
    }
}
