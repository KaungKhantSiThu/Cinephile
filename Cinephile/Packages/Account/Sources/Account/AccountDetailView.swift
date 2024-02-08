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
import Status

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
            List {
                HStack {
                    Spacer()
                    headerView(proxy: proxy)
                        .applyAccountDetailsRowStyle(theme: theme)
                    //                            .padding(.bottom, -20)
                        .id(ScrollToView.Constants.scrollToTop)
                    Spacer()
                }
                
                familiarFollowers
                    .applyAccountDetailsRowStyle(theme: theme)
                
//                featuredTagsView
//                    .applyAccountDetailsRowStyle(theme: theme)
                
                Picker("", selection: $viewModel.selectedTab) {
                    ForEach(isCurrentUser ? AccountDetailViewModel.Tab.currentAccountTabs : AccountDetailViewModel.Tab.accountTabs,
                            id: \.self)
                    { tab in
                        Image(systemName: tab.iconName)
                            .tag(tab)
                            .accessibilityLabel(tab.accessibilityLabel)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.layoutPadding)
                .id("status")
                
                
                
                if viewModel.selectedTab == .statuses {
                  pinnedPostsView
                }
                
                StatusesListView(fetcher: viewModel,
                                 client: client,
                                 routerPath: routerPath)
                
            }
            .environment(\.defaultMinListRowHeight, 1)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            //.background(theme.primaryBackgroundColor)
            .onChange(of: scrollToTopSignal) {
                withAnimation {
                    proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
                }
            }
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
                    group.addTask {
                        if await viewModel.statuses.isEmpty {
                            await viewModel.fetchNewestStatuses(pullToRefresh: false)
                        }
                    }
                    if !viewModel.isCurrentUser {
                        group.addTask { await viewModel.fetchFamilliarFollowers() }
                    }
                }
            }
        }
        .refreshable {
            await viewModel.fetchAccount()
            await viewModel.fetchNewestStatuses(pullToRefresh: true)
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
        //        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
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
    
    @ViewBuilder
    private var pinnedPostsView: some View {
        if !viewModel.pinned.isEmpty {
            Label(
                title: { Text("account.post.pinned", bundle: .module) },
                icon: { Image(systemName: "pin.fill") }
            )
            .accessibilityAddTraits(.isHeader)
            .font(.scaledFootnote)
            .foregroundStyle(.secondary)
            .fontWeight(.semibold)
            .listRowInsets(.init(top: 0,
                                 leading: 12,
                                 bottom: 0,
                                 trailing: .layoutPadding))
            .listRowSeparator(.hidden)
            //          .listRowBackground(theme.primaryBackgroundColor)
            ForEach(viewModel.pinned) { status in
                StatusRowView(viewModel: .init(status: status, client: client, routerPath: routerPath))
                    .padding(12)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            Rectangle()
                .fill(.secondary)
                .frame(height: 12)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .accessibilityHidden(true)
        }
    }
    
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
//        ToolbarItem(placement: .topBarLeading) {
//            Image(systemName: client.isAuth ? "checkmark.circle.fill" : "multiply.circle.fill")
//                .foregroundStyle(client.isAuth ? .green : .red)
//        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                routerPath.presentedSheet = .settings
            } label: {
                Label(
                    title: { Text("account.settings", bundle: .module) },
                    icon: { Image(systemName: "gear") }
                )
            }
        }
        
    }
    
//    @ViewBuilder
//    private var featuredTagsView: some View {
//        if !viewModel.featuredTags.isEmpty {
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 4) {
//                    if !viewModel.featuredTags.isEmpty {
//                        ForEach(viewModel.featuredTags) { tag in
//                            Button {
//                                routerPath.navigate(to: .hashTag(tag: tag.name, accountId: viewModel.id))
//                            } label: {
//                                VStack(alignment: .leading, spacing: 0) {
//                                    Text("#\(tag.name)")
//                                        .font(.scaledCallout)
//                                    Text("account.detail.featured-tags-n-posts \(tag.statusesCountInt)", bundle: .module)
//                                        .font(.caption2)
//                                }
//                            }
//                            .buttonStyle(.bordered)
//                        }
//                    }
//                }
//                .padding(.leading, .layoutPadding)
//            }
//        }
//    }
    
    @ViewBuilder
    private var familiarFollowers: some View {
        if !viewModel.familiarFollowers.isEmpty {
            VStack(alignment: .leading, spacing: 2) {
                Text("account.detail.familiar-followers", bundle: .module)
                    .font(.scaledHeadline)
                    .padding(.leading, .layoutPadding)
                    .accessibilityAddTraits(.isHeader)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(viewModel.familiarFollowers) { account in
                            Button {
                                routerPath.navigate(to: .accountDetailWithAccount(account: account))
                            } label: {
                                AvatarView(account.avatar, config: .badge)
                                    .padding(.leading, -4)
                                    .accessibilityLabel(account.safeDisplayName)
                            }
                            .accessibilityAddTraits(.isImage)
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.leading, .layoutPadding + 8)
                }
            }
            .padding(.top, 2)
            .padding(.bottom, 12)
        }
    }
    
}

extension View {
    func applyAccountDetailsRowStyle(theme: Theme) -> some View {
        listRowInsets(.init())
            .listRowSeparator(.hidden)
            .listRowBackground(theme.primaryBackgroundColor)
    }
}
