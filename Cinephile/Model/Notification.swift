//
//  Notification.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 05/11/2023.
//

import Foundation

struct Notification: Identifiable, Equatable {
    
    enum Category {
        case release, post
    }
    
    var id = UUID()
    var message: String
    var date: Date
    var category: Category
    
    static let mock = [
        Notification(message: "Loki S2 EP6 is streaming tonight", date: .now, category: .release),
        Notification(message: "Somchai quoted your post: Lorem ipsum", date: .now, category: .post),
        Notification(message: "Invincible S2 EP2 is streaming tonight", date: .distantPast.addingTimeInterval(36000), category: .release)
    ]
}


