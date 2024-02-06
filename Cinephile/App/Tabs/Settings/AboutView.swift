import Account
import Models
import Network
import SwiftUI
import CinephileUI
import EmojiText
import Environment
import Networking
import Status

@MainActor
struct AboutView: View {
  @Environment(RouterPath.self) private var routerPath
  @Environment(Theme.self) private var theme
  @Environment(Client.self) private var client
    
  @State private var dimillianAccount: AccountsListRowViewModel?
  @State private var iceCubesAccount: AccountsListRowViewModel?

  let versionNumber: String

  init() {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      versionNumber = version + " "
    } else {
      versionNumber = ""
    }
  }

  var body: some View {
    List {
      Section {
        Link(destination: URL(string: "https://github.com/Dimillian/IceCubesApp/blob/main/PRIVACY.MD")!) {
          Label("settings.support.privacy-policy", systemImage: "lock")
        }

        Link(destination: URL(string: "https://github.com/Dimillian/IceCubesApp/blob/main/TERMS.MD")!) {
          Label("settings.support.terms-of-use", systemImage: "checkmark.shield")
        }
      } footer: {
        Text("\(versionNumber)©2023 Cinephile")
      }
//      #if !os(visionOS)
//      .listRowBackground(theme.primaryBackgroundColor)
//      #endif

      Section {
        Text("""
        • [EmojiText](https://github.com/divadretlaw/EmojiText)

        • [HTML2Markdown](https://gitlab.com/mflint/HTML2Markdown)

        • [KeychainSwift](https://github.com/evgenyneu/keychain-swift)

        • [LRUCache](https://github.com/nicklockwood/LRUCache)

        • [Bodega](https://github.com/mergesort/Bodega)

        • [Nuke](https://github.com/kean/Nuke)

        • [SwiftSoup](https://github.com/scinfu/SwiftSoup.git)

        • [SwiftUI-Introspect](https://github.com/siteline/SwiftUI-Introspect)

        """)
        .multilineTextAlignment(.leading)
        .font(.scaledSubheadline)
        .foregroundStyle(.secondary)
      } header: {
        Text("settings.about.built-with")
          .textCase(nil)
      }
//      #if !os(visionOS)
//      .listRowBackground(theme.primaryBackgroundColor)
//      #endif
    }
    .listStyle(.insetGrouped)
    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
    #if !os(visionOS)
    .scrollContentBackground(.hidden)
//    .background(theme.primaryBackgroundColor)
    #endif
    .navigationTitle(Text("Acknoledgements"))
    .navigationBarTitleDisplayMode(.large)
    .environment(\.openURL, OpenURLAction { url in
      routerPath.handle(url: url)
    })
  }

//  @ViewBuilder
//  private var followAccountsSection: some View {
//    if let iceCubesAccount, let dimillianAccount {
//      Section {
//        AccountsListRow(viewModel: iceCubesAccount)
//        AccountsListRow(viewModel: dimillianAccount)
//      }
//      #if !os(visionOS)
//      .listRowBackground(theme.primaryBackgroundColor)
//      #endif
//    } else {
//      Section {
//        ProgressView()
//      }
//      #if !os(visionOS)
//      .listRowBackground(theme.primaryBackgroundColor)
//      #endif
//    }
//  }

//  private func fetchAccounts() async {
//    await withThrowingTaskGroup(of: Void.self) { group in
//      group.addTask {
//        let viewModel = try await fetchAccountViewModel(account: "dimillian@mastodon.social")
//        await MainActor.run {
//          dimillianAccount = viewModel
//        }
//      }
//      group.addTask {
//        let viewModel = try await fetchAccountViewModel(account: "icecubesapp@mastodon.online")
//        await MainActor.run {
//          iceCubesAccount = viewModel
//        }
//      }
//    }
//  }

//  private func fetchAccountViewModel(account: String) async throws -> AccountsListRowViewModel {
//    let dimillianAccount: Account = try await client.get(endpoint: Accounts.lookup(name: account))
//    let rel: [Relationship] = try await client.get(endpoint: Accounts.relationships(ids: [dimillianAccount.id]))
//    return .init(account: dimillianAccount, relationShip: rel.first)
//  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutView()
//      .environment(Theme.shared)
  }
}

