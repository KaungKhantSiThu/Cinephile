import Foundation
import SDWebImageSwiftUI
import SwiftUI
import TMDb
import Environment

@MainActor
struct SeasonView: View {
    let id: TVSeries.ID
    let seasons: [TVSeason]
    var body: some View {
        VStack(alignment: .leading) {
            Text("All Episodes")
                .foregroundStyle(.black)
                .font(.title)
                .fontWeight(.semibold)
                .padding([.leading, .bottom], 10)
            ForEach(seasons) { season in
                NavigationLink(value: RouterDestination.episodeListView(id: id, inSeason: season.seasonNumber)) {
                    SeasonRow(season: season)
                }
                .buttonStyle(.plain)
                Divider()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SeasonView(id: 12345, seasons: (TVSeries.preview?.seasons)!)
    }
}



struct SeasonRow: View {
    let name: String
    let posterPath: URL?
    @State private var posterImage = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        HStack(spacing: 20) {
            
            PosterImage(url: posterImage, height: 100, roundedCorner: false)
            
            Text(name)
                .font(.title2)
                .bold()
            
        }
        .padding(.leading, 20)
        .task {
            do {
                posterImage = try await ImageLoader.generate(from: posterPath, width: 200)
            } catch {
                print("poster URL is nil")
            }
        }
    }
}

extension SeasonRow {
    init(season: TVSeason) {
        self.name = season.name
        self.posterPath = season.posterPath
    }
}
