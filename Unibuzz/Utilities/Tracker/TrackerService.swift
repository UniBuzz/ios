//
//  TrackerService.swift
//  Unibuzz
//
//  Created by hada.muhammad on 13/11/22.
//

import Foundation
import Mixpanel

class TrackerService {
    
    public static let shared = TrackerService()
    private let mainInstance = Mixpanel.mainInstance()
    
    public func trackEvent(event: String, properties: Properties?) {
        mainInstance.track(event: event, properties: properties)
    }
    
}
