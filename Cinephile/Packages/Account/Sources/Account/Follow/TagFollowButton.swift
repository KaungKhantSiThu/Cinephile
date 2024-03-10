//import Models
//import Networking
//import SwiftUI
//import OSLog
//import ButtonKit
//import Environment
//
//private let logger = Logger(subsystem: "Account", category: "FollowButtonViewModel")
//
//@MainActor
//@Observable public class TagFollowButtonViewModel {
//    var client: Client?
//    @Environment(CurrentAccount.self) private var account
//    public let accountId: String
//    public let shouldDisplayNotify: Bool
//    public let relationshipUpdated: (Relationship) -> Void
//    public private(set) var relationship: Relationship
//    
//    public private(set) var tag: Tag
//    public init(accountId: String,
//                relationship: Relationship,
//                shouldDisplayNotify: Bool,
//                tag: Tag,
//                relationshipUpdated: @escaping ((Relationship) -> Void))
//    {
//        self.accountId = accountId
//        self.relationship = relationship
//        self.shouldDisplayNotify = shouldDisplayNotify
//        self.tag = tag
//        self.relationshipUpdated = relationshipUpdated
//    }
//    
//    func follow() async throws {
//        guard let client else { return }
//        do {
//            relationship = try await client.post(endpoint: Accounts.follow(id: accountId, notify: false, reblogs: true))
//            tag = try await account.followTag(id: tag.name)
//            relationshipUpdated(relationship)
//        } catch {
//            logger.error("Error while following: \(error.localizedDescription)")
//            throw error
//        }
//    }
//    
//    func unfollow() async throws {
//        guard let client else { return }
//        do {
//            relationship = try await client.post(endpoint: Accounts.unfollow(id: accountId))
//            relationshipUpdated(relationship)
//        } catch {
//            logger.error("Error while unfollowing: \(error.localizedDescription)")
//            throw error
//        }
//    }
//    
//    func toggleNotify() async throws {
//        guard let client else { return }
//        do {
//            relationship = try await client.post(endpoint: Accounts.follow(id: accountId,
//                                                                           notify: !relationship.notifying,
//                                                                           reblogs: relationship.showingReblogs))
//            relationshipUpdated(relationship)
//        } catch {
//            logger.error("Error while following: \(error.localizedDescription)")
//            throw error
//        }
//    }
//    
//    func toggleReboosts() async throws {
//        guard let client else { return }
//        do {
//            relationship = try await client.post(endpoint: Accounts.follow(id: accountId,
//                                                                           notify: relationship.notifying,
//                                                                           reblogs: !relationship.showingReblogs))
//            relationshipUpdated(relationship)
//        } catch {
//            logger.error("Error while switching reboosts: \(error.localizedDescription)")
//            throw error
//        }
//    }
//}
//
//public struct TagFollowButton: View {
//    @Environment(Client.self) private var client
//    @State private var viewModel: TagFollowButtonViewModel
//    
//    public init(viewModel: TagFollowButtonViewModel) {
//        _viewModel = .init(initialValue: viewModel)
//    }
//    
//    public var body: some View {
//        AsyncButton {
//            if viewModel.relationship.following {
//                try await viewModel.unfollow()
//            } else {
//                try await viewModel.follow()
//            }
//        } label: {
//            if viewModel.relationship.requested == true {
//                Text("requested")
//            } else {
//                Text(viewModel.relationship.following ? "following" : "follow")
//            }
//        }
//        .buttonStyle(.bordered)
//        .onAppear {
//            viewModel.client = client
//        }
//    }
//}
//
