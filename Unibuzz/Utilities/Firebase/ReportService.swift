//
//  ReportService.swift
//  Unibuzz
//
//  Created by Kevin ahmad on 08/11/22.
//

import Firebase

enum ReportUserFrom: String {
    case Buzz = "Buzz"
    case Message = "Message"
    case Comment = "Comment"
}

class ReportService {
    public static let shared = ReportService()
    private let dbReports = ServiceConstant.COLLECTION_REPORTS
    private let dbUsers = ServiceConstant.COLLECTION_USERS
    private let currentUseruid: String = {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        return uid
    }()
    
    internal func reportUser(targetUid: String, reportFrom: ReportUserFrom, reportReason: String) {
        let data = [
            "reporterUid": currentUseruid,
            "targetUid": targetUid,
            "reason": reportReason,
            "timeStamp": Timestamp(date:Date())
        ] as [String : Any]
        dbReports.document("Account").collection(reportFrom.rawValue).addDocument(data: data)
        print("DEBUG REPORT USER")
    }
    
    internal func blockUser(targetUid: String) async {
        do {
            let blockedUserResult = await getBlockedUser(uid: self.currentUseruid)
            switch blockedUserResult {
            case let .success(data):
                var blockedData = data
                if !data.contains(targetUid) {
                    blockedData.append(targetUid)
                }
                try await dbUsers.document(self.currentUseruid).updateData(["blockedUser":blockedData])
            case .failure(_):
                print("DEBUG: error when blocking")
            }
        } catch {
            print("DEBUG: could not block user")
        }
    }
    
    internal func unblockUser(targetUid: String) async {
        do {
            let blockedUserResult = await getBlockedUser(uid: self.currentUseruid)
            switch blockedUserResult {
            case let .success(data):
                var blockedData = data
                if data.contains(targetUid) {
                    blockedData.removeAll { $0 == targetUid }
                }
                try await dbUsers.document(self.currentUseruid).updateData(["blockedUser":blockedData])
            case .failure(_):
                print("DEBUG: error when unblocking")
            }
        } catch {
            print("DEBUG: could not unblock user")
        }
    }
    
    internal func isThisUserBlocked(target: String) async -> Bool {
        do {
            let blockedUserResult = await getBlockedUser(uid: self.currentUseruid)
            switch blockedUserResult {
            case let .success(data):
                if data.contains(target) {
                    return true
                } else {
                    return false
                }
            case .failure(_):
                print("DEBUG: error when unblocking")
                return false
            }
        }
        
    }
    
    internal func amIBlockedByThisUser(target: String) async -> Bool {
        do {
            let blockedUserResult = await getBlockedUser(uid: target)
            switch blockedUserResult {
            case let .success(data):
                if data.contains(self.currentUseruid) {
                    return true
                } else {
                    return false
                }
            case .failure(_):
                print("DEBUG: error when unblocking")
                return false
            }
        }
        
    }
    
    private func getBlockedUser(uid: String) async -> Result<[String], CustomFeedError> {
        let blockedUserKey = "blockedUser"
        do {
            let documentSnapshot = try await dbUsers.document(uid).getDocument()
            guard let data = documentSnapshot.data() else { return .failure(.dataNotFound)}
            if let blockedUserData = data[blockedUserKey] as? [String] {
                return .success(blockedUserData)
            } else {
                return .success([])
            }
            
        } catch {
            return .failure(.dataNotFound)
        }
    }
    
    internal func reportBuzz(reportModel: ReportBuzzModel, reportReason: String) async {
        let values: [String: Any] = [
            "reason": reportReason,
            "uidBuzz": reportModel.uidBuzz,
            "uidReporter": reportModel.uidReporter,
            "buzzType": reportModel.buzzType.rawValue,
            "timeStamp": reportModel.timeStamp,
            "uidTarget": reportModel.uidTarget
        ] as [String : Any]
        dbReports.document("Buzz").collection("Buzz").addDocument(data: values)
    }

}
