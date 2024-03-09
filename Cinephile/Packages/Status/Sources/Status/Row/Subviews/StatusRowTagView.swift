
import Environment
import SwiftUI

struct StatusRowTagView: View {
  @Environment(CurrentAccount.self) private var currentAccount
  let viewModel: StatusRowViewModel

  var body: some View {
    if let tag = viewModel.finalStatus.content.links.first(where: { link in
      link.type == .hashtag && currentAccount.tags.contains(where: { $0.name.lowercased() == link.title.lowercased() })
    }) {
      Text("#\(tag.title)")
        .font(.scaledFootnote)
        .foregroundStyle(.secondary)
        .fontWeight(.semibold)
        .onTapGesture {
            viewModel.goToTag(name: tag.title)
        }
    }
  }
}

//#Preview {
//    StatusRowTagView(viewModel: .init(status: .preview, client: .init(server: "mastodon.social"), routerPath: .init()))
//        .environment(CurrentAccount.shared)
//}
