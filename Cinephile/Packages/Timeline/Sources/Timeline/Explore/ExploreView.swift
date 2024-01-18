import Account
import CinephileUI
import Environment
import Models
import Networking
//import Shimmer
import Status
import SwiftUI

@MainActor
public struct ExploreView: View {
  @Environment(Theme.self) private var theme
  @Environment(Client.self) private var client
  @Environment(RouterPath.self) private var routerPath

  @State private var viewModel = ExploreViewModel()

  @Binding var scrollToTopSignal: Int

  public init(scrollToTopSignal: Binding<Int>) {
    _scrollToTopSignal = scrollToTopSignal
  }

    public var body: some View {
        ScrollViewReader { proxy in
            List {
                if !viewModel.searchQuery.isEmpty {
                  if let results = viewModel.results[viewModel.searchQuery] {
                    if !results.isEmpty, viewModel.isSearching {
                        ContentUnavailableView.search
//                      EmptyView(iconName: "magnifyingglass",
//                                title: "explore.search.empty.title",
//                                message: "explore.search.empty.message")
//                        .listRowBackground(theme.secondaryBackgroundColor)
                        .listRowSeparator(.hidden)
                    } else {
                      makeSearchResultsView(results: results)
                    }
                  } else {
                    HStack {
                      Spacer()
                      ProgressView()
                      Spacer()
                    }
//                    .listRowBackground(theme.secondaryBackgroundColor)
                    .listRowSeparator(.hidden)
                    .id(UUID())
                  }
                }
                
                suggestedAccountsSection
                trendingTagsSection
            }
          .environment(\.defaultMinListRowHeight, .scrollToViewHeight)
          .task {
            viewModel.client = client
            await viewModel.fetchTrending()
          }
          .refreshable {
              await viewModel.fetchTrending()
//            Task {
////              SoundEffectManager.shared.playSound(.pull)
////              HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.3))
//              
////              HapticManager.shared.fireHaptic(.dataRefresh(intensity: 0.7))
////              SoundEffectManager.shared.playSound(.refresh)
//            }
          }
          .listStyle(.plain)
          .scrollContentBackground(.hidden)
//          .background(theme.secondaryBackgroundColor)
          .navigationTitle(Text("explore.navigation-title", bundle: .module))
          .searchable(text: $viewModel.searchQuery,
                      isPresented: $viewModel.isSearchPresented,
                      placement: .navigationBarDrawer(displayMode: .always),
                      prompt: Text("explore.search.prompt", bundle: .module))
          .searchScopes($viewModel.searchScope) {
            ForEach(ExploreViewModel.SearchScope.allCases, id: \.self) { scope in
                Text(scope.localizedString)
            }
          }
          .task(id: viewModel.searchQuery) {
            do {
              try await Task.sleep(for: .milliseconds(150))
              await viewModel.search()
            } catch {}
          }
          .onChange(of: scrollToTopSignal) {
            if viewModel.scrollToTopVisible {
              viewModel.isSearchPresented.toggle()
            } else {
              withAnimation {
                proxy.scrollTo(ScrollToView.Constants.scrollToTop, anchor: .top)
              }
            }
          }
        }
      }
        
        
  private var quickAccessView: some View {
    ScrollView(.horizontal) {
      HStack {
          
        Button {
          routerPath.navigate(to: RouterDestination.tagsList(tags: viewModel.trendingTags))
        } label: {
            Text("explore.section.trending.tags", bundle: .module)
        }
        .buttonStyle(.bordered)
          
        Button {
          routerPath.navigate(to: RouterDestination.accountsList(accounts: viewModel.suggestedAccounts))
        } label: {
            Text("explore.section.suggested-users", bundle: .module)
        }
        .buttonStyle(.bordered)
          
        Button {
          routerPath.navigate(to: RouterDestination.trendingTimeline)
        } label: {
            Text("explore.section.trending.posts", bundle: .module)
        }
        .buttonStyle(.bordered)
      }
      .padding(.horizontal, 16)
    }
    .scrollIndicators(.never)
    .listRowInsets(EdgeInsets())
//    .listRowBackground(theme.secondaryBackgroundColor)
    .listRowSeparator(.hidden)
  }

var loadingView: some View {
    ForEach(Status.placeholders()) { status in
      StatusRowView(viewModel: .init(status: status, client: client, routerPath: routerPath))
        .padding(.vertical, 8)
        .redacted(reason: .placeholder)
//        .allowsHitTesting(false)
//        .listRowBackground(theme.primaryBackgroundColor)
    }
  }

