import CinephileUI
import Environment
import Models
import SwiftUI

@MainActor
struct StatusRowDetailView: View {
  @Environment(\.openURL) private var openURL

  @Environment(StatusDataController.self) private var statusDataController

  var viewModel: StatusRowViewModel

  var body: some View {
    Group {
      Divider()
        StatusRowHistory(status: viewModel.status)

      if let editedAt = viewModel.status.editedAt {
        Divider()
        HStack {
          Text("status.summary.edited-time", bundle: .module)
            StatusRowHistory(editedAt: editedAt.asDate)
          Spacer()
        }
        .onTapGesture {
          viewModel.routerPath.presentedSheet = .statusEditHistory(status: viewModel.status.id)
        }
//        .underline()
//        .font(.scaledCaption)
//        .foregroundStyle(.secondary)
      }

      if viewModel.actionsAccountsFetched, statusDataController.favoritesCount > 0 {
        Divider()
        Button {
          viewModel.routerPath.navigate(to: .favoritedBy(id: viewModel.status.id))
        } label: {
          HStack {
            Text("status.summary.n-favorites \(statusDataController.favoritesCount)", bundle: .module)
              .font(.scaledCallout)
            Spacer()
            makeAccountsScrollView(accounts: viewModel.favoriters)
            Image(systemName: "chevron.right")
          }
          .frame(height: 20)
        }
        .buttonStyle(.borderless)
        .transition(.move(edge: .leading))
      }

      if viewModel.actionsAccountsFetched, statusDataController.reblogsCount > 0 {
        Divider()
        Button {
          viewModel.routerPath.navigate(to: .rebloggedBy(id: viewModel.status.id))
        } label: {
          HStack {
            Text("status.summary.n-boosts \(statusDataController.reblogsCount)", bundle: .module)
              .font(.scaledCallout)
            Spacer()
            makeAccountsScrollView(accounts: viewModel.rebloggers)
            Image(systemName: "chevron.right")
          }
          .frame(height: 20)
        }
        .buttonStyle(.borderless)
        .transition(.move(edge: .leading))
      }
    }
    .task {
      await viewModel.fetchActionsAccounts()
    }
  }

  private func makeAccountsScrollView(accounts: [Account]) -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 0) {
        ForEach(accounts) { account in
          AvatarView(account.avatar, config: .list)
            .padding(.leading, -4)
        }
        .transition(.opacity)
      }
      .padding(.leading, .layoutPadding)
    }
  }
}
