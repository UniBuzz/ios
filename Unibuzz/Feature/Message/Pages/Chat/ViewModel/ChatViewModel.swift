//
//  ChatViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/09/22.
//

import Foundation
import Firebase

class ChatViewModel {
    
    public var messages = [Message]()
    public var user: User?
    private var bottomSnapshot: QueryDocumentSnapshot?
    private var topSnapshot: QueryDocumentSnapshot?
    private var service = MessageService.shared
    private var reportService = ReportService.shared
    public var isThisUserBlocked: Bool = false
    public var isChatBlocked: Bool = false
    
    var chooseReportOption: (() -> Void)?
    var doneReporting: (() -> Void)?
    var showBlockModal: (() -> Void)?
    var showUnblockModal: (() -> Void)?
    var cannotSendMessageBlocked: (() -> Void)?
    
    func readMessage() {
        if let user {
            service.notifyReadMessage(to: user)
        } else {
            print("DEBUG: Error no user")
        }
    }
    
    func fetchMessages(completion: @escaping() -> Void) {
        if let user {
            if self.messages.isEmpty {
                service.fetchSeedMessages(forUser: user) { messages, lastSnapshot, topSnapshot in
                    self.bottomSnapshot = lastSnapshot
                    if let topSnapshot {
                        self.topSnapshot = topSnapshot
                    }
                    if let messages {
                        self.messages = messages
                    }
                    completion()
                }
            } else {
                print("DEBUG FOR LOCAL DATA")
            }
        } else {
            print("DEBUG: Error no user")
        }
    }
    
    func fetchOldData(completion: @escaping(Int) -> Void) {
        if let user {
            if let topSnapshot {
                service.fetchOldMessages(forUser: user, before: topSnapshot) { oldMessages, newTopSnapshot in
                    if let newTopSnapshot {
                        self.topSnapshot = newTopSnapshot
                    }
                    if let oldMessages {
                        self.messages = oldMessages + self.messages
                    }
                    completion(oldMessages?.count ?? 0)
                }
            }
        }
        completion(0)
    }
    
    func uploadMessage(_ message: String, completion: @escaping() -> Void) {
        checkUserBlocked {
            if self.isChatBlocked {
                self.cannotSendMessageBlocked?()
                completion()
            } else {
                if let user = self.user {
                    Task.init {
                        await self.service.uploadMessage(message, to: user) { error in
                            if let error {
                                print("DEBUG: Error sending message with error \(error.localizedDescription)")
                            }
                            completion()
                        }
                    }
                    
                } else {
                    print("DEBUG: Error no user")
                }
            }
        }
        

    }
    
    func reportUser(reason: String) {
        reportService.reportUser(targetUid: user?.uid ?? "", reportFrom: .Message, reportReason: reason)
        doneReporting?()
    }
    
    func blockUser(completion: @escaping() -> Void) {
        Task.init {
            await reportService.blockUser(targetUid: user?.uid ?? "")
            checkUserBlocked {
                completion()
            }
        }
    }
    
    func unblockUser(completion: @escaping()->Void) {
        Task.init {
            await reportService.unblockUser(targetUid: user?.uid ?? "")
            checkUserBlocked {
                completion()
            }
        }
    }
    
    func reportClicked() {
        if isThisUserBlocked{
            showUnblockModal?()
            
        }else {
            showBlockModal?()
        }
    }
    
    func checkUserBlocked(completion: @escaping() -> Void) {
        Task.init {
            let userIsBlocked = await reportService.isThisUserBlocked(target: user?.uid ?? "")
            self.isThisUserBlocked = userIsBlocked
            let userBLockedMe = await reportService.amIBlockedByThisUser(target: user?.uid ?? "")
            if userIsBlocked || userBLockedMe {
                self.isChatBlocked = true
            } else {
                self.isChatBlocked = false
            }
            completion()
        }
    }
    
}
