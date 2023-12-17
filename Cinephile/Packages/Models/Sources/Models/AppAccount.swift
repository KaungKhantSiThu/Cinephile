import Foundation
import SwiftUI
import KeychainSwift

public struct AppAccount: Codable, Identifiable, Hashable {
  public let server: String
  public var accountName: String?
  public let oauthToken: OauthToken?

  public var key: String {
    if let oauthToken {
      "\(server):\(oauthToken.createdAt)"
    } else {
      "\(server):anonymous"
    }
  }

  public var id: String {
    key
  }

  public init(server: String,
              accountName: String?,
              oauthToken: OauthToken? = nil)
  {
    self.server = server
    self.accountName = accountName
    self.oauthToken = oauthToken
  }
}

extension AppAccount: Sendable {}

public extension AppAccount {
  private static var keychain: KeychainSwift {
    let keychain = KeychainSwift()
    #if !DEBUG && !targetEnvironment(simulator)
      keychain.accessGroup = AppInfo.keychainGroup
    #endif
    return keychain
  }

  func save() throws {
    let encoder = JSONEncoder()
    let data = try encoder.encode(self)
    Self.keychain.set(data, forKey: key, withAccess: .accessibleAfterFirstUnlock)
  }

  func delete() {
    Self.keychain.delete(key)
  }

  static func retrieveAll() -> [AppAccount] {
    let keychain = Self.keychain
    let decoder = JSONDecoder()
    let keys = keychain.allKeys
    var accounts: [AppAccount] = []
    for key in keys {
      if let data = keychain.getData(key) {
        if let account = try? decoder.decode(AppAccount.self, from: data) {
          accounts.append(account)
          try? account.save()
        }
      }
    }
    return accounts
  }

  static func deleteAll() {
    let keychain = Self.keychain
    let keys = keychain.allKeys
    for key in keys {
      keychain.delete(key)
    }
  }
}
