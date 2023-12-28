//
//  AccountDetailView.swift
//
//
//  Created by Kaung Khant Si Thu on 15/12/2023.
//

import SwiftUI
import Environment
import Networking
import Models
import CinephileUI

@MainActor
public struct AccountDetailView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.redactionReasons) private var reasons
    
    @Environment(CurrentAccount.self) private var currentAccount
    @Environment(CurrentInstance.self) private var currentInstance
    @Environment(UserPreferences.self) private var preferences
    @Environment(Theme.self) private var theme

    @Environment(Client.self) private var client
    @Environment(RouterPath.self) private var routerPath
    
    @State private var viewModel: AccountDetailViewModel
    @State private var isCurrentUser: Bool = false
    
    @State private var isEditingAccount: Bool = false
    
    @Binding var scrollToTopSignal: Int
    
    
    /// When coming from a URL like a mention tap in a status.
    public init(id: Account.ID, scrollToTopSignal: Binding<Int>) {
        _viewModel = .init(initialValue: .init(id: id))
        _scrollToTopSignal = scrollToTopSignal
        
    }
    
    /// When the account is already fetched by the parent caller.
    public init(account: Account, scrollToTopSignal: Binding<Int>) {
        _viewModel = .init(initialValue: .init(account: account))
        _scrollToTopSignal = scrollToTopSignal
        
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                headerView(proxy: proxy)
                    
            }
//            .listStyle(.plain)
            //            .onChange(of: scrollToTopSignal) {
            //              withAnimation {
            //                proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
            //              }
            //            }
        }
        .onAppear {
            guard reasons != .placeholder else { return }
            self.isCurrentUser = currentAccount.account?.id == viewModel.id
            self.viewModel.isCurrentUser = isCurrentUser
            self.viewModel.client = client
            // Avoid capturing non-Sendable `self` just to access the view model.
            let viewModel = viewModel
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask { await viewModel.fetchAccount() }
                    //                group.addTask {
                    //                  if await viewModel.statuses.isEmpty {
                    //                    await viewModel.fetchNewestStatuses()
                    //                  }
                    //                }
                    if !viewModel.isCurrentUser {
                        group.addTask { await viewModel.fetchFamilliarFollowers() }
                    }
                }
            }
        }
        .refreshable {
            await viewModel.fetchAccount()
//            await viewModel.fetchNewestStatuses()
        }
        .onChange(of: isEditingAccount) { _, newValue in
          if !newValue {
            Task {
              await viewModel.fetchAccount()
              await preferences.refreshServerPreferences()
            }
          }
        }
        .sheet(isPresented: $isEditingAccount, content: {
          EditAccountView()
        })
        .toolbar {
            toolbarContent
        }
    }
    
    @ViewBuilder
    private func headerView(proxy: ScrollViewProxy?) -> some View {
        switch viewModel.state {
        case .loading:
            AccountDetailHeaderView(viewModel: viewModel, account: .placeholder(), scrollViewProxy: proxy)
                .redacted(reason: .placeholder)
        case .loaded(let account):
            AccountDetailHeaderView(
                viewModel: viewModel,
                account: account,
                scrollViewProxy: proxy)
        case .failed(let error):
            Text(error.localizedDescription)
        }
    }
    
//    @ViewBuilder
//    private var pinnedPostsView: some View {
//      if !viewModel.pinned.isEmpty {
//        Label("account.post.pinned", systemImage: "pin.fill")
//          .accessibilityAddTraits(.isHeader)
//          .font(.scaledFootnote)
//          .foregroundStyle(.secondary)
//          .fontWeight(.semibold)
//          .listRowInsets(.init(top: 0,
//                               leading: 12,
//                               bottom: 0,
//                               trailing: .layoutPadding))
//          .listRowSeparator(.hidden)
//          .listRowBackground(theme.primaryBackgroundColor)
//        ForEach(viewModel.pinned) { status in
////          StatusRowView(viewModel: .init(status: status, client: client, routerPath: routerPath))
//        }
//        Rectangle()
//          .fill(theme.secondaryBackgroundColor)
//          .frame(height: 12)
//          .listRowInsets(.init())
//          .listRowSeparator(.hidden)
//          .accessibilityHidden(true)
//      }
//    }
    
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Image(systemName: client.isAuth ? "checkmark.circle.fill" : "multiply.circle.fill")
                .foregroundStyle(client.isAuth ? .green : .red)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                routerPath.presentedSheet = .settings
            } label: {
                Label("Settings", systemImage: "gear")
            }
            
        }
        
        ToolbarItemGroup(placement: .topBarTrailing) {
            if isCurrentUser {
                Button {
                  isEditingAccount = true
                } label: {
                  Label("Edit Account Info", systemImage: "pencil")
                }
            }
        }
        
    }
    
}
