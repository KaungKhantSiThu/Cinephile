import SwiftUI
import Environment
import AppAccount
import CinephileUI

@MainActor
struct NavigationSheet<Content: View>: View {
  @Environment(\.dismiss) private var dismiss
  
  var content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  var body: some View {
    NavigationStack {
      content()
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              dismiss()
            } label: {
              Image(systemName: "xmark.circle")
            }
          }
        }
    }
  }
}
