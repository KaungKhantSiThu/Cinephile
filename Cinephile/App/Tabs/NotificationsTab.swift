//
//  NotificationsTab.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 15/12/2023.
//

import SwiftUI
import Models
import Environment
import AppAccount
import Networking

@MainActor
struct NotificationsTab: View {
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
            NotificationsView()
        }
        .environment(routerPath)
    }
}


//#Preview {
//    NotificationsTab()
//}
