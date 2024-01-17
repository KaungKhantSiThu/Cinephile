import CinephileUI
import Environment
import Models
import Networking
import SwiftUI

@MainActor
struct StatusRowActionsView: View {
    @Environment(Theme.self) private var theme
    @Environment(CurrentAccount.self) private var currentAccount
    @Environment(StatusDataController.self) private var statusDataController
    @Environment(UserPreferences.self) private var userPreferences
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.isStatusFocused) private var isFocused
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    
    var viewModel: StatusRowViewModel
    
    var isNarrow: Bool {
        horizontalSizeClass == .compact && (UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac)
    }
    
    
    func privateBoost() -> Bool {
        viewModel.status.visibility == .priv && viewModel.status.account.id == currentAccount.account?.id
    }
    
    @MainActor
    enum Action: CaseIterable {
        case respond, boost, favorite, bookmark, share
        
        // Have to implement this manually here due to compiler not implicitly
        // inserting `nonisolated`, which leads to a warning:
        //
        //     Main actor-isolated static property 'allCases' cannot be used to
        //     satisfy nonisolated protocol requirement
        //
        public nonisolated static var allCases: [StatusRowActionsView.Action] {
            [.favorite, .respond, .boost, .bookmark, .share]
        }
        
        func image(dataController: StatusDataController, privateBoost: Bool = false) -> Image {
            switch self {
            case .respond:
                return Image(systemName: "message")
            case .boost:
                if privateBoost {
                    return dataController.isReblogged ?
                    Image(systemName:  "arrow.2.squarepath")
                        .symbolRenderingMode(.palette)
                    :
                    Image(systemName: "lock.rotation")
                    
                }
                return dataController.isReblogged ?
                Image(systemName:  "arrow.2.squarepath")
                    .symbolRenderingMode(.palette) :
                Image(systemName: "arrow.2.squarepath")
                
            case .favorite:
                return Image(systemName: dataController.isFavorited ? "heart.fill" : "heart")
            case .bookmark:
                return Image(systemName: dataController.isBookmarked ? "bookmark.fill" : "bookmark")
            case .share:
                return Image(systemName: "square.and.arrow.up")
            }
        }
        
        func accessibilityLabel(dataController: StatusDataController, privateBoost: Bool = false) -> LocalizedStringKey {
            switch self {
            case .respond:
                return "status.action.reply"
            case .boost:
                if dataController.isReblogged {
                    return "status.action.unboost"
                }
                return privateBoost
                ? "status.action.boost-to-followers"
                : "status.action.boost"
            case .favorite:
                return dataController.isFavorited
                ? "status.action.unfavorite"
                : "status.action.favorite"
            case .bookmark:
                return dataController.isBookmarked
                ? "status.action.unbookmark"
                : "status.action.bookmark"
            case .share:
                return "status.action.share"
            }
        }
        
        func count(dataController: StatusDataController, isFocused: Bool, theme: Theme) -> Int? {
            if theme.statusActionsDisplay == .discret, isFocused {
                return nil
            }
            switch self {
            case .respond:
                return dataController.repliesCount
            case .favorite:
                return dataController.favoritesCount
            case .boost:
                return dataController.reblogsCount
            case .share, .bookmark:
                return nil
            }
        }
        
        func tintColor(theme: Theme) -> Color? {
            switch self {
            case .respond, .share:
                nil
            case .favorite:
                    .red
            case .bookmark:
                theme.tintColor
            case .boost:
                //        theme.tintColor
                    .green
            }
        }
        
        func isOn(dataController: StatusDataController) -> Bool {
            switch self {
            case .respond, .share: false
            case .favorite: dataController.isFavorited
            case .bookmark: dataController.isBookmarked
            case .boost: dataController.isReblogged
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                ForEach(Action.allCases, id: \.self) { action in
                    if action == .share {
                        if let urlString = viewModel.finalStatus.url,
                           let url = URL(string: urlString)
                        {
                            switch userPreferences.shareButtonBehavior {
                            case .linkOnly:
                                ShareLink(item: url) {
                                    action.image(dataController: statusDataController)
                                }
                                .buttonStyle(.statusAction())
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("status.action.share-link")
                            case .linkAndText:
                                ShareLink(item: url,
                                          subject: Text(viewModel.finalStatus.account.safeDisplayName),
                                          message: Text(viewModel.finalStatus.content.asRawText))
                                {
                                    action.image(dataController: statusDataController)
                                }
                                .buttonStyle(.statusAction())
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("status.action.share-link")
                            }
                        }
                    } else {
                        actionButton(action: action)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func actionButton(action: Action) -> some View {
        Button {
            handleAction(action: action)
        } label: {
            HStack(spacing: 2) {
                if action == .boost {
                    action
                        .image(dataController: statusDataController, privateBoost: privateBoost())
                        .imageScale(.medium)
                        .font(.scaledBody)
                    //                        .fontWeight(.black)
                } else {
                    action
                        .image(dataController: statusDataController, privateBoost: privateBoost())
                        .font(.scaledBody)
                }
                if !isNarrow,
                   let count = action.count(dataController: statusDataController,
                                            isFocused: isFocused,
                                            theme: theme), !viewModel.isRemote
                {
                    Text("\(count)")
                        .contentTransition(.numericText(value: Double(count)))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .font(.scaledFootnote)
                        .monospacedDigit()
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(
            .statusAction(
                isOn: action.isOn(dataController: statusDataController),
                tintColor: action.tintColor(theme: theme)
            )
        )
        .disabled(action == .boost &&
                  (viewModel.status.visibility == .direct || viewModel.status.visibility == .priv && viewModel.status.account.id != currentAccount.account?.id))
        //       .accessibilityElement(children: .combine)
        //       .accessibilityLabel(action.accessibilityLabel(dataController: statusDataController, privateBoost: privateBoost()))
    }
    //  private func actionButton(action: Action) -> some View {
    //      Button {
    //        handleAction(action: action)
    //      } label: {
    //          HStack(alignment: .center, spacing: 2) {
    //
    //              if action == .boost {
    //                  action
    //                      .image(dataController: statusDataController, privateBoost: privateBoost())
    //                      .imageScale(.medium)
    //                      .font(.body)
    //                      .fontWeight(.black)
    //              } else {
    //                  action
    //                      .image(dataController: statusDataController, privateBoost: privateBoost())
    //              }
    //
    //              if !isNarrow,
    //                         let count = action.count(dataController: statusDataController,
    //                                                  isFocused: isFocused,
    //                                                  theme: theme), !viewModel.isRemote
    //                      {
    //                        Text("\(count)")
    //                          .contentTransition(.numericText(value: Double(count)))
    //                          .foregroundColor(Color(UIColor.secondaryLabel))
    //                          .font(.scaledFootnote)
    //                          .monospacedDigit()
    //                      }
    //
    //          }
    //      }
    //
    //    }
    //        .buttonStyle(
    //          .statusAction(
    //            isOn: action.isOn(dataController: statusDataController),
    //            tintColor: action.tintColor(theme: theme)
    //          )
    //        )
    //        .disabled(action == .boost &&
    //          (viewModel.status.visibility == .direct || viewModel.status.visibility == .priv && viewModel.status.account.id != currentAccount.account?.id))
    //
    //        if let count = action.count(dataController: statusDataController,
    //                                    isFocused: isFocused,
    //                                    theme: theme), !viewModel.isRemote
    //        {
    //            Text("\(count)")
    //            .foregroundColor(Color(UIColor.secondaryLabel))
    //            .font(.scaledFootnote)
    //            .monospacedDigit()
    //        }
    //    .accessibilityElement(children: .combine)
    //    .accessibilityLabel(action.accessibilityLabel(dataController: statusDataController, privateBoost: privateBoost()))
    //  }
    
    private func handleAction(action: Action) {
        Task {
            if viewModel.isRemote, viewModel.localStatusId == nil || viewModel.localStatus == nil {
                guard await viewModel.fetchRemoteStatus() else {
                    return
                }
            }
            //      HapticManager.shared.fireHaptic(.notification(.success))
            switch action {
            case .respond:
                //        SoundEffectManager.shared.playSound(.share)
#if targetEnvironment(macCatalyst)
                openWindow(value: WindowDestinationEditor.replyToStatusEditor(status: viewModel.localStatus ?? viewModel.status))
#else
                viewModel.routerPath.presentedSheet = .replyToStatusEditor(status: viewModel.localStatus ?? viewModel.status)
#endif
            case .favorite:
                //        SoundEffectManager.shared.playSound(.favorite)
                await statusDataController.toggleFavorite(remoteStatus: viewModel.localStatusId)
            case .bookmark:
                //        SoundEffectManager.shared.playSound(.bookmark)
                await statusDataController.toggleBookmark(remoteStatus: viewModel.localStatusId)
            case .boost:
                //        SoundEffectManager.shared.playSound(.boost)
                await statusDataController.toggleReblog(remoteStatus: viewModel.localStatusId)
            default:
                break
            }
        }
    }
}
