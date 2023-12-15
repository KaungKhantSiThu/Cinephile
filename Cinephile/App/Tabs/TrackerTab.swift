//
//  TrackerTab.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 06/12/2023.
//

import SwiftUI
import Models
import Environment
import AppAccount
import Networking

@MainActor
struct TrackerTab: View {
    
    @Environment(AppAccountsManager.self) private var appAccountsManager
    @Environment(CurrentAccount.self) private var currentAccount
    @Environment(UserPreferences.self) private var preferences
    @Environment(Client.self) private var client

    
    @State private var routerPath = RouterPath()
    @Binding var popToRootTab: Tab
    
    init(popToRootTab: Binding<Tab>) {
        _popToRootTab = popToRootTab
    }
    var body: some View {
        NavigationStack(path: $routerPath.path) { 
            MediaTrackerView()
                .withAppRouter()
                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
                .toolbar {
                    toolbarView
                }
                .environment(routerPath)
                .id(client.id)
            
        }
        .onAppear {
            routerPath.client = client
            if !client.isAuth {
                routerPath.presentedSheet = .addAccount
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                routerPath.navigate(to: .trackerSearchView)
            } label: {
                Image(systemName: "magnifyingglass")
            }
        }
        
        if client.isAuth {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        } else {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                  routerPath.presentedSheet = .addAccount
                } label: {
                  Image(systemName: "person.badge.plus")
                }
            }
        }
    }
}

//#Preview {
//    TrackerTab()
//        .environment(RouterPath())
//}
