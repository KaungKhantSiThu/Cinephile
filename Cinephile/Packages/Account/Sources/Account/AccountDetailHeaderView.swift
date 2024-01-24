//
//  AccountDetailHeaderView.swift
//
//
//  Created by Kaung Khant Si Thu on 15/12/2023.
//

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
        VStack {
            accountAvatarView
            VStack(alignment: .leading) {
                Text(account.safeDisplayName)
                    .font(.title)
                    .foregroundStyle(.primary)
                Text("@\(account.acct)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
                .padding(.top, 20)
            accountInfoView
        }
    }
    
    private var accountAvatarView: some View {
        ZStack(alignment: .topTrailing) {
            AvatarView(account.avatar, config: .account)
            if viewModel.isCurrentUser, isSupporter {
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
        }
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
        HStack {
          Button {
            withAnimation {
              scrollViewProxy?.scrollTo("status", anchor: .top)
            }
          } label: {
            makeCustomInfoLabel(title: "account.posts", count: account.statusesCount ?? 0)
          }
          .accessibilityHint("accessibility.tabs.profile.post-count.hint")
          .buttonStyle(.borderless)
          .padding()

          Button {
            routerPath.navigate(to: .following(id: account.id))
          } label: {
            makeCustomInfoLabel(title: "account.following", count: account.followingCount ?? 0)
          }
          .accessibilityHint("accessibility.tabs.profile.following-count.hint")
          .buttonStyle(.borderless)
          .padding()


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
          .padding()

        }.offset(y: 20)
    }
    
    private func makeCustomInfoLabel(title: LocalizedStringKey, count: Int, needsBadge: Bool = false) -> some View {
      VStack {
        Text(count, format: .number.notation(.compactName))
          .font(.scaledHeadline)
          .foregroundColor(.primary)
          .overlay(alignment: .trailing) {
            if needsBadge {
              Circle()
                .fill(Color.red)
                .frame(width: 9, height: 9)
                .offset(x: 12)
            }
          }
          Text(title, bundle: .module)
          .font(.scaledFootnote)
          .foregroundStyle(.secondary)
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(title)
      .accessibilityValue("\(count)")
    }
}

#Preview {
    AccountDetailHeaderView(
        viewModel: .init(account: .placeholder()),
        account: .placeholder(),
        scrollViewProxy: nil)
    .environment(RouterPath())
    .environment(CurrentAccount.shared)
    .environment(QuickLook.shared)
}
