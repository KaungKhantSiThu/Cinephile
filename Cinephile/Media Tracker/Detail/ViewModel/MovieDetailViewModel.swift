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
    
    
    let movieID: Movie.ID

    private let loader: MovieLoader
    
    init(movieID: Movie.ID, loader: MovieLoader = MovieLoader()) {
        self.movieID = movieID
        self.loader = loader
    }
    
    @MainActor
    func load() {
        state = .loading
        Task {
            do {
                let movie = try await loader.loadItem(withID: movieID)
                self.castMembers = try await loader.loadCastMembers(withID: movieID)
                self.videos = try await loader.loadVideos(withID: movieID)
                self.state = .loaded(movie)
            } catch {
                self.state = .failed(error)
            }
        }
    }
    
}
