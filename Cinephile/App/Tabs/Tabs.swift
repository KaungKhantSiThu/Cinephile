//
//  Tabs.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 14/12/2023.
//

import Foundation
import SwiftUI

@MainActor
enum Tab: Int, Identifiable, Hashable {
    case tracker, timeline, mentions, profile, notifications, settings, other
    
    nonisolated var id: Int {
        rawValue
    }
    
    static var loggedOutTabs: [Tab] {
        [.tracker, .timeline, .settings]
    }
    
    static var loggedInTabs: [Tab] {
        return [.tracker, .timeline, .notifications, .profile]
    }
    
    @ViewBuilder
    func makeContentView(selectedTab: Binding<Tab>, popToRootTab: Binding<Tab>) -> some View {
        switch self {
        case .tracker:
            TrackerTab(popToRootTab: popToRootTab)
        case .timeline:
            TimelineTab(popToRootTab: popToRootTab)
        case .profile:
            ProfileTab(popToRootTab: popToRootTab)
        case .notifications:
            NotificationsTab(selectedTab: selectedTab, popToRootTab: popToRootTab, lockedType: nil)
        case .settings:
            SettingsTab(popToRootTab: popToRootTab, isModal: false)
        case .other:
            EmptyView()
        case .mentions:
            NotificationsTab(selectedTab: selectedTab, popToRootTab: popToRootTab, lockedType: .mention)

        }
    }
    
    var iconName: String {
      switch self {
      case .timeline:
        "person.3"
      case .notifications:
        "bell"
      case .mentions:
        "at"
      case .settings:
        "gear"
      case .profile:
        "person.crop.circle"
      case .other:
        "questionmark"
      case .tracker:
          "movieclapper"
      }
    }
    
    var tabName: String {
        switch self {
        case .tracker:
            "Tracker"
        case .timeline:
            "Timeline"
        case .profile:
            "Profile"
        case .notifications:
            "Notifications"
        case .mentions:
            "Mentions"
        case .settings:
            "Settings"
        case .other:
            ""
        }
    }
}
