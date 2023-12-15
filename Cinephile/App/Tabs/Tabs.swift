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
    case tracker, timeline, profile, notifications, settings, other
    
    nonisolated var id: Int {
        rawValue
    }
    
    static var loggedOutTabs: [Tab] {
        [.tracker, .timeline, .settings]
    }
    
    static var loggedInTabs: [Tab] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [.tracker, .timeline, .notifications, .profile]
        } else {
            return [.tracker, .timeline, .notifications, .profile]
        }
    }
    
    @ViewBuilder
    func makeContentView(popToRootTab: Binding<Tab>) -> some View {
        switch self {
        case .tracker:
            TrackerTab(popToRootTab: popToRootTab)
        case .timeline:
            TimelineTab(popToRootTab: popToRootTab)
        case .profile:
            ProfileTab(popToRootTab: popToRootTab)
        case .notifications:
            NotificationsTab(popToRootTab: popToRootTab)
        case .settings:
            SettingsTab(popToRootTab: popToRootTab)
        case .other:
            EmptyView()
        }
    }
    
    var iconName: String {
      switch self {
      case .timeline:
        "rectangle.stack"
      case .notifications:
        "bell"
      case .settings:
        "gear"
      case .profile:
        "person.crop.circle"
      case .other:
        ""
      case .tracker:
          "movieclapper"
      }
    }
}
