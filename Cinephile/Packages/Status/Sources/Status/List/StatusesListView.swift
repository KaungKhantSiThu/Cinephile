
import Environment
import Models
import Networking
import CinephileUI
import SwiftUI

@MainActor
public struct StatusesListView<Fetcher>: View where Fetcher: StatusesFetcher {
  @Environment(Theme.self) private var theme

  @State private var fetcher: Fetcher
  // Whether this status is on a remote local timeline (many actions are unavailable if so)
  private let isRemote: Bool
  private let routerPath: RouterPath
  private let client: Client

  public init(fetcher: Fetcher,
              client: Client,
              routerPath: RouterPath,
              isRemote: Bool = false
  )
  {
    _fetcher = .init(initialValue: fetcher)
    self.isRemote = isRemote
    self.client = client
    self.routerPath = routerPath
  }

  public var body: some View {
    switch fetcher.statusesState {
    case .loading:
      ForEach(Status.placeholders()) { status in
        StatusRowView(viewModel: .init(status: status, client: client, routerPath: routerPath))
          .redacted(reason: .placeholder)
//          .allowsHitTesting(false)
      }
    case .error:
      ErrorView(title: "status.error.title",
                message: "status.error.loading.message",
                buttonTitle: "action.retry")
      {
        Task {
            await fetcher.fetchNewestStatuses(pullToRefresh: false)
        }
      }
//      .listRowBackground(theme.primaryBackgroundColor)
      .listRowSeparator(.hidden)

    case let .display(statuses, nextPageState):
      ForEach(statuses, id: \.id) { status in
        StatusRowView(viewModel: StatusRowViewModel(status: status,
                                                    client: client,
                                                    routerPath: routerPath,
                                                    isRemote: isRemote))
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
//        .padding(12)
          .onAppear {
            fetcher.statusDidAppear(status: status)
          }
          .onDisappear {
            fetcher.statusDidDisappear(status: status)
          }
      }
      switch nextPageState {
      case .hasNextPage:
        loadingRow
          .onAppear {
            Task {
              await fetcher.fetchNextPage()
            }
          }
      case .loadingNextPage:
        loadingRow
      case .none:
        EmptyView()
      }
    }
  }

  private var loadingRow: some View {
    HStack {
      Spacer()
      ProgressView()
      Spacer()
    }
    .padding(.horizontal, .layoutPadding)
//    .listRowBackground(theme.primaryBackgroundColor)
  }
}
