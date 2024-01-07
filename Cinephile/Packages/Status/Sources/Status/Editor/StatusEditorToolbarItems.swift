import Environment
import Models
import StoreKit
import SwiftUI



@MainActor
struct StatusEditorToolbarItems: ToolbarContent {
  @State private var isLanguageConfirmPresented = false
  @State private var isDismissAlertPresented: Bool = false
  let viewModel: StatusEditorViewModel

  @Environment(\.modelContext) private var context
  @Environment(UserPreferences.self) private var preferences
  #if targetEnvironment(macCatalyst)
    @Environment(\.dismissWindow) private var dismissWindow
  #else
    @Environment(\.dismiss) private var dismiss
  #endif

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        Task {
          viewModel.evaluateLanguages()
          if preferences.autoDetectPostLanguage, let _ = viewModel.languageConfirmationDialogLanguages {
            isLanguageConfirmPresented = true
          } else {
            await postAllStatus()
          }
        }
      } label: {
        if viewModel.isPosting {
          ProgressView()
        } else {
          Text("status.action.post", bundle: .module).bold()
        }
      }
      .disabled(!viewModel.canPost)
      .keyboardShortcut(.return, modifiers: .command)
      .confirmationDialog("", isPresented: $isLanguageConfirmPresented, actions: {
        languageConfirmationDialog
      })
    }

    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        if viewModel.shouldDisplayDismissWarning {
          isDismissAlertPresented = true
        } else {
          close()
          NotificationCenter.default.post(name: .shareSheetClose,
                                          object: nil)
        }
      } label: {
        Text("action.cancel", bundle: .module)
      }
      .keyboardShortcut(.cancelAction)
      .confirmationDialog(
        "",
        isPresented: $isDismissAlertPresented,
        actions: {
          Button("status.draft.delete", role: .destructive) {
            close()
            NotificationCenter.default.post(name: .shareSheetClose,
                                            object: nil)
          }
          Button("status.draft.save") {
            context.insert(Draft(content: viewModel.statusText.string))
            close()
            NotificationCenter.default.post(name: .shareSheetClose,
                                            object: nil)
          }
          Button("action.cancel", role: .cancel) {}
        }
      )
    }
  }

  @discardableResult
  private func postStatus(with model: StatusEditorViewModel, isMainPost: Bool) async -> Status? {
    let status = await model.postStatus()

    if status != nil, isMainPost {
      close()
//      SoundEffectManager.shared.playSound(.tootSent)
      NotificationCenter.default.post(name: .shareSheetClose, object: nil)
//      #if !targetEnvironment(macCatalyst)
//        if !viewModel.mode.isInShareExtension, !preferences.requestedReview {
//          if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//            SKStoreReviewController.requestReview(in: scene)
//          }
//          preferences.requestedReview = true
//        }
//      #endif
    }

    return status
  }

  private func postAllStatus() async {
    guard let _ = await postStatus(with: viewModel, isMainPost: true) else { return }
  }

  #if targetEnvironment(macCatalyst)
    private func close() { dismissWindow() }
  #else
    private func close() { dismiss() }
  #endif

  @ViewBuilder
  private var languageConfirmationDialog: some View {
    if let (detected: detected, selected: selected) = viewModel.languageConfirmationDialogLanguages,
       let detectedLong = Locale.current.localizedString(forLanguageCode: detected),
       let selectedLong = Locale.current.localizedString(forLanguageCode: selected)
    {
      Button("status.editor.language-select.confirmation.detected-\(detectedLong)") {
        viewModel.selectedLanguage = detected
        Task { await postAllStatus() }
      }
      Button("status.editor.language-select.confirmation.selected-\(selectedLong)") {
        viewModel.selectedLanguage = selected
        Task { await postAllStatus() }
      }
      Button("action.cancel", role: .cancel) {
        viewModel.languageConfirmationDialogLanguages = nil
      }
    } else {
      EmptyView()
    }
  }
}
