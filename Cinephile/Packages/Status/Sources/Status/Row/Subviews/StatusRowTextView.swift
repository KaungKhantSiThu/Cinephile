import CinephileUI
import Environment
import Models
import SwiftUI

@MainActor
struct StatusRowTextView: View {
  @Environment(Theme.self) private var theme
  @Environment(\.isStatusFocused) private var isFocused

  var viewModel: StatusRowViewModel

  var body: some View {
    VStack {
      HStack {
        EmojiTextApp(viewModel.finalStatus.content,
                     emojis: viewModel.finalStatus.emojis,
                     language: viewModel.finalStatus.language,
                     lineLimit: viewModel.lineLimit)
          .font(isFocused ? .scaledBodyFocused : .scaledBody)
          .lineSpacing(CGFloat(theme.lineSpacing))
//          .foregroundColor(viewModel.textDisabled ? .gray : theme.labelColor)
          .emojiSize(isFocused ? Font.scaledBodyFocusedFont.emojiSize : Font.scaledBodyFont.emojiSize)
          .emojiBaselineOffset(isFocused ? Font.scaledBodyFocusedFont.emojiBaselineOffset : Font.scaledBodyFont.emojiBaselineOffset)
          .environment(\.openURL, OpenURLAction { url in
            viewModel.routerPath.handleStatus(status: viewModel.finalStatus, url: url)
          })
        Spacer()
      }
      makeCollapseButton()
    }
  }

  @ViewBuilder
  func makeCollapseButton() -> some View {
    if let _ = viewModel.lineLimit {
      HStack(alignment: .top) {
        Text("status.show-full-post", bundle: .module)
          .font(.system(.subheadline, weight: .bold))
          .foregroundColor(.secondary)
        Spacer()
        Button {
          withAnimation {
            viewModel.isCollapsed.toggle()
          }
        } label: {
          Image(systemName: "chevron.down")
        }
        .buttonStyle(.bordered)
        .accessibility(label: Text("status.show-full-post", bundle: .module))
        .accessibilityHidden(true)
      }
      .contentShape(Rectangle())
      .onTapGesture { // make whole row tapable to make up for smaller button size
        withAnimation {
          viewModel.isCollapsed.toggle()
        }
      }
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) {
    StatusRowTextView(viewModel: .init(status: .preview, client: .init(server: "mastodon.social"), routerPath: .init()))
        .environment(Theme.shared)
}