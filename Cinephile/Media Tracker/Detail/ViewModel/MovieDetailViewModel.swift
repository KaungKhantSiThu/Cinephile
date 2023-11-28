//
//  MovieDetailViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 02/11/2023.
//

import SwiftUI
import TMDb

class MovieDetailViewModel<Loader: DataLoader>: ObservableObject, LoadableObject {
    @Published private(set) var state: LoadingState<Movie> = .idle
    
    @Published var castMembers: [CastMember] = []
    @Published var videos: [VideoMetadata] = []
    @Published var posterImageURL: URL = URL(string: "https://picsum.photos/200/300")!
    
    
    let id: Movie.ID

    private let loader: MovieLoader
    
    init(id: Movie.ID, loader: MovieLoader = MovieLoader()) {
        self.id = id
        self.loader = loader
    }
    
    @MainActor
    func load() {
        state = .loading
        Task {
            do {
                let movie = try await loader.loadItem(withID: id)
                self.castMembers = try await loader.loadCastMembers(withID: id)
                self.videos = try await loader.loadVideos(withID: id)
                self.state = .loaded(movie)
                self.posterImageURL = try await ImageLoader.generate(from: movie.posterPath, width: 200)
            } catch {
                self.state = .failed(error)
            }
        }
    }
    
}
