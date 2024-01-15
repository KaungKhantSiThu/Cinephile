//
//  TMDB_TestApp.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 27/10/2023.
//
import CinephileUI
import SwiftUI
import TMDb
import Environment
import AppAccount
import Networking

@main
struct CinephileApp: App {
    @StateObject var notificationManager = MediaNotificationManager()
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var appAccountsManager = AppAccountsManager.shared
    @State var currentAccount = CurrentAccount.shared
    @State var currentInstance = CurrentInstance.shared
    @State var userPreferences = UserPreferences.shared
    @State var pushNotificationsService = PushNotificationsService.shared
    @State var watcher = StreamWatcher()
    @State var quickLook = QuickLook.shared
    @State var theme = Theme.shared
    //    @State var sideBarRouterPath = RouterPath()
    
    @State var isSupporter: Bool = false
    
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
                    refreshPushSubs()
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
                .environment(quickLook)
                .environment(currentAccount)
                .environment(currentInstance)
                .environment(userPreferences)
                .environment(theme)
                .environment(watcher)
                .environment(pushNotificationsService)
                .environment(\.isSupporter, isSupporter)
                .sheet(item: $quickLook.selectedMediaAttachment) { selectedMediaAttachment in
                    MediaUIView(selectedAttachment: selectedMediaAttachment,
                                attachments: quickLook.mediaAttachments)
                    .presentationBackground(.ultraThinMaterial)
                    .presentationCornerRadius(16)
                    .withEnvironments()
                }
                .onChange(of: pushNotificationsService.handledNotification) { _, newValue in
                  if newValue != nil {
                    pushNotificationsService.handledNotification = nil
                    if appAccountsManager.currentAccount.oauthToken?.accessToken != newValue?.account.token.accessToken,
                       let account = appAccountsManager.availableAccounts.first(where:
                         { $0.oauthToken?.accessToken == newValue?.account.token.accessToken })
                    {
                      appAccountsManager.currentAccount = account
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        selectedTab = .notifications
                        pushNotificationsService.handledNotification = newValue
                      }
                    } else {
                      selectedTab = .notifications
                    }
                  }
                }
                .withModelContainer()
            
        }
        .onChange(of: scenePhase) { _, newValue in
          handleScenePhase(scenePhase: newValue)
        }
        .onChange(of: appAccountsManager.currentClient) { _, newValue in
            setNewClientsInEnv(client: newValue)
            if newValue.isAuth {
                watcher.watch(streams: [.user, .direct])
            }
        }
    }
    
    func setNewClientsInEnv(client: Client) {
        currentAccount.setClient(client: client)
        currentInstance.setClient(client: client)
        userPreferences.setClient(client: client)
        Task {
            await currentInstance.fetchCurrentInstance()
            watcher.setClient(client: client, instanceStreamingURL: currentInstance.instance?.urls?.streamingApi)
            watcher.watch(streams: [.user, .direct])
        }
    }
    
    func handleScenePhase(scenePhase: ScenePhase) {
        switch scenePhase {
        case .background:
            watcher.stopWatching()
        case .active:
            watcher.watch(streams: [.user, .direct])
            UNUserNotificationCenter.current().setBadgeCount(0)
            userPreferences.reloadNotificationsCount(tokens: appAccountsManager.availableAccounts.compactMap(\.oauthToken))
            Task {
                await userPreferences.refreshServerPreferences()
            }
        default:
            break
        }
    }
    
    func refreshPushSubs() {
        PushNotificationsService.shared.requestPushNotifications()
    }
}
