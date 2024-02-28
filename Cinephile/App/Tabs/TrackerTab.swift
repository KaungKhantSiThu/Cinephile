//
//  TrackerTab.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 06/12/2023.
//
import TrackerUI
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
                .id(client.id)
        }
        .onChange(of: $popToRootTab.wrappedValue) { _, newValue in
          if newValue == .tracker {
            if routerPath.path.isEmpty {
//              scrollToTopSignal += 1
            } else {
              routerPath.path = []
            }
          }
        }
        .onAppear {
            routerPath.client = client
//            if !client.isAuth {
//                routerPath.presentedSheet = .addAccount
//            }
        }
        .environment(routerPath)
    }
    
    @ToolbarContentBuilder
    private var toolbarView: some ToolbarContent {
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                routerPath.navigate(to: .trackerSearchView)
            } label: {
                Image(systemName: "magnifyingglass.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
        }
        
        if client.isAuth {
            if UIDevice.current.userInterfaceIdiom != .pad {
              ToolbarItem(placement: .topBarLeading) {
                AppAccountsSelectorView(routerPath: routerPath)
                  .id(currentAccount.account?.id)
              }
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
