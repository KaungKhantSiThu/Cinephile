import CinephileUI
import Environment
import Models
import SwiftUI

struct TimelineTagHeaderView: View {
  @Environment(CurrentAccount.self) private var account

  @Binding var tag: Tag?

  @State var isLoading: Bool = false

  var body: some View {
    if let tag {
      TimelineHeaderView {
        HStack {
          TagChartView(tag: tag)
            .padding(.top, 12)

          VStack(alignment: .leading, spacing: 4) {
            Text("#\(tag.name)")
              .font(.scaledHeadline)
              Text("timeline.n-recent-from-n-participants \(tag.totalUses) \(tag.totalAccounts)", bundle: .module)
              .font(.scaledFootnote)
              .foregroundStyle(.secondary)
          }
          Spacer()
          Button {
            Task {
              isLoading = true
              if tag.following {
                self.tag = await account.unfollowTag(id: tag.name)
              } else {
                self.tag = await account.followTag(id: tag.name)
              }
              isLoading = false
            }
          } label: {
            Text(tag.following ? "account.follow.following" : "account.follow.follow", bundle: .module)
          }
          .disabled(isLoading)
          .buttonStyle(.bordered)
        }
      }
    }
  }
}
