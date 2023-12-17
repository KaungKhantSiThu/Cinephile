//
//  File.swift
//  
//
//  Created by Kaung Khant Si Thu on 16/12/2023.
//

import SwiftUI
import Models
import Networking

@MainActor
@Observable public class AppAccountViewModel {
  private static var avatarsCache: [String: UIImage] = [:]
  private static var accountsCache: [String: Account] = [:]

  var appAccount: AppAccount
  let client: Client
  let isCompact: Bool
  let isInNavigation: Bool
  let showBadge: Bool

  var account: Account? {
    didSet {
      if let account {
        refresh(account: account)
      }
    }
  }

  var acct: String {
    if let acct = appAccount.accountName {
      acct
    } else {
      "@\(account?.acct ?? "...")@\(appAccount.server)"
    }
  }

  public init(appAccount: AppAccount, isCompact: Bool = false, isInNavigation: Bool = true, showBadge: Bool = false) {
    self.appAccount = appAccount
    self.isCompact = isCompact
    self.isInNavigation = isInNavigation
    self.showBadge = showBadge
    client = .init(server: appAccount.server, oauthToken: appAccount.oauthToken)
  }

  func fetchAccount() async {
    do {
      account = Self.accountsCache[appAccount.id]

      account = try await client.get(endpoint: Accounts.verifyCredentials)
      Self.accountsCache[appAccount.id] = account
    } catch {}
  }

  private func refresh(account: Account) {
    do {
      if appAccount.accountName == nil {
        appAccount.accountName = "\(account.acct)@\(appAccount.server)"
          try appAccount.save()
      }
    } catch {}
  }
}
