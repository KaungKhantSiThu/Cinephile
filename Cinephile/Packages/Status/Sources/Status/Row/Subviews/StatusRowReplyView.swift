
import SwiftUI
import CinephileUI

struct StatusRowReplyView: View {
    let viewModel: StatusRowViewModel
    
    var body: some View {
        Group {
            if let accountId = viewModel.status.inReplyToAccountId {
                Group {
                    if let mention = viewModel.status.mentions.first(where: { $0.id == accountId }) {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.left.arrow.right")
                            Text("Replied to")
                            Text(mention.username)
                            
                        }
                    } else if viewModel.isThread, accountId == viewModel.status.account.id {
                        HStack(spacing: 2) {
                            Image(systemName: "quote.opening")
                            Text("status.row.is-thread", bundle: .module)
                        }
                    }
                }
                .onTapGesture {
                    viewModel.goToParent()
                }
            }
        }
        .font(.scaledFootnote)
        .foregroundStyle(.secondary)
        .fontWeight(.semibold)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    StatusRowReplyView(viewModel: .init(status: .placeholder(), client: .init(server: "mastodon.social"), routerPath: .init()))
}
