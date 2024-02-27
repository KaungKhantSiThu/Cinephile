//
//  MediaNotificationManager.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 05/12/2023.
//

import Foundation
import NotificationCenter
import OSLog

private let logger = Logger(subsystem: "Tracker", category: "NotificationManager")

@MainActor
@Observable
public class MediaNotificationManager: NSObject {
    let notificationCenter = UNUserNotificationCenter.current()
    var isGranted = false
    var pendingRequests: [UNNotificationRequest] = []
    
    public static var shared = MediaNotificationManager()
    
    public override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    public func requestAuthorization() async throws {
        try await notificationCenter
            .requestAuthorization(options: [.sound, .badge, .alert])
        //        registerActions()
        await getCurrentSettings()
    }
    
    public func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    public func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
//    public func schedule(localNotification: MediaNotification) async {
//        let content = UNMutableNotificationContent()
//        content.title = localNotification.title
//        content.body = localNotification.body
//        if let subtitle = localNotification.subtitle {
//            content.subtitle = subtitle
//        }
//        
//        
//        if let imageURL = localNotification.imageURL {
//            do {
//                let (imageData, _) = try await URLSession.shared.data(from: imageURL)
//                if let attachment = UNNotificationAttachment.create(image: imageData, identifier: "imageAttachment") {
//                    content.attachments = [attachment]
//                }
//            } catch {
//                logger.error("Error Fetching Image Data: \(error.localizedDescription)")
//            }
//            
//        }
//        
//        if let userInfo = localNotification.userInfo {
//            content.userInfo = userInfo
//        }
//        
//        if let categoryIdentifier = localNotification.categoryIdentifier {
//            content.categoryIdentifier = categoryIdentifier
//        }
//        
//        content.sound = .default
//        
//        if localNotification.scheduleType == .time {
//            guard let timeInterval = localNotification.timeInterval else { return }
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
//            let request = UNNotificationRequest(identifier: localNotification.id.uuidString, content: content, trigger: trigger)
//            do {
//                try await notificationCenter.add(request)
//            } catch {
//                logger.error("Error adding notification request: \(error.localizedDescription)")
//            }
//            
//        } else {
//            guard let dateComponents = localNotification.dateComponents else { return }
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            let request = UNNotificationRequest(identifier: localNotification.id.uuidString, content: content, trigger: trigger)
//            do {
//                try await notificationCenter.add(request)
//            } catch {
//                logger.error("Error adding notification request: \(error.localizedDescription)")
//            }
//        }
//        
//        await getPendingRequests()
//    }
    
    public func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
        print("Pending: \(pendingRequests.count)")
    }
    
    public func removeRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}) {
            pendingRequests.remove(at: index)
            print("Pending: \(pendingRequests.count)")
        }
    }
    
    public func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll()
        print("Pending: \(pendingRequests.count)")
    }
    
    
    public func notificationAttachment(name: String, url: URL) async {
//        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Movie Release Alert"
        content.body = "\(name) is out tomorrow "
        content.categoryIdentifier = NotificationCateogry.trackerAlert.rawValue
        do {
            let (imageData, _) = try await URLSession.shared.data(from: url)
            if let attachment = UNNotificationAttachment.create(image: imageData, identifier: "imageAttachment") {
                content.attachments = [attachment]
            }
        } catch {
            logger.error("Error Fetching Image Data: \(error.localizedDescription)")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        
        let request = UNNotificationRequest(identifier: name, content: content, trigger: trigger)
        
//        let dismiss = UNNotificationAction(identifier: NotificationAction.dismiss.rawValue, title: "Dismiss")
        
//        let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder")
        
//        let generalCategory = UNNotificationCategory(identifier: NotificationCateogry.trackerAlert.rawValue, actions: [dismiss], intentIdentifiers: [], options: [])
//        
//        center.setNotificationCategories([generalCategory])
        
        //        center.add(request) { error in
        //            if let error = error {
        //                print(error)
        //            }
        //        }
        do {
            logger.info("Adding notification alert: \(name)")
            try await notificationCenter.add(request)
        } catch {
            logger.error("Error adding notification request: \(error.localizedDescription)")
        }
        
        await getPendingRequests()
    }
    
//    public func notificationAttachment(name: String, url: URL, scheduleAt date: Date) async {
//        let center = UNUserNotificationCenter.current()
//        let content = UNMutableNotificationContent()
//        content.title = "Release Alert"
//        content.body = "\(name) is out tomorrow"
//        content.categoryIdentifier = NotificationCateogry.trackerAlert.rawValue
//        do {
//            let (imageData, _) = try await URLSession.shared.data(from: url)
//            if let attachment = UNNotificationAttachment.create(image: imageData, identifier: "imageAttachment") {
//                content.attachments = [attachment]
//            }
//        } catch {
//            logger.error("Error Fetching Image Data: \(error.localizedDescription)")
//        }
//        
//        //        if let imageData = try? Data(contentsOf: url),
//        //        let attachment = UNNotificationAttachment.create(image: imageData, identifier: "imageAttachment") {
//        //            content.attachments = [attachment]
//        //        }
//        
//        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
//        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
//        // set the hour in settings
//        dateComponents.hour = 12
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        
//        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
//        
//        let dismiss = UNNotificationAction(identifier: NotificationAction.dismiss.rawValue, title: "Dismiss")
//        
//        let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder")
//        
//        let trackerCategory = UNNotificationCategory(identifier: NotificationCateogry.trackerAlert.rawValue, actions: [dismiss, reminder], intentIdentifiers: [], options: [])
//        
//        center.setNotificationCategories([trackerCategory])
//        
//        //        center.add(request) { error in
//        //            if let error = error {
//        //                print(error)
//        //            }
//        //        }
//        do {
//            try await center.add(request)
//        } catch {
//            logger.error("Error adding notification request: \(error.localizedDescription)")
//        }
//    }
}

