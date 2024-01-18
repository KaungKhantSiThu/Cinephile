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
        HStack(spacing: 20) {
            VStack {
                Text("\(account.statusesCount ?? 999)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Posts")
                    .font(.caption)
            }

            VStack {
                Text("\(account.followingCount ?? 999)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Following")
                    .font(.caption)
            }

            VStack {
                Text("\(account.followersCount ?? 999)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Followers")
                    .font(.caption)
            }
        }
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
