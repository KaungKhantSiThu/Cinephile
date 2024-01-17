//
//  MovieDetailViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 02/11/2023.
//

import SwiftUI
import TMDb



@Observable class MovieDetailViewModel: LoadableObject {
    
    private(set) var state: LoadingState<MovieDetail> = .idle
    private(set) var posterImageURL: URL = URL(string: "https://picsum.photos/200/300")!
    
    
    let id: Movie.ID

    private let loader = MovieLoader()
    
    init(id: Movie.ID) {
        self.id = id
    }
    
    @MainActor
    func load() {
        self.state = .loading
        Task {
            do {
                let data = try await fetchMovieDetailData()
                self.posterImageURL = try await ImageLoaderS.generate(from: data.movie.posterPath)
                self.state = .loaded(data)
            } catch {
                self.state = .failed(error)
            }
        }
    }
    
    private func fetchMovieDetailData() async throws -> MovieDetail {
        async let movie = loader.loadItem(withID: id)
        async let castMembers = loader.loadCastMembers(withID: id)
        async let videos = loader.loadVideos(withID: id)
        async let showWatchProvider = loader.loadShowWatchProvider(withID: id)
        
        return try await .init(movie: movie, castMembers: castMembers, videos: videos, showWatchProvider: showWatchProvider)
    }
}

extension MovieDetailViewModel {
    struct MovieDetail {
        let movie: Movie
        var castMembers: [CastMember]
        var videos: [VideoMetadata]
        var showWatchProvider: ShowWatchProvider?
    }
}