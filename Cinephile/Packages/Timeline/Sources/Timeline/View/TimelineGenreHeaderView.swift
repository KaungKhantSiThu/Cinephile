import CinephileUI
import Environment
import Models
import SwiftUI

struct TimelineGenreHeaderView: View {
  @Environment(CurrentAccount.self) private var account

  @Binding var genre: Genre?

  @State var isLoading: Bool = false

  var body: some View {
    if let genre {
      TimelineHeaderView {
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(genre.name)
                    .font(.scaledHeadline)
                Text("\(genre.participantCount) users is following")
                    .font(.scaledFootnote)
                    .foregroundStyle(.secondary)
            }
          Spacer()
          Button {
            Task {
              isLoading = true
              if genre.isFollowed {
                self.genre = await account.unfollowGenre(id: genre.genreId)
              } else {
                self.genre = await account.followGenre(id: genre.genreId)
              }
              isLoading = false
            }
          } label: {
              Text(genre.isFollowed ? "account.follow.following" : "account.follow.follow", bundle: .module)
          }
          .disabled(isLoading)
          .buttonStyle(.bordered)
        }
      }
    }
  }
}
