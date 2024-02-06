import SwiftUI
import Environment
import Models
import NukeUI
import CinephileUI

@MainActor
struct AccountDetailHeaderView: View {
    
    @Environment(\.redactionReasons) private var reasons
    
    @Environment(RouterPath.self) private var routerPath
    @Environment(CurrentAccount.self) private var currentAccount
    @Environment(QuickLook.self) private var quickLook
    @Environment(\.isSupporter) private var isSupporter: Bool
    
    let viewModel: AccountDetailViewModel
    let account: Account
    let scrollViewProxy: ScrollViewProxy?
    
    var body: some View {
        VStack(spacing: 20) {
            accountAvatarView
            accountInfoView
                .padding(.leading, 15)
        }
        //        VStack(alignment: .leading) {
        //            accountAvatarView
        //            VStack(alignment: .leading) {
        //                Text(account.safeDisplayName)
        //                    .font(.title)
        //                    .foregroundStyle(.primary)
        //                Text("@\(account.acct)")
        //                    .font(.subheadline)
        //                    .foregroundStyle(.secondary)
        //            }
        ////                .padding(.top, 10)
        //        }
    }
    
    private var accountAvatarView: some View {
        HStack(alignment: .top) {
            AvatarView(account.avatar, config: .account)
//                .frame(width: 20, height: 20)
                .padding(.trailing, 10)
//            if viewModel.isCurrentUser, isSupporter {
//                Image(systemName: "checkmark.seal.fill")
//                    .resizable()
//                    .frame(width: 25, height: 25)
//            }
            
            VStack(alignment: .leading) {
                Text(account.safeDisplayName)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
                Text("@\(account.acct)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .onTapGesture {
            guard account.haveAvatar else {
                return
            }
            let attachement = MediaAttachment.imageWith(url: account.avatar)
#if targetEnvironment(macCatalyst)
            openWindow(value: WindowDestinationMedia.mediaViewer(attachments: [attachement],
                                                                 selectedAttachment: attachement))
#else
            quickLook.prepareFor(selectedMediaAttachment: attachement, mediaAttachments: [attachement])
#endif
        }
    }
    
    private var accountInfoView: some View {
        HStack(spacing: 30) {
            Button {
                withAnimation {
                    scrollViewProxy?.scrollTo("status", anchor: .top)
                }
            } label: {
                makeCustomInfoLabel(title: "account.posts", count: account.statusesCount ?? 0)
            }
            .accessibilityHint("accessibility.tabs.profile.post-count.hint")
            .buttonStyle(.borderless)
            
            Button {
                routerPath.navigate(to: .following(id: account.id))
            } label: {
                makeCustomInfoLabel(title: "account.following", count: account.followingCount ?? 0)
            }
            .accessibilityHint("accessibility.tabs.profile.following-count.hint")
            .buttonStyle(.borderless)
            
            
            Button {
                routerPath.navigate(to: .followers(id: account.id))
            } label: {
                makeCustomInfoLabel(
                    title: "account.followers",
                    count: account.followersCount ?? 0,
                    needsBadge: currentAccount.account?.id == account.id && !currentAccount.followRequests.isEmpty
                )
            }
            .accessibilityHint("accessibility.tabs.profile.follower-count.hint")
            .buttonStyle(.borderless)
        }
    }
    
    private func makeCustomInfoLabel(title: LocalizedStringKey, count: Int, needsBadge: Bool = false) -> some View {
        VStack {
            Text(title, bundle: .module)
                .font(.scaledCaption)
                .foregroundStyle(.secondary)
            
            Text(count, format: .number.notation(.compactName))
                .font(.title)
                .bold()
                .foregroundColor(.primary)
                .overlay(alignment: .trailing) {
                    if needsBadge {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 9, height: 9)
                            .offset(x: 12)
                    }
                }
            
        }
//        .accessibilityElement(children: .ignore)
//        .accessibilityLabel(title)
//        .accessibilityValue("\(count)")
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    AccountDetailHeaderView(
        viewModel: .init(account: .placeholder()),
        account: .placeholder(),
        scrollViewProxy: nil)
    .environment(RouterPath())
    .environment(CurrentAccount.shared)
    .environment(QuickLook.shared)
}
