import Foundation
import SwiftUI
import TMDb


class SeriesDetailViewModel<Loader: DataLoader>: ObservableObject, LoadableObject {
    
    @Published private(set) var state: LoadingState<TVSeries> = .idle
    
    @Published var castMembers: [CastMember] = []
    @Published var videos: [VideoMetadata] = []
    @Published var posterImageURL: URL = URL(string: "https://picsum.photos/200/300")!
    
    let id: Movie.ID

    private let loader: TVSeriesLoader
    
    init(id: TVSeries.ID, loader: TVSeriesLoader = TVSeriesLoader()) {
        self.id = id
        self.loader = loader
    }
    
    @MainActor
    func load() {
        state = .loading
        Task {
            do {
                let serires = try await loader.loadItem(withID: id)
                self.castMembers = try await loader.loadCastMembers(withID: id)
                self.state = .loaded(serires)
                self.posterImageURL = try await ImageLoader.generate(from: serires.posterPath, width: 200)
            } catch {
                self.state = .failed(error)
            }
        }
    }
    
}
