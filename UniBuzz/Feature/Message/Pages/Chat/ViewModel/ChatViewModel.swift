//
//  ChatViewModel.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/09/22.
//

import Foundation

class ChatViewModel {
    
    public var messages = [Message]()
    public var user: User?
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
            service.fetchMessages(forUser: user) { messages in
                self.messages = messages
                completion()
            }
            
        } else {
            print("DEBUG: Error no user")
        }
    }
    
    func uploadMessage(_ message: String, completion: @escaping() -> Void) {
        if let user {
            service.uploadMessage(message, to: user) { error in
                if let error {
                    print("DEBUG: Error sending message with error \(error.localizedDescription)")
                }
                completion()
            }
            
        } else {
            print("DEBUG: Error no user")
        }

    }
    
}
