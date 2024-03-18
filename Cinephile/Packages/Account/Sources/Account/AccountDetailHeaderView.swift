import SwiftUI
import Environment
import Models
import NukeUI
import CinephileUI
import OSLog

private let logger = Logger(subsystem: "AccountDetail", category: "HeaderViewModel")

@MainActor
struct AccountDetailHeaderView: View {
    
    @Environment(\.redactionReasons) private var reasons
    
    @Environment(RouterPath.self) private var routerPath
    @Environment(CurrentAccount.self) private var currentAccount
    @Environment(QuickLook.self) private var quickLook
    @Environment(\.isSupporter) private var isSupporter: Bool
    
    @Binding var isEditingAccount: Bool
    
    let viewModel: AccountDetailViewModel
    let account: Account
    let scrollViewProxy: ScrollViewProxy?
    
    init(isEditingAccount: Binding<Bool>, viewModel: AccountDetailViewModel, account: Account, scrollViewProxy: ScrollViewProxy?) {
        self._isEditingAccount = isEditingAccount
        self.viewModel = viewModel
        self.account = account
        self.scrollViewProxy = scrollViewProxy
    }
    
    var body: some View {
        VStack(spacing: 20) {
            accountAvatarView
            accountInfoView
                .padding(.leading, 15)
        }
    }
    
    private var accountAvatarView: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .topTrailing) {
                AvatarView(account.avatar, config: .account)
                if account.bot {
                    Image(systemName: "poweroutlet.type.b.fill")
                        .offset(x: 5, y: -5)
                }
                if account.locked {
                    Image(systemName: "lock.fill")
                        .offset(x: 5, y: -5)
                }
                if viewModel.relationship?.blocking == true {
                    Image(systemName: "slash.circle.fill")
                        .foregroundStyle(.red)
                        .offset(x: 5, y: -5)                }
                if viewModel.relationship?.muting == true {
                    Image(systemName: "speaker.slash.fill")
                        .offset(x: 5, y: -5)
                }
            }
            
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
        VStack {
            HStack {
                Button {
                    withAnimation {
                        scrollViewProxy?.scrollTo("status", anchor: .top)
                    }
                } label: {
                    Attribute(title: "Posts", count: account.statusesCount ?? 0)
                }
                .buttonStyle(.plain)
                
                Spacer()
                Button {
                    withAnimation {
                        routerPath.navigate(to: .following(id: account.id))                    }
                } label: {
                    Attribute(title: "Following", count: account.followingCount ?? 0)
                }
                .buttonStyle(.plain)
                Spacer()
                Button {
                    withAnimation {
                        routerPath.navigate(to: .followers(id: account.id))                    }
                } label: {
                    Attribute(title: "Following", count: account.followersCount ?? 0)
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            
            if viewModel.isCurrentUser {
                HStack {
                    Spacer()
                    
                    Button {
                        routerPath.navigate(to: .tagsList(tags: currentAccount.tags))
                    } label: {
                        Attribute(title: "Tags", count: currentAccount.tags.count)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button {
                        routerPath.navigate(to: .genresList(genres: currentAccount.genres))
                    } label: {
                        Attribute(title: "Genres", count: currentAccount.genres.count)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding()
                
                Button {
                  isEditingAccount = true
                } label: {
                    Text("Edit Profile")
                }
                .buttonStyle(.borderedProminent)
            }
            
            if let note = viewModel.relationship?.note, !note.isEmpty, !viewModel.isCurrentUser {
                makeNoteView(note)
            }
            
            
            if let relationship = viewModel.relationship, !viewModel.isCurrentUser {
                FollowButton(viewModel: .init(accountId: account.id,
                                              relationship: relationship,
                                              shouldDisplayNotify: true,
                                              relationshipUpdated: { relationship in
                    viewModel.relationship = relationship
                }))
            } else if !viewModel.isCurrentUser {
                ProgressView()
            }
            
        }
    }
    
    struct Attribute: View {
        let title: String
        let count: Int
        var body: some View {
            VStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(count, format: .number.notation(.compactName))
                    .font(.title)
                    .bold()
            }
        }
    }
    
    @ViewBuilder
    private func makeNoteView(_ note: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Note")
                .foregroundStyle(.secondary)
            Text(note)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.gray.opacity(0.35), lineWidth: 1)
                )
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
        isEditingAccount: .constant(false), viewModel: .init(account: .placeholder()),
        account: .placeholder(),
        scrollViewProxy: nil)
    .environment(RouterPath())
    .environment(CurrentAccount.shared)
    .environment(QuickLook.shared)
}
