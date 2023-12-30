import CinephileUI
import Models
import Networking
import SwiftUI
import EmojiText
import OSLog

private let logger = Logger(subsystem: "Status", category: "EditHistoryView")

public struct StatusEditHistoryView: View {
  @Environment(\.dismiss) private var dismiss

  @Environment(Client.self) private var client
  @Environment(Theme.self) private var theme

  private let statusId: String

  @State private var history: [StatusHistory]?

  public init(statusId: String) {
    self.statusId = statusId
  }

  public var body: some View {
    NavigationStack {
      List {
        Section {
          if let history {
            ForEach(history) { edit in
              VStack(alignment: .leading, spacing: 8) {
                EmojiTextApp(edit.content, emojis: edit.emojis)
                  .font(.scaledBody)
                  .emojiSize(Font.scaledBodyFont.emojiSize)
                  .emojiBaselineOffset(Font.scaledBodyFont.emojiBaselineOffset)
//                Group {
//                  Text(edit.createdAt.asDate, style: .date) +
//                    Text("status.summary.at-time", bundle: .module) +
//                    Text(edit.createdAt.asDate, style: .time)
//                }
//                .font(.footnote)
//                .foregroundStyle(.secondary)
                  StatusRowHistory(editedAt: edit.createdAt.asDate)
              }
            }
          } else {
            HStack {
              Spacer()
              ProgressView()
              Spacer()
            }
          }
        }
        .listRowBackground(theme.primaryBackgroundColor)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                dismiss()
            } label: {
                Text("action.done", bundle: .module)
            }
        }
      }
      .navigationTitle(Text("status.summary.edit-history", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task {
        do {
          history = try await client.get(endpoint: Statuses.history(id: statusId))
        } catch {
            logger.error("Error fetching Status's history: \(error.localizedDescription)")
        }
      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
      .background(theme.primaryBackgroundColor)
    }
  }
}
