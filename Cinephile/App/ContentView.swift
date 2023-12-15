//
//  ContentView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 27/10/2023.
//

//import SwiftUI
//
//
//struct ContentView: View {
//    @State private var selectedTab: Tab = .tracker
//    var body: some View {
//        TabView(selection: self.$selectedTab) {
//            Group {
//                
//                TrackerTab(popToRootTab: $selectedTab)
//                    .tabItem {
//                        Label("Home", systemImage: "house")
//                    }
//                    .tag(Tab.tracker)
//                
//                TimelineView()
//                    .tabItem {
//                        Label("Social", systemImage: "person.3")
//                    }
//                    .tag(Tab.social)
//                
//                NotificationsView()
//                    .tabItem {
//                        Label("Notification", systemImage: "bell")
//                    }
//                    .tag(Tab.notifications)
//                    .badge(3)
//                
//                ProfileView()
//                    .tabItem {
//                        Label("Profile", systemImage: "person.fill")
//                    }
//                    .tag(Tab.profile)
//            }
//            .toolbarBackground(.red.gradient, for: .tabBar)
//            .toolbarBackground(.visible, for: .tabBar)
//            .toolbarColorScheme(.dark, for: .tabBar)
//        }
//    }
//}
//
//
//#Preview {
//    ContentView()
//}
