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
            }
        }
    }
    
    func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
        sheet(item: sheetDestinations) { destination in
            Group {
                switch destination {
                case .addAccount:
                    LoginView()
                case .settings:
                    SettingsTab(popToRootTab: .constant(.settings), isModal: true)
                }
            }
            .withEnvironments()
        }
    }
    
    func withEnvironments() -> some View {
        environment(CurrentAccount.shared)
        .environment(UserPreferences.shared)
        .environment(CurrentInstance.shared)
//        .environment(Theme.shared)
        .environment(AppAccountsManager.shared)
//        .environment(PushNotificationsService.shared)
        .environment(AppAccountsManager.shared.currentClient)
//        .environment(QuickLook.shared)
    }

}