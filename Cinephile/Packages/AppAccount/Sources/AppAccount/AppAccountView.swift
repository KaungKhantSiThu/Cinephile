//
//  AppAccountView.swift
//
//
//  Created by Kaung Khant Si Thu on 16/12/2023.
//

import SwiftUI
import Environment
import CinephileUI

@MainActor
public struct AppAccountView: View {
    
    @Environment(RouterPath.self) private var routerPath
    @Environment(AppAccountsManager.self) private var appAccountsManager
    
    @State var viewModel: AppAccountViewModel

    public init(viewModel: AppAccountViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
          if viewModel.isCompact {
            compactView
          } else {
            fullView
          }
        }
        .onAppear {
          Task {
            await viewModel.fetchAccount()
          }
        }
    }
    
    @ViewBuilder
    private var compactView: some View {
      HStack {
        if let account = viewModel.account {
          AvatarView(account.avatar)
        } else {
          ProgressView()
        }
      }
    }

    private var fullView: some View {
      Button {
        if appAccountsManager.currentAccount.id == viewModel.appAccount.id, let account = viewModel.account {
          routerPath.navigate(to: .accountSettingsWithAccount(account: account, appAccount: viewModel.appAccount))
        } else {
          var transation = Transaction()
          transation.disablesAnimations = true
          withTransaction(transation) {
              appAccountsManager.currentAccount = viewModel.appAccount
          }
        }
      } label: {
        HStack {
          if let account = viewModel.account {
            ZStack(alignment: .topTrailing) {
              AvatarView(account.avatar)
              if viewModel.appAccount.id == appAccountsManager.currentAccount.id {
                Image(systemName: "checkmark.circle.fill")
                  .foregroundStyle(.white, .green)
                  .offset(x: 5, y: -5)
              } 
//                else if viewModel.showBadge,
//                        let token = viewModel.appAccount.oauthToken,
//                        let notificationsCount = preferences.notificationsCount[token],
//                        notificationsCount > 0
//              {
//                ZStack {
//                  Circle()
//                    .fill(.red)
//                  Text(notificationsCount > 99 ? "99+" : String(notificationsCount))
//                    .foregroundColor(.white)
//                    .font(.system(size: 9))
//                }
//                .frame(width: 20, height: 20)
//                .offset(x: 5, y: -5)
//              }
            }
          } else {
            ProgressView()
            Text(viewModel.appAccount.accountName ?? viewModel.acct)
//              .font(.scaledSubheadline)
              .foregroundStyle(Color.secondary)
              .padding(.leading, 6)
          }
          VStack(alignment: .leading) {
            if let account = viewModel.account {
//              EmojiTextApp(.init(stringValue: account.safeDisplayName), emojis: account.emojis)
//                .foregroundColor(theme.labelColor)
              Text("\(account.username)@\(viewModel.appAccount.server)")
//                .font(.scaledSubheadline)
//                .emojiSize(Font.scaledSubheadlineFont.emojiSize)
//                .emojiBaselineOffset(Font.scaledSubheadlineFont.emojiBaselineOffset)
                .foregroundStyle(Color.secondary)
            }
          }
          if viewModel.isInNavigation {
            Spacer()
            Image(systemName: "chevron.right")
              .foregroundStyle(.secondary)
          }
        }
      }
    }
}

//#Preview {
//    AppAccountView()
//}
