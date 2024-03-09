//
//  AppRouter.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 05/12/2023.
//

import SwiftUI
import Models
import Environment
import AppAccount
//import Networking
import Account
import TrackerUI
import Status
import Timeline
import CinephileUI
//import Lists
import LinkPresentation

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
                TrackerExploreView()
            case .socialSearchView:
                ExploreView(scrollToTopSignal: .constant(0))
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
            case .conversationDetail(conversation: _):
                EmptyView()
            case .hashTag(tag: let tag, accountId: let id):
                TimelineView(timeline: .constant(.hashtag(tag: tag, accountId: id)),
                             selectedTagGroup: .constant(nil),
                             scrollToTopSignal: .constant(0),
                             canFilterTimeline: false)
                //            case .list(list: let list):
                //                TimelineView(timeline: .constant(.list(list: list)),
                //                             selectedTagGroup: .constant(nil),
                //                             scrollToTopSignal: .constant(0),
                //                             canFilterTimeline: false)
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
            case let .media(id, title):
                TimelineView(timeline: .constant(.media(id: id, title: title)),
                             selectedTagGroup: .constant(nil),
                             scrollToTopSignal: .constant(0),
                             canFilterTimeline: false)
            case let .genre(id, title):
                TimelineView(timeline: .constant(.genre(id: id, title: title)),
                             selectedTagGroup: .constant(nil),
                             scrollToTopSignal: .constant(0),
                             canFilterTimeline: false)

            }
        }
    }
    
    func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
        sheet(item: sheetDestinations) { destination in
            Group {
                switch destination {
                case let .replyToStatusEditor(status):
                    StatusEditor.MainView(mode: .replyTo(status: status))
                case let .newStatusEditor(visibility):
                    StatusEditor.MainView(mode: .new(visibility: visibility))
                case let .editStatusEditor(status):
                    StatusEditor.MainView(mode: .edit(status: status))
                case let .quoteStatusEditor(status):
                    StatusEditor.MainView(mode: .quote(status: status))
                case let .mentionStatusEditor(account, visibility):
                    StatusEditor.MainView(mode: .mention(account: account, visibility: visibility))
                case let .statusEditHistory(status):
                    StatusEditHistoryView(statusId: status)
                case .settings:
                    SettingsTab(popToRootTab: .constant(.settings), isModal: true)
                case let .report(status):
                    ReportView(status: status)
                case let .shareImage(image, status):
                    ActivityView(image: image, status: status)
                case .addAccount:
                    AddAccountView()
                case .accountPushNotficationsSettings:
                    if let subscription = PushNotificationsService.shared.subscriptions.first(where: { $0.account.token == AppAccountsManager.shared.currentAccount.oauthToken }) {
                        NavigationSheet { PushNotificationsView(subscription: subscription) }
                    } else {
                        EmptyView()
                    }
                case .genresPicker:
                    GenresPicker()
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
            .environment(PushNotificationsService.shared)
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

struct ActivityView: UIViewControllerRepresentable {
    let image: UIImage
    let status: Status
    
    class LinkDelegate: NSObject, UIActivityItemSource {
        let image: UIImage
        let status: Status
        
        init(image: UIImage, status: Status) {
            self.image = image
            self.status = status
        }
        
        func activityViewControllerLinkMetadata(_: UIActivityViewController) -> LPLinkMetadata? {
            let imageProvider = NSItemProvider(object: image)
            let metadata = LPLinkMetadata()
            metadata.imageProvider = imageProvider
            metadata.title = status.reblog?.content.asRawText ?? status.content.asRawText
            return metadata
        }
        
        func activityViewControllerPlaceholderItem(_: UIActivityViewController) -> Any {
            image
        }
        
        func activityViewController(_: UIActivityViewController,
                                    itemForActivityType _: UIActivity.ActivityType?) -> Any?
        {
            nil
        }
    }
    
    func makeUIViewController(context _: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        UIActivityViewController(activityItems: [image, LinkDelegate(image: image, status: status)],
                                 applicationActivities: nil)
    }
    
    func updateUIViewController(_: UIActivityViewController, context _: UIViewControllerRepresentableContext<ActivityView>) {}
}
