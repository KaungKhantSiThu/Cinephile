import Foundation
import SDWebImageSwiftUI
import SwiftUI
import TMDb

struct SeasonView: View {
    var seasons: [TVSeason]
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        VStack(alignment: .leading) {
            Text("Seasons")
                .font(.title2)
                .fontWeight(.semibold)
                .padding([.leading, .bottom], 10)
            ForEach(seasons) { season in
                NavigationLink(destination: EpisodeView(episodes: season.episodes ?? [])) {
                    HStack(spacing: 20) {
                        WebImage(url: posterImage)
                            .placeholder(Image(systemName: "photo"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                        VStack(alignment: .leading) {
                            Text(season.name)
                                .font(.subheadline)
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: 100)
                    }
                }
                .padding(.leading, 20)
                .task {
                    do {
                        posterImage = try await ImageLoader.generate(from: season.posterPath, width: 200)
                    } catch {
                        print("poster URL is nil")
                    }
                }
                Divider()
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


