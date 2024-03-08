//
//  AppAccountsSelectorView.swift
//
//
//  Created by Kaung Khant Si Thu on 17/12/2023.
//

import Environment
import SwiftUI
import CinephileUI

@MainActor
public struct AppAccountsSelectorView: View {
  @Environment(UserPreferences.self) private var preferences
  @Environment(CurrentAccount.self) private var currentAccount
  @Environment(AppAccountsManager.self) private var appAccounts

  var routerPath: RouterPath

  @State private var accountsViewModel: [AppAccountViewModel] = []
  @State private var isPresented: Bool = false

  private let accountCreationEnabled: Bool
  private let avatarConfig: AvatarView.FrameConfiguration

  private var showNotificationBadge: Bool {
    accountsViewModel
      .filter { $0.account?.id != currentAccount.account?.id }
      .compactMap(\.appAccount.oauthToken)
      .map { preferences.notificationsCount[$0] ?? 0 }
      .reduce(0, +) > 0
  }

  private var preferredHeight: CGFloat {
    var baseHeight: CGFloat = 220
    baseHeight += CGFloat(60 * accountsViewModel.count)
    return baseHeight
  }

  public init(routerPath: RouterPath,
              accountCreationEnabled: Bool = true,
              avatarConfig: AvatarView.FrameConfiguration = .badge)
  {
    self.routerPath = routerPath
    self.accountCreationEnabled = accountCreationEnabled
    self.avatarConfig = avatarConfig
  }

  public var body: some View {
    Button {
      isPresented.toggle()
//      HapticManager.shared.fireHaptic(.buttonPress)
    } label: {
      labelView
        .contentShape(Rectangle())
    }
    .sheet(isPresented: $isPresented, content: {
      accountsView.presentationDetents([.height(preferredHeight), .large])
        .presentationBackground(.thinMaterial)
        .presentationCornerRadius(16)
        .onAppear {
          refreshAccounts()
        }
    })
    .onChange(of: currentAccount.account?.id) {
      refreshAccounts()
    }
    .onAppear {
      refreshAccounts()
    }
//    .accessibilityRepresentation {
//      Menu("accessibility.app-account.selector.accounts") {}
//        .accessibilityHint("accessibility.app-account.selector.accounts.hint")
//        .accessibilityRemoveTraits(.isButton)
//    }
  }

  @ViewBuilder
  private var labelView: some View {
    Group {
      if let account = currentAccount.account, !currentAccount.isLoadingAccount {
        AvatarView(account.avatar, config: avatarConfig)
      } else {
        AvatarView(config: avatarConfig)
          .redacted(reason: .placeholder)
          .allowsHitTesting(false)
      }
    }.overlay(alignment: .topTrailing) {
      if !currentAccount.followRequests.isEmpty || showNotificationBadge, accountCreationEnabled {
//        if !currentAccount.followRequests.isEmpty, accountCreationEnabled {

        Circle()
          .fill(Color.red)
          .frame(width: 9, height: 9)
      }
    }
  }

  private var accountsView: some View {
    NavigationStack {
      List {
        Section {
          ForEach(accountsViewModel.sorted { $0.acct < $1.acct }, id: \.appAccount.id) { viewModel in
            AppAccountView(viewModel: viewModel)
          }
        }
//        .listRowBackground(theme.primaryBackgroundColor)

        if accountCreationEnabled {
          Section {
            Button {
              isPresented = false
//              HapticManager.shared.fireHaptic(.buttonPress)
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                routerPath.presentedSheet = .addAccount
              }
            } label: {
              Label("Add", systemImage: "person.badge.plus")
            }
            settingsButton
          }
//          .listRowBackground(theme.primaryBackgroundColor)
        }
      }
      .listStyle(.insetGrouped)
      .scrollContentBackground(.hidden)
      .background(.clear)
      .navigationTitle("Account Setting")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            isPresented.toggle()
          } label: {
              Text("Done").bold()
          }
        }
      }
      .environment(routerPath)
    }
  }

  private var settingsButton: some View {
    Button {
      isPresented = false
//      HapticManager.shared.fireHaptic(.buttonPress)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        routerPath.presentedSheet = .settings
      }
    } label: {
      Label("settings", systemImage: "gear")
    }
  }

  private func refreshAccounts() {
    accountsViewModel = []
    for account in appAccounts.availableAccounts {
      let viewModel: AppAccountViewModel = .init(appAccount: account, isInNavigation: false, showBadge: true)
      accountsViewModel.append(viewModel)
    }
  }
}

