import CinephileUI
import SwiftUI

struct StatusRowReblogView: View {
  let viewModel: StatusRowViewModel

  var body: some View {
    if viewModel.status.reblog != nil {
      HStack(spacing: 2) {
          Image(systemName: "arrow.left.arrow.right")
        AvatarView(viewModel.status.account.avatar, config: .boost)
        EmojiTextApp(.init(stringValue: viewModel.status.account.safeDisplayName), emojis: viewModel.status.account.emojis)
        Text("status.row.was-boosted", bundle: .module)
      }
      .font(.scaledFootnote)
      .emojiSize(Font.scaledFootnoteFont.emojiSize)
      .emojiBaselineOffset(Font.scaledFootnoteFont.emojiBaselineOffset)
      .foregroundStyle(.secondary)
      .fontWeight(.semibold)
      .onTapGesture {
        viewModel.navigateToAccountDetail(account: viewModel.status.account)
      }
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) {
    StatusRowReblogView(viewModel: .init(status: .placeholder(), client: .init(server: "mastodon.social"), routerPath: .init()))
}