public enum NotificationAction: String {
    case dismiss
    case reminder
}

public enum NotificationCateogry: String {
    case trackerAlert
}

public extension UNNotificationAttachment {
    // is the image file stored in the disk permanently or should we remove it once we close notification
    static func create(image imageData: Data, identifier: String) -> UNNotificationAttachment? {
        //        let fileManager = FileManager.default
        let tempDirectory = NSTemporaryDirectory()
        let imageFileIdentifier = identifier + ".jpg"
        let imageFileURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(imageFileIdentifier)
        
        do {
            try imageData.write(to: imageFileURL)
            let imageAttachment = try UNNotificationAttachment(identifier: identifier, url: imageFileURL, options: nil)
            print("successfully created notification image")
            return imageAttachment
        } catch {
            print("Error creating image attachment: \(error)")
            return nil
        }
    }
}


extension MediaNotificationManager: UNUserNotificationCenterDelegate {
    
    //    func registerActions() {
    //        let snooze10Action = UNNotificationAction(identifier: "snooze10", title: "Snooze 10 seconds")
    //        let snooze60Action = UNNotificationAction(identifier: "snooze60", title: "Snooze 60 seconds")
    //        let snoozeCategory = UNNotificationCategory(identifier: "snooze",
    //                                                    actions: [snooze10Action, snooze60Action],
    //                                                    intentIdentifiers: [])
    //        notificationCenter.setNotificationCategories([snoozeCategory])
    //    }
    
    // Delegate function
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound, .banner]
    }
    
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
    //        if let value = response.notification.request.content.userInfo["nextView"] as? String {
    //            nextView = NextView(rawValue: value)
    //        }
    //
    //        // Respond to snooze action
    //        var snoozeInterval: Double?
    //        if response.actionIdentifier == "snooze10" {
    //            snoozeInterval = 10
    //        } else {
    //            if response.actionIdentifier == "snooze60" {
    //                snoozeInterval = 60
    //            }
    //        }
    //
    //        if let snoozeInterval = snoozeInterval {
    //            let content = response.notification.request.content
    //            let newContent = content.mutableCopy() as! UNMutableNotificationContent
    //            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: snoozeInterval, repeats: false)
    //            let request = UNNotificationRequest(identifier: UUID().uuidString,
    //                                                content: newContent,
    //                                                trigger: newTrigger)
    //            do {
    //                try await notificationCenter.add(request)
    //            } catch {
    //                print(error.localizedDescription)
    //            }
    //
    //            await getPendingRequests()
    //        }
    //    }
    
}


