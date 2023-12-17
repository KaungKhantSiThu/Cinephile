//
//  TMDB_TestApp.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 27/10/2023.
//

import SwiftUI
import TMDb
import Environment
import AppAccount
import Networking

@main
struct CinephileApp: App {
    @StateObject var notificationManager = MediaNotificationManager()
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var appAccountsManager = AppAccountsManager.shared
    @State var currentAccount = CurrentAccount.shared
    @State var currentInstance = CurrentInstance.shared
    @State var userPreferences = UserPreferences.shared
//    @State var sideBarRouterPath = RouterPath()
    
    @State var selectedTab: Tab = .tracker
    @State var popToRootTab: Tab = .other
    
//    @State var sideBarLoadedTab: Set<Tab> = Set()
    
    var availableTabs: [Tab] {
        appAccountsManager.currentClient.isAuth ? Tab.loggedInTabs : Tab.loggedOutTabs
    }
    
    init() {
        let tmdbConfiguration = TMDbConfiguration(apiKey: TMDB_API_Key)
        TMDb.configure(tmdbConfiguration)
    }
    
    var body: some Scene {
        WindowGroup {
            tabBarView
                .onAppear {
                    setNewClientsInEnv(client: appAccountsManager.currentClient)
                }
                .task {
                    do {
                        try await notificationManager.requestAuthorization()
                    } catch {
                        print("Notification request error")
                    }
                    
                }
                .environmentObject(notificationManager)
                .environment(appAccountsManager)
                .environment(appAccountsManager.currentClient)
                .environment(currentAccount)
                .environment(currentInstance)
                .environment(userPreferences)
        }
    }
    
    func setNewClientsInEnv(client: Client) {
      currentAccount.setClient(client: client)
      currentInstance.setClient(client: client)
//      userPreferences.setClient(client: client)
      Task {
        await currentInstance.fetchCurrentInstance()
//        watcher.setClient(client: client, instanceStreamingURL: currentInstance.instance?.urls?.streamingApi)
//        watcher.watch(streams: [.user, .direct])
      }
    }
}
