//
//  ContentView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 27/10/2023.
//

import SwiftUI
import TMDb

enum Tabs: Hashable {
case tracker, social, profile, notifications
}

struct ContentView: View {
    @State private var selectedTab: Tabs = .tracker
    var body: some View {
        TabView(selection: self.$selectedTab) {
            Group {
                
                DiscoverMediaView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(Tabs.tracker)
                
                TimelineView()
                    .tabItem {
                        Label("Social", systemImage: "person.3")
                    }
                    .tag(Tabs.social)
                
                NotificationsView()
                    .tabItem {
                        Label("Notification", systemImage: "bell")
                    }
                    .tag(Tabs.notifications)
                    .badge(3)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(Tabs.profile)
            }
            .toolbarBackground(.red.gradient, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}


#Preview {
    ContentView()
}
