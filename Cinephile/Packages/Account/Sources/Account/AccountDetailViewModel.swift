//
//  AccountDetailViewModel.swift
//
//
//  Created by Kaung Khant Si Thu on 15/12/2023.
//

import Foundation
import Environment
import Models
import Networking

@MainActor
@Observable class AccountDetailViewModel {
    let id: Account.ID
    var client: Client?
    var isCurrentUser: Bool = false
    
    private(set) var state: AccountState = .loading
    
    private(set) var account: Account?
    
    var featuredTags: [FeaturedTag] = []
    var relationship: Relationship?
    var familiarFollowers: [Account] = []

    init(id: Account.ID) {
        self.id = id
        self.isCurrentUser = false
    }
    
    init(account: Account) {
        self.id = account.id
        self.account = account
        self.state = .loaded(account)
    }
    
}

extension AccountDetailViewModel {
    enum AccountState {
        case loading
        case failed(Error)
        case loaded(Account)
    }
    
    struct AccountData {
      let account: Account
      let featuredTags: [FeaturedTag]
      let relationships: [Relationship]
    }
    
    func fetchAccount() async {
        guard let client else { return }
        do {
          let data = try await fetchAccountData(accountId: id, client: client)
          state = .loaded(data.account)

          account = data.account
          featuredTags = data.featuredTags
          featuredTags.sort { $0.statusesCountInt > $1.statusesCountInt }
          relationship = data.relationships.first
        } catch {
          if let account {
              self.state = .loaded(account)
          } else {
              self.state = .failed(error)
          }
        }
    }
    
    private func fetchAccountData(accountId: String, client: Client) async throws -> AccountData {
      async let account: Account = client.get(endpoint: Accounts.accounts(id: accountId))
      async let featuredTags: [FeaturedTag] = client.get(endpoint: Accounts.featuredTags(id: accountId))
      if client.isAuth, !isCurrentUser {
        async let relationships: [Relationship] = client.get(endpoint: Accounts.relationships(ids: [accountId]))
        do {
          return try await .init(account: account,
                                 featuredTags: featuredTags,
                                 relationships: relationships)
        } catch {
          return try await .init(account: account,
                                 featuredTags: [],
                                 relationships: relationships)
        }
      }
      return try await .init(account: account,
                             featuredTags: featuredTags,
                             relationships: [])
    }
    
    func fetchFamilliarFollowers() async {
      let familiarFollowers: [FamiliarAccounts]? = try? await client?.get(endpoint: Accounts.familiarFollowers(withAccount: id))
      self.familiarFollowers = familiarFollowers?.first?.accounts ?? []
    }
}

