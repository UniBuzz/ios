//
//  Constant.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 24/09/22.
//

import Firebase

struct ServiceConstant {
    
    public static var universityName = UserDefaults.standard.string(forKey: "university") ?? "dummy"

    public static let COLLECTION_MESSAGES = Firestore.firestore().collection("university").document(universityName).collection("messages")
    public static let COLLECTION_USERS = Firestore.firestore().collection("university").document(universityName).collection("users")
    public static let COLLECTION_FEEDS = Firestore.firestore().collection("university").document(universityName).collection("feeds")    
    
}



