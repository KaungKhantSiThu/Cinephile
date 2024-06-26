//
//  AccountSettingView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 17/12/2023.
//

import Account
import AppAccount
import CinephileUI
import Environment
import Models
import Networking
import SwiftUI
import Timeline

struct AccountSettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.openURL) private var openURL

  @Environment(PushNotificationsService.self) private var pushNotifications
  @Environment(CurrentAccount.self) private var currentAccount
  @Environment(CurrentInstance.self) private var currentInstance
  @Environment(Theme.self) private var theme
  @Environment(AppAccountsManager.self) private var appAccountsManager
  @Environment(Client.self) private var client

  @State private var isEditingAccount: Bool = false
  @State private var isEditingFilters: Bool = false
  @State private var cachedPostsCount: Int = 0
  @State private var timelineCache = TimelineCache()

  let account: Account
  let appAccount: AppAccount

  var body: some View {
    Form {
      Section {
        Button {
          isEditingAccount = true
        } label: {
            Label("account.action.edit-info", image: "profile.edit")
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)

//        if currentInstance.isFiltersSupported {
//          Button {
//            isEditingFilters = true
//          } label: {
//            Label("account.action.edit-filters", systemImage: "line.3.horizontal.decrease.circle")
//              .frame(maxWidth: .infinity, alignment: .leading)
//              .contentShape(Rectangle())
//          }
//          .buttonStyle(.plain)
//        }
        if let subscription = pushNotifications.subscriptions.first(where: { $0.account.token == appAccount.oauthToken }) {
          NavigationLink(destination: PushNotificationsView(subscription: subscription)) {
            Label("Push Notifications", systemImage: "bell.and.waves.left.and.right")
          }
        }
      }
//      .listRowBackground(Color.primaryBackground)
      Section {
        Label("settings.account.cached-posts-\(String(cachedPostsCount))", systemImage: "internaldrive")
        Button("settings.account.action.delete-cache", role: .destructive) {
          Task {
            await timelineCache.clearCache(for: appAccountsManager.currentClient.id)
            cachedPostsCount = await timelineCache.cachedPostsCount(for: appAccountsManager.currentClient.id)
          }
        }
      }
//      .listRowBackground(Color.primaryBackground)

//      Section {
//        Button {
//          openURL(URL(string: "https://\(client.server)/settings/profile")!)
//        } label: {
//          Text("account.action.more")
//        }
//      }
//      .listRowBackground(Color.primaryBackground)
      Section {
        Button(role: .destructive) {
          if let token = appAccount.oauthToken {
            Task {
              let client = Client(server: appAccount.server, oauthToken: token)
              await timelineCache.clearCache(for: client.id)
              if let sub = pushNotifications.subscriptions.first(where: { $0.account.token == token }) {
                await sub.deleteSubscription()
              }
              appAccountsManager.delete(account: appAccount)
              dismiss()
            }
          }
        } label: {
          Text("account.action.logout")
            .frame(maxWidth: .infinity)
        }
      }
//      .listRowBackground(Color.primaryBackground)
    }
    .sheet(isPresented: $isEditingAccount, content: {
      EditAccountView()
    })
    .toolbar {
      ToolbarItem(placement: .principal) {
        HStack {
          AvatarView(account.avatar, config: .embed)
          Text(account.safeDisplayName)
            .font(.headline)
        }
      }
    }
    .task {
      cachedPostsCount = await timelineCache.cachedPostsCount(for: appAccountsManager.currentClient.id)
    }
    .navigationTitle(account.safeDisplayName)
    .scrollContentBackground(.hidden)
//    .background(Color.secondaryBackground)
  }
}

