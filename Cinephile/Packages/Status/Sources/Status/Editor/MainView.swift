import Accounts
import AppAccount
import CinephileUI
import EmojiText
import Environment
import Models
import Networking
import NukeUI
import PhotosUI
import SwiftUI
import UIKit

extension StatusEditor {
    @MainActor
    public struct MainView: View {
        @Environment(AppAccountsManager.self) private var appAccounts
        @Environment(CurrentAccount.self) private var currentAccount
        @Environment(Theme.self) private var theme
        
        @State private var viewModel: StatusEditor.ViewModel
        @FocusState private var isSpoilerTextFocused: UUID? // connect CoreEditor and StatusEditorAccessoryView
        @State private var editingMediaContainer: MediaContainer?
        @State private var scrollID: UUID?
        
        public init(mode: ViewModel.Mode) {
            _viewModel = State(initialValue: ViewModel(mode: mode))
        }
        
        public var body: some View {
            NavigationStack {
                ScrollView {
                    VStackLayout(spacing: 0) {
                        EditorView(
                            viewModel: viewModel,
                            editingMediaContainer: $editingMediaContainer,
                            isSpoilerTextFocused: $isSpoilerTextFocused
                        )
                        .id(viewModel.id)
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrollID, anchor: .top)
                //.background(theme.primaryBackgroundColor)
                .safeAreaInset(edge: .bottom) {
                    AutoCompleteView(viewModel: viewModel)
                }
                .safeAreaInset(edge: .bottom) {
                    AccessoryView(isSpoilerTextFocused: $isSpoilerTextFocused, viewModel: viewModel)
                }
                .accessibilitySortPriority(1) // Ensure that all elements inside the `ScrollView` occur earlier than the accessory views
                .navigationTitle(viewModel.mode.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItems(viewModel: viewModel) }
                .toolbarBackground(.visible, for: .navigationBar)
                .alert(
                    "status.error.posting.title",
                    isPresented: $viewModel.showPostingErrorAlert,
                    actions: {
                        Button {
                            
                        } label: {
                            Text("alert.button.ok")
                        }
                    }, message: {
                        Text(viewModel.postingError ?? "")
                    }
                )
                .interactiveDismissDisabled(viewModel.shouldDisplayDismissWarning)
                .onChange(of: appAccounts.currentClient) { _, newValue in
                    if viewModel.mode.isInShareExtension {
                        currentAccount.setClient(client: newValue)
                        viewModel.client = newValue
                    }
                }
                .onDrop(of: StatusEditor.UTTypeSupported.types(), delegate: viewModel)
                .onChange(of: currentAccount.account?.id) {
                    viewModel.currentAccount = currentAccount.account
                }
            }
            .sheet(item: $editingMediaContainer) { container in
                MediaEditView(viewModel: viewModel, container: container)
            }
        }
    }
}
