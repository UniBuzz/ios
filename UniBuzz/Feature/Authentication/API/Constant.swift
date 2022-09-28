//
//  Constant.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 24/09/22.
//

import Firebase

let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FEEDS = Firestore.firestore().collection("feeds")
let COLLECTION_FEEDS_UPVOTES = Firestore.firestore().collection("feeds-upvotes")
let COLLECTION_FEEDS_COMMENTS = Firestore.firestore().collection("feeds-comments")

