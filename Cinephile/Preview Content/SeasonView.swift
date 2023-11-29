import Foundation
import SwiftUI
import TMDb

struct SeasonView: View {
    var seasons: [TVSeason]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Seasons")
                .font(.title2)
                .fontWeight(.semibold)
                .padding([.leading, .bottom], 10)
            ForEach(seasons) { season in
                NavigationLink(destination: EpisodeView(episodes: season.episodes ?? [])) {
                    HStack(spacing: 20) {
                        Image(systemName: "person")
                            .background(in: Circle().inset(by: -8))
                            .backgroundStyle(.red.gradient)
                            .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
                        VStack(alignment: .leading) {
                            Text(season.name)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.leading, 30)
                    .padding()
                    Divider()
                }
            }
        }
    }
}

#Preview {
    SeasonView(seasons: (TVSeries.preview?.seasons)!)
        .onAppear {
            print(CastMember.preview)
        }
}

