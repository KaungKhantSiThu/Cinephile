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

@MainActor
public struct StatusEditorView: View {
  @Environment(AppAccountsManager.self) private var appAccounts
  @Environment(CurrentAccount.self) private var currentAccount
  @Environment(Theme.self) private var theme

  @State private var viewModel: StatusEditorViewModel
  @FocusState private var isSpoilerTextFocused: UUID? // connect CoreEditor and StatusEditorAccessoryView
  @State private var editingMediaContainer: StatusEditorMediaContainer?
  @State private var scrollID: UUID?

  public init(mode: StatusEditorViewModel.Mode) {
    _viewModel = State(initialValue: StatusEditorViewModel(mode: mode))
  }

  public var body: some View {
    NavigationStack {
      ScrollView {
        VStackLayout(spacing: 0) {
          StatusEditorCoreView(
            viewModel: viewModel,
            editingMediaContainer: $editingMediaContainer,
            isSpoilerTextFocused: $isSpoilerTextFocused
          )
          .id(viewModel.id)
        }
        .scrollTargetLayout()
      }
      .scrollPosition(id: $scrollID, anchor: .top)
      .background(theme.primaryBackgroundColor)
      .safeAreaInset(edge: .bottom) {
        StatusEditorAutoCompleteView(viewModel: viewModel)
      }
      .safeAreaInset(edge: .bottom) {
        StatusEditorAccessoryView(isSpoilerTextFocused: $isSpoilerTextFocused, viewModel: viewModel)
      }
      .accessibilitySortPriority(1) // Ensure that all elements inside the `ScrollView` occur earlier than the accessory views
      .navigationTitle(viewModel.mode.title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar { StatusEditorToolbarItems(viewModel: viewModel) }
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
      .onDrop(of: StatusEditorUTTypeSupported.types(), delegate: viewModel)
      .onChange(of: currentAccount.account?.id) {
        viewModel.currentAccount = currentAccount.account
      }
    }
    .sheet(item: $editingMediaContainer) { container in
      StatusEditorMediaEditView(viewModel: viewModel, container: container)
    }
  }
}
