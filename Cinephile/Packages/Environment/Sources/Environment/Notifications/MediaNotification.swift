//
//  MediaNotification.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 05/12/2023.
//

import Foundation

public struct MediaNotification {
    
    //    public init(title: String, body: String, timeInterval: Double) {
    //        self.scheduleType = .time
    //        self.title = title
    //        self.body = body
    //        self.timeInterval = timeInterval
    //        self.dateComponents = nil
    //    }
    //
    //
    //    public init(title: String, body: String, dateComponents: DateComponents) {
    //        self.scheduleType = .calendar
    //        self.title = title
    //        self.body = body
    //        self.timeInterval = nil
    //        self.dateComponents = dateComponents
    //    }
    
    public init(scheduleType: ScheduleType, title: String, body: String, subtitle: String? = nil, imageURL: URL? = nil, userInfo: [AnyHashable : Any]? = nil, dateComponents: DateComponents, categoryIdentifier: String? = nil) {
        self.scheduleType = scheduleType
        self.title = title
        self.body = body
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.userInfo = userInfo
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.categoryIdentifier = categoryIdentifier
    }
    
    public init(scheduleType: ScheduleType, title: String, body: String, subtitle: String? = nil, imageURL: URL? = nil, userInfo: [AnyHashable : Any]? = nil, timeInterval: Double, categoryIdentifier: String? = nil) {
        self.scheduleType = scheduleType
        self.title = title
        self.body = body
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.userInfo = userInfo
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.categoryIdentifier = categoryIdentifier
    }
    
    
    public enum ScheduleType {
        case time, calendar
    }
    
    let id = UUID()
    var scheduleType: ScheduleType
    var title: String
    var body: String
    var subtitle: String?
    public var imageURL: URL?
    public var userInfo: [AnyHashable : Any]?
    var timeInterval: Double?
    var dateComponents: DateComponents?
    public var categoryIdentifier: String?
}

