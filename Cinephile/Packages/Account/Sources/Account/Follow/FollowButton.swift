import Models
import Networking
import SwiftUI
import OSLog
import ButtonKit

private let logger = Logger(subsystem: "Account", category: "FollowButtonViewModel")

@MainActor
@Observable public class FollowButtonViewModel {
  var client: Client?

  public let accountId: String
  public let shouldDisplayNotify: Bool
  public let relationshipUpdated: (Relationship) -> Void
  public private(set) var relationship: Relationship

  public init(accountId: String,
              relationship: Relationship,
              shouldDisplayNotify: Bool,
              relationshipUpdated: @escaping ((Relationship) -> Void))
  {
    self.accountId = accountId
    self.relationship = relationship
    self.shouldDisplayNotify = shouldDisplayNotify
    self.relationshipUpdated = relationshipUpdated
  }

  func follow() async throws {
    guard let client else { return }
    do {
      relationship = try await client.post(endpoint: Accounts.follow(id: accountId, notify: false, reblogs: true))
      relationshipUpdated(relationship)
    } catch {
        logger.error("Error while following: \(error.localizedDescription)")
        throw error
    }
  }

  func unfollow() async throws {
    guard let client else { return }
    do {
      relationship = try await client.post(endpoint: Accounts.unfollow(id: accountId))
      relationshipUpdated(relationship)
    } catch {
        logger.error("Error while unfollowing: \(error.localizedDescription)")
        throw error
    }
  }

  func toggleNotify() async throws {
    guard let client else { return }
    do {
      relationship = try await client.post(endpoint: Accounts.follow(id: accountId,
                                                                     notify: !relationship.notifying,
                                                                     reblogs: relationship.showingReblogs))
      relationshipUpdated(relationship)
    } catch {
        logger.error("Error while following: \(error.localizedDescription)")
        throw error
    }
  }

  func toggleReboosts() async throws {
    guard let client else { return }
    do {
      relationship = try await client.post(endpoint: Accounts.follow(id: accountId,
                                                                     notify: relationship.notifying,
                                                                     reblogs: !relationship.showingReblogs))
      relationshipUpdated(relationship)
    } catch {
        logger.error("Error while switching reboosts: \(error.localizedDescription)")
        throw error
    }
  }
}

public struct FollowButton: View {
  @Environment(Client.self) private var client
  @State private var viewModel: FollowButtonViewModel

  public init(viewModel: FollowButtonViewModel) {
    _viewModel = .init(initialValue: viewModel)
  }

  public var body: some View {
      HStack(alignment: .center) {
        AsyncButton {
          if viewModel.relationship.following {
            try await viewModel.unfollow()
          } else {
            try await viewModel.follow()
          }
        } label: {
          if viewModel.relationship.requested == true {
            Text("requested")
          } else {
            Text(viewModel.relationship.following ? "following" : "follow")
          }
        }
          
        if viewModel.relationship.following,
           viewModel.shouldDisplayNotify
        {
            AsyncButton {
              try await viewModel.toggleNotify()
            } label: {
              Image(systemName: viewModel.relationship.notifying ? "bell.fill" : "bell")
            }
          .asyncButtonStyle(.none)
          .disabledWhenLoading()
        }
      }
      .buttonStyle(.bordered)
      .onAppear {
        viewModel.client = client
      }
//    VStack(alignment: .trailing) {
//      Button {
//        Task {
//          if viewModel.relationship.following {
//            await viewModel.unfollow()
//          } else {
//            await viewModel.follow()
//          }
//        }
//      } label: {
//        if viewModel.relationship.requested == true {
//            Text("account.follow.requested", bundle: .module)
//        } else {
//            Text(viewModel.relationship.following ? "account.follow.following" : "account.follow.follow", bundle: .module)
////            .accessibilityLabel("account.follow.following")
////            .accessibilityValue(viewModel.relationship.following ? "accessibility.general.toggle.on" : "accessibility.general.toggle.off")
//        }
//      }
//      if viewModel.relationship.following,
//         viewModel.shouldDisplayNotify
//      {
//        HStack {
//          Button {
//            Task {
//              await viewModel.toggleNotify()
//            }
//          } label: {
//            Image(systemName: viewModel.relationship.notifying ? "bell.fill" : "bell")
//          }
////          .accessibilityLabel("accessibility.tabs.profile.user-notifications.label")
////          .accessibilityValue(viewModel.relationship.notifying ? "accessibility.general.toggle.on" : "accessibility.general.toggle.off")
//          Button {
//            Task {
//              await viewModel.toggleReboosts()
//            }
//          } label: {
//            Image(viewModel.relationship.showingReblogs ? "arrowshape.turn.up.backward.circle.fill" : "arrowshape.turn.up.backward.circle")
//          }
////          .accessibilityLabel("accessibility.tabs.profile.user-reblogs.label")
////          .accessibilityValue(viewModel.relationship.showingReblogs ? "accessibility.general.toggle.on" : "accessibility.general.toggle.off")
//        }
//      }
//    }
//    .buttonStyle(.bordered)
//    .disabled(viewModel.isUpdating)
//    .onAppear {
//      viewModel.client = client
//    }
  }
}