  @ViewBuilder
  private func makeSearchResultsView(results: SearchResults) -> some View {
    if !results.accounts.isEmpty, viewModel.searchScope == .all || viewModel.searchScope == .people {
      Section {
        ForEach(results.accounts) { account in
          if let relationship = results.relationships.first(where: { $0.id == account.id }) {
            AccountsListRow(viewModel: .init(account: account, relationShip: relationship))
//              .listRowBackground(theme.primaryBackgroundColor)
          }
        }
      } header: {
          Text("explore.section.users", bundle: .module)
      }
    }
      
    if !results.hashtags.isEmpty, viewModel.searchScope == .all || viewModel.searchScope == .hashtags {
      Section {
        ForEach(results.hashtags) { tag in
          TagRowView(tag: tag)
//            .listRowBackground(theme.primaryBackgroundColor)
            .padding(.vertical, 4)
        }
      } header: {
          Text("explore.section.tags", bundle: .module)
      }
    }
    if !results.statuses.isEmpty, viewModel.searchScope == .all || viewModel.searchScope == .posts {
      Section {
        ForEach(results.statuses) { status in
          StatusRowView(viewModel: .init(status: status, client: client, routerPath: routerPath))
//            .listRowBackground(theme.primaryBackgroundColor)
            .padding(.vertical, 8)
        }
      } header: {
          Text("explore.section.posts", bundle: .module)
      }
    }
  }

  private var suggestedAccountsSection: some View {
    Section {
      ForEach(viewModel.suggestedAccounts
        .prefix(upTo: viewModel.suggestedAccounts.count > 3 ? 3 : viewModel.suggestedAccounts.count))
      { account in
        if let relationship = viewModel.suggestedAccountsRelationShips.first(where: { $0.id == account.id }) {
          AccountsListRow(viewModel: .init(account: account, relationShip: relationship))
//            .listRowBackground(theme.primaryBackgroundColor)
        }
      }
      NavigationLink(value: RouterDestination.accountsList(accounts: viewModel.suggestedAccounts)) {
        Text("see-more")
          .foregroundColor(theme.tintColor)
      }
//      .listRowBackground(theme.primaryBackgroundColor)
    } header: {
        Text("explore.section.suggested-users", bundle: .module)
    }
  }

  private var trendingTagsSection: some View {
    Section {
      ForEach(viewModel.trendingTags
        .prefix(upTo: viewModel.trendingTags.count > 5 ? 5 : viewModel.trendingTags.count))
      { tag in
        TagRowView(tag: tag)
//          .listRowBackground(theme.primaryBackgroundColor)
          .padding(.vertical, 4)
      }
      NavigationLink(value: RouterDestination.tagsList(tags: viewModel.trendingTags)) {
          Text("see-more")
          .foregroundColor(theme.tintColor)
      }
//      .listRowBackground(theme.primaryBackgroundColor)
    } header: {
        Text("explore.section.trending.tags", bundle: .module)
    }
  }

//  private var trendingPostsSection: some View {
//    Section("explore.section.trending.posts") {
//      ForEach(viewModel.trendingStatuses
//        .prefix(upTo: viewModel.trendingStatuses.count > 3 ? 3 : viewModel.trendingStatuses.count))
//      { status in
//        StatusRowView(viewModel: .init(status: status, client: client, routerPath: routerPath))
//          .listRowBackground(theme.primaryBackgroundColor)
//          .padding(.vertical, 8)
//      }
//
//      NavigationLink(value: RouterDestination.trendingTimeline) {
//        Text("see-more")
//          .foregroundColor(theme.tintColor)
//      }
//      .listRowBackground(theme.primaryBackgroundColor)
//    }
//  }

//  private var trendingLinksSection: some View {
//    Section("explore.section.trending.links") {
//      ForEach(viewModel.trendingLinks
//        .prefix(upTo: viewModel.trendingLinks.count > 3 ? 3 : viewModel.trendingLinks.count))
//      { card in
//        StatusRowCardView(card: card)
//          .listRowBackground(theme.primaryBackgroundColor)
//          .padding(.vertical, 8)
//      }
//
//      NavigationLink(value: RouterDestination.trendingLinks(cards: viewModel.trendingLinks)) {
//        Text("see-more")
//          .foregroundColor(theme.tintColor)
//      }
//      .listRowBackground(theme.primaryBackgroundColor)
//    }
//  }

  private var scrollToTopView: some View {
    ScrollToView()
      .frame(height: .scrollToViewHeight)
      .onAppear {
        viewModel.scrollToTopVisible = true
      }
      .onDisappear {
        viewModel.scrollToTopVisible = false
      }
  }
}
