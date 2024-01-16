//
//  CinephileApp+TabBar.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 14/12/2023.
//

import SwiftUI

extension CinephileApp {
    var tabBarView: some View {
        TabView(selection: .init(
            get: { selectedTab },
            set: { newTab in
                
                if newTab == selectedTab {
                    popToRootTab = .other
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                      popToRootTab = selectedTab
                    }
                }
                
                selectedTab = newTab
            })) {
                ForEach(availableTabs) { tab in
                    tab.makeContentView(selectedTab: $selectedTab, popToRootTab: $popToRootTab)
                    .tabItem {
//                      if userPreferences.showiPhoneTabLabel {
//                        tab.label
//                      } else {
//                        Image(systemName: tab.iconName)
//                      }
                        Label(tab.tabName, systemImage: tab.iconName)
                    }
                    .tag(tab)
//                    .badge(badgeFor(tab: tab))
//                    .toolbarBackground(theme.primaryBackgroundColor.opacity(0.50), for: .tabBar)
                }
            }
            .id(appAccountsManager.currentClient.id)
    }
}
