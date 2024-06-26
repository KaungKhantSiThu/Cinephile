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
import Status
import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Account", category: "DetailViewModel")

@MainActor
@Observable class AccountDetailViewModel: StatusesFetcher {
    let id: Account.ID
    var client: Client?
    var isCurrentUser: Bool = false
    
    enum AccountState {
        case loading, loaded(account: Account), failed(error: Error)
    }
    
    enum Tab: Hashable, CaseIterable, Identifiable {
        case statuses, favorites, bookmarks, replies, boosts, media
        
        var id: Self { self }
        
        static var currentAccountTabs: [Tab] {
            [.statuses,.replies, .favorites, .bookmarks]
        }
        
        static var accountTabs: [Tab] {
            [.statuses, .replies, .media]
        }
        
        var iconName: String {
            switch self {
            case .statuses: "doc.richtext"
            case .favorites: "heart"
            case .bookmarks: "bookmark"
            case .replies: "bubble.left.and.bubble.right"
            case .boosts: "arrow.2.squarepath"
            case .media: "photo.on.rectangle.angled"
            }
        }
        
        var accessibilityLabel: LocalizedStringKey {
            switch self {
            case .statuses: "accessibility.tabs.profile.picker.statuses"
            case .favorites: "accessibility.tabs.profile.picker.favorites"
            case .bookmarks: "accessibility.tabs.profile.picker.bookmarks"
            case .replies: "accessibility.tabs.profile.picker.posts-and-replies"
            case .boosts: "accessibility.tabs.profile.picker.boosts"
            case .media: "accessibility.tabs.profile.picker.media"
            }
        }
    }
    
    enum TabState {
        case followedTags
        case statuses(statusesState: StatusesState)
        case lists
    }
    
    var state: AccountState = .loading
    var tabState: TabState = .statuses(statusesState: .loading) {
        didSet {
            /// Forward viewModel tabState related to statusesState to statusesState property
            /// for `StatusesFetcher` conformance as we wrap StatusesState in TabState
            switch tabState {
            case let .statuses(statusesState):
                self.statusesState = statusesState
            default:
                break
            }
        }
    }
    
    var statusesState: StatusesState = .loading
    
    var relationship: Relationship?
    var pinned: [Status] = []
    var favorites: [Status] = []
    var bookmarks: [Status] = []
    private var favoritesNextPage: LinkHandler?
    private var bookmarksNextPage: LinkHandler?
    var featuredTags: [FeaturedTag] = []
    var fields: [Account.Field] = []
    var familiarFollowers: [Account] = []
    var selectedTab = Tab.statuses {
        didSet {
            switch selectedTab {
            case .statuses, .replies, .media:
                tabTask?.cancel()
                tabTask = Task {
                    await fetchNewestStatuses(pullToRefresh: false)
                }
            default:
                reloadTabState()
            }
        }
    }
    
    var scrollToTopVisible: Bool = false
    
    private(set) var account: Account?
    private var tabTask: Task<Void, Never>?
    
    private(set) var statuses: [Status] = []
    
    var boosts: [Status] = []

    
    /// When coming from a URL like a mention tap in a status.
    init(id: Account.ID) {
        self.id = id
        isCurrentUser = false
    }
    
