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
//    @Environment(AppAccountsManager.self) private var appAccountsManager
    @Environment(Client.self) private var client
    @Environment(CurrentAccount.self) private var currentAccount
    
    @State private var routerPath = RouterPath()
    @State private var scrollToTopSignal: Int = 0
    @Binding var popToRootTab: Tab
    
    init(popToRootTab: Binding<Tab>) {
        _popToRootTab = popToRootTab
    }
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            if let account = currentAccount.account {
                AccountDetailView(account: account, scrollToTopSignal: $scrollToTopSignal)
                    .withAppRouter()
                    .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
                    .id(account.id)
            } else {
                AccountDetailView(account: .placeholder(), scrollToTopSignal: $scrollToTopSignal)
                    .redacted(reason: .placeholder)
            }
        }
        .onChange(of: $popToRootTab.wrappedValue) { _, newValue in
          if newValue == .profile {
            if routerPath.path.isEmpty {
              scrollToTopSignal += 1
            } else {
              routerPath.path = []
            }
          }
        }
        .onChange(of: client.id) {
          routerPath.path = []
        }
        .onAppear {
          routerPath.client = client
        }
        .environment(routerPath)
//        .withSafariRouter()
        
    }
}

//#Preview {
//    ProfileTab()
//}
