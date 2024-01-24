import Foundation
import SwiftUI
import MediaClient

@MainActor
public struct EpisodeListView: View {
    @State private var episodes: [TVEpisode] = []
    let id: TVSeason.ID
    let inSeason: Int
    
    public init(id: TVSeason.ID, inSeason: Int) {
        self.id = id
        self.inSeason = inSeason
    }
    public var body: some View {
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
            do {
                let results: TVSeason = try await APIService.shared.get(endpoint: TVSeasonsEndpoint.details(tvSeriesID: id, seasonNumber: inSeason))
                self.episodes = results.episodes ?? []
            } catch {
                print("No episodes")
            }
        }
    }
}

//#Preview {
//    EpisodeListView(id: 3573, inSeason: 2)
//}


@MainActor
public struct EpisodeView: View {
    let number: Int
    let name: String
    let airDate: Date?
    let stillPath: URL?
//    @State private var stillImage = URL(string: "https://picsum.photos/200/300")!
    public var body: some View {
        HStack(spacing: 20) {
            Text(number, format: .number)
                .font(.title)
                .bold()
                .frame(width: 40)
            
            AsyncImage(url: ImageService.shared.posterURL(for: stillPath)) { image in
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
                    
                
                Text(airDate ?? Date.now, style: .date)
                    .foregroundStyle(.secondary)
                
            }
        }
        .padding()
//        .task {
//            do {
//                stillImage = try await ImageLoaderS.generate(from: stillPath)
//            } catch {
//                print("poster URL is nil")
//            }
//        }
    }
    
    public init(episode: TVEpisode) {
        self.number = episode.episodeNumber
        self.name = episode.name
        self.airDate = episode.airDate
        self.stillPath = episode.stillPath
    }
    
    init(number: Int, name: String, airDate: Date?, stillPath: URL?) {
        self.number = number
        self.name = name
        self.airDate = airDate
        self.stillPath = stillPath
    }
}

#Preview("EpisodeView") {
    EpisodeView(number: 1, name: "Seven Thirty-Seven", airDate: Date.distantPast, stillPath: nil)
}

