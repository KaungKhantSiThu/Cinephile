//
//  SettingsTab.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 15/12/2023.
//

import SwiftUI
import Account
import AppAccount
import Environment
import Models
import Networking
import Timeline
import Nuke
import SwiftData
import CinephileUI

@MainActor
struct SettingsTab: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(UserPreferences.self) private var preferences
    @Environment(Client.self) private var client
    @Environment(CurrentInstance.self) private var currentInstance
    @Environment(AppAccountsManager.self) private var appAccountsManager
    @Environment(Theme.self) private var theme
    
    @State private var routerPath = RouterPath()
    @State private var addAccountSheetPresented = false
    @State private var isEditingAccount = false
    
    @State private var cachedRemoved = false
    @State private var timelineCache = TimelineCache()
    
    @Binding var popToRootTab: Tab
    
    let isModal: Bool
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            Form {
                accountsSection
                otherSections
                cacheSection
            }
            .scrollContentBackground(.hidden)
            .toolbar {
                if isModal {
                    ToolbarItem {
                        Button {
                            dismiss()
                        } label: {
                            Text("Done")
                        }
                    }
                }
            }
            .withAppRouter()
            .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
            .onAppear {
                routerPath.client = client
            }
            .task {
                if appAccountsManager.currentAccount.oauthToken != nil {
                    await currentInstance.fetchCurrentInstance()
                }
            }
            .withSafariRouter()
            .environment(routerPath)
            .onChange(of: $popToRootTab.wrappedValue) { _, newValue in
                if newValue == .notifications {
                    routerPath.path = []
                }
            }
        }
    }
    
    private var accountsSection: some View {
        Section("Accounts") {
            ForEach(appAccountsManager.availableAccounts) { account in
                HStack {
                    if isEditingAccount {
                        Button {
                            Task {
                                await logoutAccount(account: account)
                            }
                        } label: {
                            Image(systemName: "trash")
                                .renderingMode(.template)
                                .tint(.red)
                        }
                    }
                    AppAccountView(viewModel: .init(appAccount: account))
                }
            }
            .onDelete { indexSet in
                if let index = indexSet.first {
                    let account = appAccountsManager.availableAccounts[index]
                    Task {
                        await logoutAccount(account: account)
                    }
                }
            }
            if !appAccountsManager.availableAccounts.isEmpty {
                editAccountButton
            }
            addAccountButton
        }
    }
    
    @ViewBuilder
    private var otherSections: some View {
        @Bindable var preferences = preferences
        Section {
            #if !targetEnvironment(macCatalyst)
            Picker(selection: $preferences.preferredBrowser) {
                ForEach(PreferredBrowser.allCases, id: \.rawValue) { browser in
                    switch browser {
                    case .inAppSafari:
                        Text("settings.general.browser.in-app").tag(browser)
                    case .safari:
                        Text("settings.general.browser.system").tag(browser)
                    }
                }
            } label: {
                Label("settings.general.browser", systemImage: "network")
            }
            
            Toggle(isOn: $preferences.inAppBrowserReaderView) {
                Label("settings.general.browser.in-app.readerview", systemImage: "doc.plaintext")
            }
            .disabled(preferences.preferredBrowser != PreferredBrowser.inAppSafari)
            #endif
            
            Toggle(isOn: $preferences.isSocialKeyboardEnabled) {
                Label("settings.other.social-keyboard", systemImage: "keyboard")
            }
//            Toggle(isOn: $preferences.soundEffectEnabled) {
//                Label("settings.other.sound-effect", systemImage: "hifispeaker")
//            }
            Toggle(isOn: $preferences.fastRefreshEnabled) {
                Label("settings.other.fast-refresh", systemImage: "arrow.clockwise")
            }
        } header: {
            Text("settings.section.other")
        } footer: {
            Text("settings.section.other.footer")
        }
//        .listRowBackground(theme.primaryBackgroundColor)
    }
    
    private var cacheSection: some View {
        Section("settings.section.cache") {
            if cachedRemoved {
                Text("action.done")
                    .transition(.move(edge: .leading))
            } else {
                Button("settings.cache-media.clear", role: .destructive) {
                    ImagePipeline.shared.cache.removeAll()
                    withAnimation {
                        cachedRemoved = true
                    }
                }
            }
        }
    }
    
    private var addAccountButton: some View {
        Button {
            addAccountSheetPresented.toggle()
        } label: {
            Text("Add")
        }
        .sheet(isPresented: $addAccountSheetPresented) {
            AddAccountView()
        }
    }
    
    private var editAccountButton: some View {
        Button(role: isEditingAccount ? .none : .destructive) {
            withAnimation {
                isEditingAccount.toggle()
            }
        } label: {
            if isEditingAccount {
                Text("Done")
            } else {
                Text("Log out")
            }
        }
    }
    
    private func logoutAccount(account: AppAccount) async {
        if let token = account.oauthToken
        //            ,let sub = pushNotifications.subscriptions.first(where: { $0.account.token == token })
        {
            let client = Client(server: account.server, oauthToken: token)
            await timelineCache.clearCache(for: client.id)
            //        await sub.deleteSubscription()
            appAccountsManager.delete(account: account)
        }
    }
}

//#Preview {
//    SettingsTab()
//}
