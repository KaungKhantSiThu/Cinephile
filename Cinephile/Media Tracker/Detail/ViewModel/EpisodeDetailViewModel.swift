import SwiftUI
import TMDb

class EpisodeDetailViewModel: ObservableObject, LoadableObject {
    @Published private(set) var state: LoadingState<TVEpisode> = .idle
    
    @Published var castMembers: [CastMember] = []
    @Published var videos: [VideoMetadata] = []
    @Published var posterImageURL: URL = URL(string: "https://picsum.photos/200/300")!
    
    let episodeId: TVEpisode.ID
    let seasonId : TVSeason.ID
    let seriesId : TVSeries.ID

    private let loader: TVEpisodeLoader
    
    init(episodeId: TVEpisode.ID, seasonId: TVSeason.ID, seriesId: TVSeries.ID, loader: TVEpisodeLoader = TVEpisodeLoader()) {
        self.episodeId = episodeId
        self.seasonId = seasonId
        self.seriesId = seriesId
        self.loader = loader
    }
    
    @MainActor
    func load() {
        state = .loading
        Task {
            do {
                let tvEpisode = try await loader.loadItem(episodeId: episodeId, seasonId: seasonId, sereisId: seriesId)
                self.state = .loaded(tvEpisode)
                self.posterImageURL = try await ImageLoader.generate(from: tvEpisode.stillPath, width: 200)
            } catch {
                self.state = .failed(error)
            }
        }
    }
    
}
