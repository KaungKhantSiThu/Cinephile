import CinephileUI
import EmojiText
import Environment
import Models
import Networking
import Status
import SwiftUI

@MainActor
struct NotificationRowView: View {
    @Environment(Theme.self) private var theme
    @Environment(\.redactionReasons) private var reasons
    
    let notification: ConsolidatedNotification
    let client: Client
    let routerPath: RouterPath
    let followRequests: [Account]
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if notification.accounts.count == 1 {
                makeAvatarView(type: notification.type)
                    .accessibilityHidden(true)
            } else {
                makeNotificationIconView(type: notification.type)
                    .frame(width: AvatarView.FrameConfiguration.status.width,
                           height: AvatarView.FrameConfiguration.status.height)
                    .accessibilityHidden(true)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                makeMainLabel(type: notification.type)
                // The main label is redundant for mentions
                    .accessibilityHidden(notification.type == .mention)
                makeContent(type: notification.type)
                if notification.type == .follow_request,
                   followRequests.map(\.id).contains(notification.accounts[0].id)
                {
                    FollowRequestButtons(account: notification.accounts[0])
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityActions {
            if notification.type == .follow {
                accessibilityUserActions
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { _ in
            -100
        }
    }
    
    private func makeAvatarView(type: Models.Notification.NotificationType) -> some View {
        ZStack(alignment: .bottomTrailing) {
            AvatarView(notification.accounts[0].avatar)
            makeNotificationIconView(type: type)
                .offset(x: 8, y: 8)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            routerPath.navigate(to: .accountDetailWithAccount(account: notification.accounts[0]))
        }
    }
    
    private func makeNotificationIconView(type: Models.Notification.NotificationType) -> some View {
        ZStack(alignment: .center) {
            Circle()
                .strokeBorder(Color.white, lineWidth: 1)
                .background(
                    Circle()
                        .foregroundColor(type.tintColor(isPrivate: notification.status?.visibility == .direct))
                )
                .backgroundStyle(type.tintColor(isPrivate: notification.status?.visibility == .direct).gradient)
                .foregroundStyle(
                    .white.shadow(.drop(radius: 1, y: 1.5))
                )
                .frame(width: 24, height: 24)
            
            type.icon(isPrivate: notification.status?.visibility == .direct)
                .resizable()
            
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(.white)
            
        }
    }
    
    private func makeMainLabel(type: Models.Notification.NotificationType) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if notification.accounts.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(notification.accounts) { account in
                            AvatarView(account.avatar)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    routerPath.navigate(to: .accountDetailWithAccount(account: account))
                                }
                        }
                    }
                    .padding(.leading, 1)
                    .frame(height: AvatarView.FrameConfiguration.status.size.height + 2)
                }.offset(y: -1)
            }
            if !reasons.contains(.placeholder) {
                HStack(spacing: 0) {
                    EmojiTextApp(.init(stringValue: notification.accounts[0].safeDisplayName),
                                 emojis: notification.accounts[0].emojis,
                                 append: {
                        (notification.accounts.count > 1
                         ? Text("notifications-others-count \(notification.accounts.count - 1)")
                            .font(.scaledSubheadline)
                            .fontWeight(.regular)
                         : Text(" ")) +
                        Text(type.label(count: notification.accounts.count))
                            .font(.scaledSubheadline)
                            .fontWeight(.regular) +
                        Text(" ⸱ ")
                            .font(.scaledFootnote)
                            .fontWeight(.regular)
                            .foregroundStyle(.secondary) +
                        Text(notification.createdAt.relativeFormatted)
                            .font(.scaledFootnote)
                            .fontWeight(.regular)
                            .foregroundStyle(.secondary)
                    })
                    .font(.scaledSubheadline)
                    .emojiSize(Font.scaledSubheadlineFont.emojiSize)
                    .emojiBaselineOffset(Font.scaledSubheadlineFont.emojiBaselineOffset)
                    .fontWeight(.semibold)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    if let status = notification.status, notification.type == .mention {
                        Group {
                            Text(" ⸱ ", bundle: .module)
                            Text(Image(systemName: status.visibility.iconName))
                        }
                        .accessibilityHidden(true)
                        .font(.scaledFootnote)
                        .fontWeight(.regular)
                        .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            } else {
                Text("          ", bundle: .module)
                    .font(.scaledSubheadline)
                    .fontWeight(.semibold)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if notification.accounts.count == 1 {
                routerPath.navigate(to: .accountDetailWithAccount(account: notification.accounts[0]))
            } else {
                routerPath.navigate(to: .accountsList(accounts: notification.accounts))
            }
        }
        .accessibilityElement(children: .combine)
    }
    
    @ViewBuilder
    private func makeContent(type: Models.Notification.NotificationType) -> some View {
        if let status = notification.status {
            HStack {
                if type == .mention {
                    StatusRowView(viewModel: .init(status: status,
                                                   client: client,
                                                   routerPath: routerPath,
                                                   showActions: true))
                } else {
                    StatusRowView(viewModel: .init(status: status,
                                                   client: client,
                                                   routerPath: routerPath,
                                                   showActions: false,
                                                   textDisabled: true))
                    .lineLimit(4)
                }
                Spacer()
            }
            .environment(\.isCompact, true)
        } else {
            Group {
                Text("@\(notification.accounts[0].acct)", bundle: .module)
                    .font(.scaledCallout)
                    .foregroundStyle(.secondary)
                
                if type == .follow {
                    EmojiTextApp(notification.accounts[0].note,
                                 emojis: notification.accounts[0].emojis)
                    .accessibilityLabel(notification.accounts[0].note.asRawText)
                    .lineLimit(3)
                    .font(.scaledCallout)
                    .emojiSize(Font.scaledCalloutFont.emojiSize)
                    .emojiBaselineOffset(Font.scaledCalloutFont.emojiBaselineOffset)
                    .foregroundStyle(.secondary)
                    .environment(\.openURL, OpenURLAction { url in
                        routerPath.handle(url: url)
                    })
                    .accessibilityAddTraits(.isButton)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if notification.accounts.count == 1 {
                    routerPath.navigate(to: .accountDetailWithAccount(account: notification.accounts[0]))
                } else {
                    routerPath.navigate(to: .accountsList(accounts: notification.accounts))
                }
            }
        }
    }
    
    // MARK: - Accessibility actions
    
    @ViewBuilder
    private var accessibilityUserActions: some View {
        ForEach(notification.accounts) { account in
            Button("@\(account.username)") {
                //        HapticManager.shared.fireHaptic(.notification(.success))
                routerPath.navigate(to: .accountDetail(id: account.id))
            }
        }
    }
}
