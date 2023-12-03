import SwiftUI
import TMDb

class EpisodeDetailViewModel<Loader: DataLoader>: ObservableObject, LoadableObject {
    @Published private(set) var state: LoadingState<TVEpisode> = .idle
    
    @Published var castMembers: [CastMember] = []
    @Published var videos: [VideoMetadata] = []
    @Published var posterImageURL: URL = URL(string: "https://picsum.photos/200/300")!
    
    let id: TVEpisode.ID

    private let loader: TVEpisodeLoader
    
    init(id: TVEpisode.ID, loader: TVEpisodeLoader = TVEpisodeLoader()) {
        self.id = id
        self.loader = loader
    }
    
    @MainActor
    func load() {
        state = .loading
        Task {
            do {
                let tvEpisode = try await loader.loadItem(withID: id)
                self.castMembers = try await loader.loadCastMembers(withID: id)
                self.videos = try await loader.loadVideos(withID: id)
                self.state = .loaded(tvEpisode)
                self.posterImageURL = try await ImageLoader.generate(from: tvEpisode.stillPath, width: 200)
            } catch {
                self.state = .failed(error)
            }
        }
    }
    
}
