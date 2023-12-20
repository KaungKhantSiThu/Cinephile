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

@MainActor
struct SettingsTab: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(Client.self) private var client
    @Environment(CurrentInstance.self) private var currentInstance
    @Environment(AppAccountsManager.self) private var appAccountsManager
    
    @State private var routerPath = RouterPath()
    @State private var addAccountSheetPresented = false
    @State private var isEditingAccount = false
    
    @Binding var popToRootTab: Tab
    
    let isModal: Bool
    
//    init(popToRootTab: Binding<Tab>) {
//        _popToRootTab = popToRootTab
//    }
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            Form {
                accountsSection
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
//            .withSafariRouter()
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
    
    private var addAccountButton: some View {
      Button {
        addAccountSheetPresented.toggle()
      } label: {
        Text("settings.account.add")
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
          Text("action.done")
        } else {
          Text("account.action.logout")
        }
      }
    }
    
    private func logoutAccount(account: AppAccount) async {
//      if let token = account.oauthToken
//            ,let sub = pushNotifications.subscriptions.first(where: { $0.account.token == token })
//      {
//        let client = Client(server: account.server, oauthToken: token)
//        await timelineCache.clearCache(for: client.id)
//        await sub.deleteSubscription()
//        appAccountsManager.delete(account: account)
//      }
        appAccountsManager.delete(account: account)
    }
}

//#Preview {
//    SettingsTab()
//}
