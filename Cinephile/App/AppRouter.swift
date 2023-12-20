//
//  AppRouter.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 05/12/2023.
//

import Foundation
import SwiftUI
import Models
import Environment
import AppAccount
import Networking
import Account
import TrackerUI
import Status
import Timeline
import CinephileUI
import Lists

@MainActor
extension View {
    func withAppRouter() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
            case let .movieDetail(id):
                MovieDetailView(id: id)
            case let .seriesDetail(id):
                SeriesDetailView(id: id)
            case .trackerSearchView:
                SearchView()
            case .episodeListView(id: let id, inSeason: let seasonNumber):
                EpisodeListView(id: id, inSeason: seasonNumber)
            case .accountDetail(id: let id):
                AccountDetailView(id: id, scrollToTopSignal: .constant(0))
            case .accountDetailWithAccount(account: let account):
                AccountDetailView(account: account, scrollToTopSignal: .constant(0))
            case .accountSettingsWithAccount(account: let account, appAccount: let appAccount):
                AccountSettingsView(account: account, appAccount: appAccount)
            case .statusDetail(id: let id):
                StatusDetailView(statusId: id)
            case .statusDetailWithStatus(status: let status):
                StatusDetailView(status: status)
            case .remoteStatusDetail(url: let url):
                StatusDetailView(remoteStatusURL: url)
            case .conversationDetail(conversation: let _):
                EmptyView()
            case .hashTag(tag: let tag, accountId: let id):
                TimelineView(timeline: .constant(.hashtag(tag: tag, accountId: id)),
                             selectedTagGroup: .constant(nil),
                             scrollToTopSignal: .constant(0),
                             canFilterTimeline: false)
            case .list(list: let list):
                TimelineView(timeline: .constant(.list(list: list)),
                             selectedTagGroup: .constant(nil),
                             scrollToTopSignal: .constant(0),
                             canFilterTimeline: false)
            case .followers(id: let id):
                AccountsListView(mode: .followers(accountId: id))
            case .following(id: let id):
                AccountsListView(mode: .following(accountId: id))
            case .favoritedBy(id: let id):
                AccountsListView(mode: .favoritedBy(statusId: id))
            case .rebloggedBy(id: let id):
                AccountsListView(mode: .rebloggedBy(statusId: id))
            case .accountsList(accounts: let accounts):
                AccountsListView(mode: .accountsList(accounts: accounts))
            case .trendingTimeline:
                TimelineView(timeline: .constant(.trending),
                             selectedTagGroup: .constant(nil),
                             scrollToTopSignal: .constant(0),
                             canFilterTimeline: false)
            case .trendingLinks(cards: _):
//                CardsListView(cards: cards)
                EmptyView()
            case .tagsList(tags: _):
//                TagsListView(tags: tags)
                EmptyView()
            }
        }
    }
    
    func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
        sheet(item: sheetDestinations) { destination in
            Group {
                switch destination {
                case .addAccount:
                    AddAccountView()
                case .settings:
                    SettingsTab(popToRootTab: .constant(.settings), isModal: true)
                        .preferredColorScheme(Theme.shared.selectedScheme == .dark ? .dark : .light)
//                case .newStatusEditor(visibility: let visibility):
//                    StatusEditorView(mode: .new(visibility: visibility))
//                case .editStatusEditor(status: let status):
//                    StatusEditorView(mode: .edit(status: status))
//                case .replyToStatusEditor(status: let status):
//                    StatusEditorView(mode: .replyTo(status: status))
//                case .quoteStatusEditor(status: let status):
//                    StatusEditorView(mode: .quote(status: status))
//                case .mentionStatusEditor(account: let account, visibility: let visibility):
//                    StatusEditorView(mode: .mention(account: Account, visibility: visibility))
//                case .report(status: let status):
//                    ReportView()
//                case .shareImage(image: let image, status: let status):
//                    ActivityView(image: image, status: status)
                }
            }
            .withEnvironments()
        }
    }
    
    func withEnvironments() -> some View {
        environment(CurrentAccount.shared)
        .environment(UserPreferences.shared)
        .environment(CurrentInstance.shared)
        .environment(Theme.shared)
        .environment(AppAccountsManager.shared)
//        .environment(PushNotificationsService.shared)
        .environment(AppAccountsManager.shared.currentClient)
        .environment(QuickLook.shared)
    }
    
    func withModelContainer() -> some View {
      modelContainer(for: [
        Draft.self,
        LocalTimeline.self,
        TagGroup.self,
      ])
    }

}
