//
//  ContentView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 27/10/2023.
//

import SwiftUI
import TMDb

enum Tabs: Hashable {
case home, social, profile, notifications
}

struct ContentView: View {
    @State private var selectedTab: Tabs = .home
    var body: some View {
        TabView(selection: self.$selectedTab) {
            Group {
                TimelineView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(Tabs.social)
                
                DiscoverMoviesView()
                    .tabItem {
                        Label("Tracker", systemImage: "popcorn")
                    }
                    .tag(Tabs.home)
                
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
