import Foundation
import SwiftUI
import MediaClient
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
//    NavigationStack {
//        SeasonView(id: 12345, seasons: (TVSeries.preview?.seasons)!)
//    }
    SeasonRow(name: "Season 1", posterPath: nil )
}



struct SeasonRow: View {
    let name: String
    let posterPath: URL?
    var body: some View {
        HStack(spacing: 20) {
            
            PosterImage(url: ImageService.shared.posterURL(for: posterPath), height: 100, roundedCorner: false)
            
            Text(name)
                .font(.title2)
                .bold()
            
        }
        .padding(.leading, 20)
    }
}

extension SeasonRow {
    init(season: TVSeason) {
        self.name = season.name
        self.posterPath = season.posterPath
    }
}
