import Foundation
import SwiftUI
import TMDb

@MainActor
struct EpisodeListView: View {
    @State private var episodes: [TVEpisode] = []
    let id: TVSeries.ID
    let inSeason: Int
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(episodes) { episode in
                    EpisodeView(episode: episode)
                    Divider()
                }
            }
        }
        .navigationTitle("Season \(inSeason)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            let service = TVSeasonService()
            do {
                self.episodes = try await service.details(forSeason: inSeason, inTVSeries: id).episodes ?? []
            } catch {
                print("No episodes")
            }
        }
    }
}

//#Preview {
//    EpisodeListView(id: 12345)
//}


@MainActor
struct EpisodeView: View {
    let number: Int
    let name: String
    let airDate: Date?
    let stillPath: URL?
    @State private var stillImage = URL(string: "https://picsum.photos/200/300")!
    var body: some View {
        HStack(spacing: 20) {
            Text(number, format: .number)
                .font(.title)
                .bold()
                .frame(width: 40)
            
            AsyncImage(url: stillImage) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Rectangle()
                    .overlay {
                        ProgressView()
                    }
                
            }
            .frame(width: 140,height: 80)
            
            
            
            .frame(height: 70)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                    
                
                Text(airDate?.formattedDate() ?? "No date")
                    .foregroundStyle(.secondary)
                
            }
        }
        .padding()
        .task {
            do {
                stillImage = try await ImageLoader.generate(from: stillPath, width: 140)
            } catch {
                print("poster URL is nil")
            }
        }
    }
    
    init(episode: TVEpisode) {
        self.number = episode.episodeNumber
        self.name = episode.name
        self.airDate = episode.airDate
        self.stillPath = episode.stillPath
    }
}
