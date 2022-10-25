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
        if let user {
            Task.init {
                await service.uploadMessage(message, to: user) { error in
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
