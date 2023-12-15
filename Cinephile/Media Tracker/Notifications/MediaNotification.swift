//
//  MediaNotification.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 05/12/2023.
//

import Foundation

struct MediaNotification {
    
    internal init(
                  title: String,
                  body: String,
                  timeInterval: Double,
                  repeats: Bool) {
        self.scheduleType = .time
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    
    internal init(
                  title: String,
                  body: String,
                  dateComponents: DateComponents,
                  repeats: Bool) {
        self.scheduleType = .calendar
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
    
    enum ScheduleType {
        case time, calendar
    }
    
    let id = UUID()
    var scheduleType: ScheduleType
    var title: String
    var body: String
    var subtitle: String?
    var imageURL: URL?
    var userInfo: [AnyHashable : Any]?
    var timeInterval: Double?
    var dateComponents: DateComponents?
    var repeats: Bool
    var categoryIdentifier: String?
}