    /// When the account is already fetched by the parent caller.
    init(account: Account) {
        id = account.id
        self.account = account
        state = .loaded(account: account)
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
            state = .loaded(account: data.account)
            
            account = data.account
            fields = data.account.fields
            featuredTags = data.featuredTags
            featuredTags.sort { $0.statusesCountInt > $1.statusesCountInt }
            relationship = data.relationships.first
            
        } catch {
            if let account {
                state = .loaded(account: account)
            } else {
                state = .failed(error: error)
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
    
    func fetchNewestStatuses(pullToRefresh: Bool) async {
        guard let client else { return }
        do {
            tabState = .statuses(statusesState: .loading)
            boosts = []
            statuses =
            try await client.get(endpoint: Accounts.statuses(id: id,
                                                             sinceId: nil,
                                                             tag: nil,
                                                             onlyMedia: selectedTab == .media,
                                                             excludeReplies: selectedTab == .replies,
                                                             excludeReblogs: selectedTab == .boosts,
                                                             pinned: nil))
            StatusDataControllerProvider.shared.updateDataControllers(for: statuses, client: client)
            if selectedTab == .boosts {
                boosts = statuses.filter { $0.reblog != nil }
            }
            if selectedTab == .statuses {
                pinned =
                try await client.get(endpoint: Accounts.statuses(id: id,
                                                                 sinceId: nil,
                                                                 tag: nil,
                                                                 onlyMedia: false,
                                                                 excludeReplies: false,
                                                                 excludeReblogs: false,
                                                                 pinned: true))
                StatusDataControllerProvider.shared.updateDataControllers(for: pinned, client: client)
            }
            if isCurrentUser {
                (favorites, favoritesNextPage) = try await client.getWithLink(endpoint: Accounts.favorites(sinceId: nil))
                (bookmarks, bookmarksNextPage) = try await client.getWithLink(endpoint: Accounts.bookmarks(sinceId: nil))
                StatusDataControllerProvider.shared.updateDataControllers(for: favorites, client: client)
                StatusDataControllerProvider.shared.updateDataControllers(for: bookmarks, client: client)
            }
            reloadTabState()
        } catch {
            tabState = .statuses(statusesState: .error(error: error))
        }
    }
    
    func fetchNextPage() async {
        guard let client else { return }
        do {
            switch selectedTab {
            case .statuses, .replies, .boosts, .media:
                guard let lastId = statuses.last?.id else { return }
                tabState = .statuses(statusesState: .display(statuses: statuses, nextPageState: .loadingNextPage))
                let newStatuses: [Status] =
                try await client.get(endpoint: Accounts.statuses(id: id,
                                                                 sinceId: lastId,
                                                                 tag: nil,
                                                                 onlyMedia: selectedTab == .media,
                                                                 excludeReplies: selectedTab != .replies,
                                                                 excludeReblogs: selectedTab != .boosts,
                                                                 pinned: nil))
                statuses.append(contentsOf: newStatuses)
                if selectedTab == .boosts {
                  let newBoosts = statuses.filter { $0.reblog != nil }
                  boosts.append(contentsOf: newBoosts)
                }
                StatusDataControllerProvider.shared.updateDataControllers(for: newStatuses, client: client)
                if selectedTab == .boosts {
                    tabState = .statuses(statusesState: .display(statuses: boosts, nextPageState: newStatuses.count < 20 ? .none : .hasNextPage))
                } else {
                    tabState = .statuses(statusesState: .display(statuses: statuses,
                                                                 nextPageState: newStatuses.count < 20 ? .none : .hasNextPage))
                }
                
                
            case .favorites:
                guard let nextPageId = favoritesNextPage?.maxId else { return }
                let newFavorites: [Status]
                (newFavorites, favoritesNextPage) = try await client.getWithLink(endpoint: Accounts.favorites(sinceId: nextPageId))
                favorites.append(contentsOf: newFavorites)
                StatusDataControllerProvider.shared.updateDataControllers(for: newFavorites, client: client)
                tabState = .statuses(statusesState: .display(statuses: favorites, nextPageState: .hasNextPage))
            case .bookmarks:
                guard let nextPageId = bookmarksNextPage?.maxId else { return }
                let newBookmarks: [Status]
                (newBookmarks, bookmarksNextPage) = try await client.getWithLink(endpoint: Accounts.bookmarks(sinceId: nextPageId))
                StatusDataControllerProvider.shared.updateDataControllers(for: newBookmarks, client: client)
                bookmarks.append(contentsOf: newBookmarks)
                tabState = .statuses(statusesState: .display(statuses: bookmarks, nextPageState: .hasNextPage))
            }
        } catch {
            tabState = .statuses(statusesState: .error(error: error))
        }
    }
    
    private func reloadTabState() {
        switch selectedTab {
        case .statuses, .replies, .media:
            tabState = .statuses(statusesState: .display(statuses: statuses, nextPageState: statuses.count < 20 ? .none : .hasNextPage))
        case .boosts:
            tabState = .statuses(statusesState: .display(statuses: boosts, nextPageState: statuses.count < 20 ? .none : .hasNextPage))
        case .favorites:
            tabState = .statuses(statusesState: .display(statuses: favorites,
                                                         nextPageState: favoritesNextPage != nil ? .hasNextPage : .none))
        case .bookmarks:
            tabState = .statuses(statusesState: .display(statuses: bookmarks,
                                                         nextPageState: bookmarksNextPage != nil ? .hasNextPage : .none))
        }
    }
    
    func handleEvent(event: any StreamEvent, currentAccount: CurrentAccount) {
        if let event = event as? StreamEventUpdate {
            if event.status.account.id == currentAccount.account?.id {
                if (event.status.inReplyToId == nil && selectedTab == .statuses) || (event.status.inReplyToId == nil && selectedTab == .replies) {
                    statuses.insert(event.status, at: 0)
                    statusesState = .display(statuses: statuses, nextPageState: .hasNextPage)
                }
            }
        } else if let event = event as? StreamEventDelete {
            statuses.removeAll(where: { $0.id == event.status })
            statusesState = .display(statuses: statuses, nextPageState: .hasNextPage)
        } else if let event = event as? StreamEventStatusUpdate {
            if let originalIndex = statuses.firstIndex(where: { $0.id == event.status.id }) {
                statuses[originalIndex] = event.status
                statusesState = .display(statuses: statuses, nextPageState: .hasNextPage)
            }
        }
    }
    
    func statusDidAppear(status _: Models.Status) {}
    
    func statusDidDisappear(status _: Status) {}
}
