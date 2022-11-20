//
//  TimeStampConversion.swift
//  Unibuzz
//
//  Created by hada.muhammad on 19/11/22.
//

import Foundation

struct TimeStampConversion {
    
    let nowTimeInterval = Date().timeIntervalSince1970
    let calendar = Calendar.current
    var componentsDiff: DateComponents = DateComponents()
    
    init(buzzTimeStamp: Int) {
        self.componentsDiff = getDifferenceComponents(from: TimeInterval(buzzTimeStamp))
    }
    
    internal func getFormattedComponents() -> String {
        guard let minute = componentsDiff.minute else { return "" }
        guard let hour = componentsDiff.hour else { return "" }
        guard let day = componentsDiff.day else { return "" }
        guard let month = componentsDiff.month else { return "" }
        guard let year = componentsDiff.year else { return "" }
        
        if year >= 1 {
            return "\(year)y"
        } else if month >= 1 {
            return "\(month * 4)w"
        } else if day >= 1 {
            return "\(day)d"
        } else if hour >= 1 {
            return "\(hour)h"
        } else if minute >= 1 {
            return "\(minute)m"
        } else {
            return "now"
        }
    }
    
    private func getDifferenceComponents(from: TimeInterval) -> DateComponents {
        let nowTimeIntervalToDate = Date.init(timeIntervalSince1970: nowTimeInterval)
        let buzzTimeIntervalToDate = Date.init(timeIntervalSince1970: from)
        let component = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: buzzTimeIntervalToDate, to: nowTimeIntervalToDate)
        return component
    }
    
}
