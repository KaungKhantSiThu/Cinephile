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
//    @Environment(\.isSupporter) private var isSupporter: Bool

    let viewModel: AccountDetailViewModel
    let account: Account
    let scrollViewProxy: ScrollViewProxy?
    
    var body: some View {
        VStack {
//            LazyImage(url: account.avatar) { state in
//                if let image = state.image {
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(height: 100)
//                        .clipShape(
//                            Circle()
//                        )
//                } else if state.isLoading {
//                    ProgressView()
//                        .frame(height: 100)
//                }
//
//            }
            accountAvatarView
            
            VStack(alignment: .leading) {
                Text(account.safeDisplayName)
                    .font(.title)
                    .foregroundStyle(.primary)
                Text("@\(account.acct)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
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
            .padding(.top, 20)
        }
        
    }
    
    private var accountAvatarView: some View {
        ZStack(alignment: .topTrailing) {
            AvatarView(account.avatar, config: .account)
            //          if viewModel.isCurrentUser, isSupporter {
            if viewModel.isCurrentUser {
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
        }
        .onTapGesture {
            guard account.haveAvatar else {
                return
            }
            //          let attachement = MediaAttachment.imageWith(url: account.avatar)
            //  #if targetEnvironment(macCatalyst)
            //          openWindow(value: WindowDestinationMedia.mediaViewer(attachments: [attachement],
            //                                                               selectedAttachment: attachement))
            //  #else
            //          quickLook.prepareFor(selectedMediaAttachment: attachement, mediaAttachments: [attachement])
            //  #endif
        }
    }
}

#Preview {
    AccountDetailHeaderView(
        viewModel: .init(account: .placeholder()),
        account: .placeholder(),
        scrollViewProxy: nil)
}
