//
//  MovieDetailViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 02/11/2023.
//

import SwiftUI
import MediaClient
import Models
import Networking

@Observable class MovieDetailViewModel: LoadableObject {
    
    private(set) var state: LoadingState<MovieDetail> = .idle
    private(set) var posterImageURL: URL = URL(string: "https://picsum.photos/200/300")!
    
    
    let id: Movie.ID
    
    private let loader = MovieLoader()
    var client: Client?
    
    var watchlistError: String?
    var showWatchlistErrorAlert: Bool = false
    
//    var addedToWatchlist: Bool {
//        guard let client else { return false }
//        Task {
//            do {
//                let watchlist: Watchlist = try await client.get(endpoint: Watchlists.get(id: self.id))
//                return true
//            } catch {
//                if let error = error as? Models.ServerError {
//                    watchlistError = error.error
//                    showWatchlistErrorAlert = true
//                    return false
//                }
//            }
//        }
//        return false
//        
//    }
    
    var inWatchlist = false
    
    
    init(id: Movie.ID) {
        self.id = id
    }
    
    @MainActor
    func load() {
        self.state = .loading
        Task {
            do {
                let data = try await fetchMovieDetailData()
                self.posterImageURL = ImageService.shared.posterURL(for: data.movie.posterPath)
                
                if let _ = await isInWatchlist() {
                    self.inWatchlist = true
                } else {
                    self.inWatchlist = false
                }
                
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
        async let recommendations = loader.loadRecommendations(withID: id)
        
        return try await .init(movie: movie, castMembers: castMembers, videos: videos, showWatchProvider: showWatchProvider, recommendations: recommendations)
    }
    
    enum ClientError: Error {
        case notInitialized
    }
    
    func isInWatchlist() async -> Entertainment? {
        
        do {
            guard let client else { throw ClientError.notInitialized }
            let entertainments: [Entertainment] = try await client.post(endpoint: Entertainments.search(json: EntertainmentSearchData(mediaType: .movie, mediaId: String(self.id))))
            if !entertainments.isEmpty, let result = entertainments.first {
                return result
            } else {
                return nil
            }
        } catch {
            if let error = error as? Models.ServerError {
                watchlistError = error.error
                showWatchlistErrorAlert = true
            }
        }
        return nil
    }
    
    func addToWatchlist() async {
        guard let client else { return }
        var entertainmentId: Int?
        //        var entertainment: Entertainment?
        do {
            if let entertainment = await isInWatchlist() {
                entertainmentId = entertainment.id
            }
//            let entertainments: [Entertainment] = try await client.post(endpoint: Entertainments.search(json: EntertainmentSearchData(mediaType: .movie, mediaId: String(self.id))))
//            if !entertainments.isEmpty, let result = entertainments.first {
//                
//                entertainmentId = result.id
//            } 
            else {
                let data: EntertainmentData = .init(
                    domain: "themoviedb.org",
                    mediaType: .movie,
                    mediaId: String(self.id))
                let entertainment: Entertainment = try await client.post(endpoint: Entertainments.post(json: data))
                
                entertainmentId = entertainment.id
            }
            if let entertainmentId {
                let watchlist: Watchlist = try await client.post(endpoint: Watchlists.post(json: WatchlistData(entertainmentId: entertainmentId, watchStatus: .unwatched)))
            }
        } catch {
            if let error = error as? Models.ServerError {
                watchlistError = error.error
                showWatchlistErrorAlert = true
            }
        }
        
    }
    
    func removeFromWatchlist() async {
        guard let client else { return }
        //        var entertainment: Entertainment?
        do {
            if let entertainment = await isInWatchlist() {
                let response = try await client.delete(endpoint: Watchlists.delete(id: entertainment.id))
            }
//            let entertainments: [Entertainment] = try await client.post(endpoint: Entertainments.search(json: EntertainmentSearchData(mediaType: .movie, mediaId: String(self.id))))
//            if !entertainments.isEmpty, let result = entertainments.first {
//
//                entertainmentId = result.id
//            }
//            else {
//                let data: EntertainmentData = .init(
//                    domain: "themoviedb.org",
//                    mediaType: .movie,
//                    mediaId: String(self.id))
//                let entertainment: Entertainment = try await client.post(endpoint: Entertainments.post(json: data))
//                
//                entertainmentId = entertainment.id
//            }

        } catch {
            if let error = error as? Models.ServerError {
                watchlistError = error.error
                showWatchlistErrorAlert = true
            }
        }
    }
    
}

extension MovieDetailViewModel {
    struct MovieDetail {
        let movie: Movie
        var castMembers: [CastMember]
        var videos: [VideoMetadata]
        var showWatchProvider: ShowWatchProvider?
        var recommendations: [Movie]
    }
}
