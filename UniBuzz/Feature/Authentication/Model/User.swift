//
//  User.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 24/09/22.
//

import Foundation

struct User {
    let uid: String
    let pseudoname: String
    let email: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.pseudoname = dictionary["pseudoname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
