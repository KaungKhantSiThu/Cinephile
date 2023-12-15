//
//  ProfileTab.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 15/12/2023.
//

import SwiftUI
import Environment
import Models
import Networking
import Account
import AppAccount

@MainActor
struct ProfileTab: View {
    @Environment(AppAccountsManager.self) private var appAccountsManager
    @Environment(Client.self) private var client
    @Environment(CurrentAccount.self) private var currentAccount
    
    @State private var routerPath = RouterPath()
    @Binding var popToRootTab: Tab
    
    init(popToRootTab: Binding<Tab>) {
        _popToRootTab = popToRootTab
    }
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            if let account = currentAccount.account {
                AccountDetailView(account: account)
                    .withAppRouter()
                    .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                Task {
                                    await logoutAccount(account: appAccountsManager.currentAccount)
                                    routerPath.navigate(to: .trackerSearchView)
                                }
                            } label: {
                                Label("Log out", systemImage: "door.right.hand.open")
                            }
                        }
                    }
                    .environment(routerPath)
                    .id(account.id)
            } else {
                Text("No account signed in")
            }
        }
//        .onChange(of: $popToRootTab.wrappedValue) { _, newValue in
//          if newValue == .profile {
//            if routerPath.path.isEmpty {
////              scrollToTopSignal += 1
//            } else {
//              routerPath.path = []
//            }
//          }
//        }
//        .onChange(of: client.id) {
//          routerPath.path = []
//        }
        .onAppear {
          routerPath.client = client
        }
//        .withSafariRouter()
        
    }
    
    private func logoutAccount(account: AppAccount) async {
      if let token = account.oauthToken
//            ,let sub = pushNotifications.subscriptions.first(where: { $0.account.token == token })
      {
//        let client = Client(server: account.server, oauthToken: token)
//        await timelineCache.clearCache(for: client.id)
//        await sub.deleteSubscription()
        appAccountsManager.delete(account: account)
      }
    }
}

//#Preview {
//    ProfileTab()
//}
