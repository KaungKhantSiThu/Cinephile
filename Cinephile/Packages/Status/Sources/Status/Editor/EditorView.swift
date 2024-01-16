import Accounts
import AppAccount
import CinephileUI
import Environment
import Models
import Networking
import SwiftUI

extension StatusEditor {
    @MainActor
    struct EditorView: View {
        @Bindable var viewModel: StatusEditor.ViewModel
        @Binding var editingMediaContainer: MediaContainer?
        
        @FocusState<UUID?>.Binding var isSpoilerTextFocused: UUID?
        
        @Environment(Theme.self) private var theme
        @Environment(UserPreferences.self) private var preferences
        @Environment(CurrentAccount.self) private var currentAccount
        @Environment(AppAccountsManager.self) private var appAccounts
        @Environment(Client.self) private var client
#if targetEnvironment(macCatalyst)
        @Environment(\.dismissWindow) private var dismissWindow
#else
        @Environment(\.dismiss) private var dismiss
#endif
        
        var body: some View {
            HStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    spoilerTextView
                    VStack(spacing: 0) {
                        accountHeaderView
                        textInput
                        MediaView(viewModel: viewModel, editingMediaContainer: $editingMediaContainer)
                        embeddedStatus
                        pollView
                        trackerMediaView
                    }
                    .padding(.vertical)
                    
                    Divider()
                }
            }
            //.background(theme.primaryBackgroundColor)
            .onAppear { setupViewModel() }
        }
        
        @ViewBuilder
        private var spoilerTextView: some View {
            if viewModel.spoilerOn {
                TextField("status.editor.spoiler", text: $viewModel.spoilerText)
                    .focused($isSpoilerTextFocused, equals: viewModel.id)
                    .padding(.horizontal, .layoutPadding)
                    .padding(.vertical)
                    .background(theme.tintColor.opacity(0.20))
            }
        }
        
        @ViewBuilder
        private var accountHeaderView: some View {
            if let account = currentAccount.account, !viewModel.mode.isEditing {
                HStack {
                    if viewModel.mode.isInShareExtension {
                        AppAccountsSelectorView(routerPath: RouterPath(),
                                                accountCreationEnabled: false,
                                                avatarConfig: .status)
                    } else {
                        AvatarView(account.avatar, config: AvatarView.FrameConfiguration.status)
                            .environment(theme)
                            .accessibilityHidden(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        PrivacyMenu(visibility: $viewModel.visibility, tint: theme.tintColor)
                        
                        Text("@\(account.acct)@\(appAccounts.currentClient.server)")
                            .font(.scaledFootnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, .layoutPadding)
            }
        }
        
        private var textInput: some View {
            TextView(
                $viewModel.statusText,
                getTextView: { textView in viewModel.textView = textView }
            )
            .placeholder(String(localized: "status.editor.text.placeholder", bundle: .module))
            .setKeyboardType(preferences.isSocialKeyboardEnabled ? .twitter : .default)
            .padding(.horizontal, .layoutPadding)
            .padding(.vertical)
        }
        
        @ViewBuilder
        private var embeddedStatus: some View {
            if viewModel.replyToStatus != nil { Divider().padding(.top, 20) }
            
            if let status = viewModel.embeddedStatus ?? viewModel.replyToStatus {
                StatusEmbeddedView(status: status, client: client, routerPath: RouterPath())
                    .padding(.horizontal, .layoutPadding)
                    .disabled(true)
            }
        }
        
        @ViewBuilder
        private var pollView: some View {
            if viewModel.showPoll {
                PollView(viewModel: viewModel, showPoll: $viewModel.showPoll)
                    .padding(.horizontal)
            }
        }
        
        @ViewBuilder
        private var trackerMediaView: some View {
            if let trackerMedia = viewModel.trackerMedia {
                TrackerMediaView(media: trackerMedia) {
                    viewModel.trackerMedia = nil
                }
            }
        }
        
        private func setupViewModel() {
            viewModel.client = client
            viewModel.currentAccount = currentAccount.account
            viewModel.theme = theme
            viewModel.preferences = preferences
            viewModel.prepareStatusText()
            if !client.isAuth {
#if targetEnvironment(macCatalyst)
                dismissWindow()
#else
                dismiss()
#endif
                NotificationCenter.default.post(name: .shareSheetClose, object: nil)
            }
            
            Task { await viewModel.fetchCustomEmojis() }
        }
    }
}
