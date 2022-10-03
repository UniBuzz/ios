//
//  University.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 03/10/22.
//

import Foundation


struct University {
    var name: String
    var image: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
    }
}
