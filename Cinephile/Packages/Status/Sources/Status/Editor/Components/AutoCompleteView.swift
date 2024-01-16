import EmojiText
import Foundation
import SwiftUI
import CinephileUI

extension StatusEditor {
    @MainActor
    struct AutoCompleteView: View {
        @Environment(Theme.self) private var theme
        var viewModel: StatusEditor.ViewModel
        
        var body: some View {
            if !viewModel.mentionsSuggestions.isEmpty || !viewModel.tagsSuggestions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        if !viewModel.mentionsSuggestions.isEmpty {
                            suggestionsMentionsView
                        } else {
                            suggestionsTagView
                        }
                    }
                    .padding(.horizontal, .layoutPadding)
                }
                .frame(height: 40)
                .background(.ultraThinMaterial)
            }
        }
        
        private var suggestionsMentionsView: some View {
            ForEach(viewModel.mentionsSuggestions) { account in
                Button {
                    viewModel.selectMentionSuggestion(account: account)
                } label: {
                    HStack {
                        AvatarView(account.avatar, config: AvatarView.FrameConfiguration.badge)
                        VStack(alignment: .leading) {
                            EmojiTextApp(.init(stringValue: account.safeDisplayName),
                                         emojis: account.emojis)
                            .emojiSize(Font.scaledFootnoteFont.emojiSize)
                            .emojiBaselineOffset(Font.scaledFootnoteFont.emojiBaselineOffset)
                            .font(.scaledFootnote)
                            //.foregroundColor(theme.labelColor)
                            Text("@\(account.acct)", comment: "Account name")
                                .font(.scaledCaption)
                                .foregroundColor(theme.tintColor)
                        }
                    }
                }
            }
        }
        
        private var suggestionsTagView: some View {
            ForEach(viewModel.tagsSuggestions) { tag in
                Button {
                    viewModel.selectHashtagSuggestion(tag: tag)
                } label: {
                    VStack(alignment: .leading) {
                        Text("#\(tag.name)", comment: "Tag name")
                            .font(.scaledFootnote)
                            .foregroundColor(theme.tintColor)
                        Text("tag.suggested.mentions-\(tag.totalUses)", bundle: .module)
                            .font(.scaledCaption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

