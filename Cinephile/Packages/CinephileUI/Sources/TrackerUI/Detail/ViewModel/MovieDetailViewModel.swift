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
    private(set) var title: String = ""

    let id: Movie.ID
    
    private let loader = MovieLoader()
    var client: Client?
    
    var watchlistError: String?
    var showWatchlistErrorAlert: Bool = false
    
    var isLoggedin = false
    
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
    var hasWatched = false
    private var isEntertainment = false
    var entertainmentID: Entertainment.ID?
    var entertainment: Entertainment?
    
    var isReleased = false
    
    init(id: Movie.ID) {
        self.id = id
    }
    
    func isDateInPast(_ date: Date) -> Bool {
        let currentDate = Date()
        return date < currentDate
    }
    
    @MainActor
    func load() {
        self.state = .loading
        Task {
            do {
                let data = try await fetchMovieDetailData()
                
                self.posterImageURL = ImageService.shared.posterURL(for: data.movie.posterPath)
                self.title = data.movie.title
                if let releasedDate = data.movie.releaseDate {
                    self.isReleased = isDateInPast(releasedDate)
                }
                if let entertainment = await isInWatchlist() {
                    self.inWatchlist = true
                    if let watchlist = entertainment.watchStatus, let watchStatus = watchlist.watchStatus {
                        self.hasWatched = watchStatus == .watched
                    }
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
            guard let client, client.isAuth else {
                self.isLoggedin = false
                throw ClientError.notInitialized
            }
            self.isLoggedin = true
            
            let entertainments: [Entertainment] = try await client.post(endpoint: Entertainments.search(json: EntertainmentSearchData(mediaType: .movie, mediaId: String(self.id))))
            if !entertainments.isEmpty, let result = entertainments.first {
                self.isEntertainment = true
                self.entertainmentID = result.id
                self.entertainment = result
                if result.watchStatus != nil {
                    return result
                }
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
    
    func markAsWatched() async {
        guard let client else { return }
        
        do {
            if let entertainment = self.entertainment, let watchlist = entertainment.watchStatus {
                let response = try await client.patch(endpoint: Watchlists.patch(id: watchlist.id, watchStatus: WatchStatusWrapper(watchStatus: .watched)))
                print(response!)
                if response?.statusCode == 200 {
                    self.hasWatched = true
                }
                print("Marked as watched")
            }
        } catch {
            if let error = error as? Models.ServerError {
                watchlistError = error.error
                showWatchlistErrorAlert = true
            }
        }
    }
    
    func markAsNotWatch() async {
        guard let client else { return }
        
        do {
            if let entertainment = self.entertainment, let watchlist = entertainment.watchStatus {
                let response = try await client.patch(endpoint: Watchlists.patch(id: watchlist.id, watchStatus: WatchStatusWrapper(watchStatus: .unwatched)))
                print(response!)
                if response?.statusCode == 200 {
                    self.hasWatched = false
                }
                print("Marked as not watch")
            }
        } catch {
            if let error = error as? Models.ServerError {
                watchlistError = error.error
                showWatchlistErrorAlert = true
            }
        }
    }
    
    
    func addToWatchlist() async {
        guard let client else { return }
        var entertainmentId: Int?
        //        var entertainment: Entertainment?
        do {
            if let id = self.entertainmentID, isEntertainment {
                entertainmentId = id
            } else {
                print("Creating entertainment with id: \(self.id)")
                let data: EntertainmentData = .init(
                    domain: "themoviedb.org",
                    mediaType: .movie,
                    mediaId: String(self.id), 
                    name: self.title,
                    overview: "",
                    genres: []
                )
                let entertainment: Entertainment = try await client.post(endpoint: Entertainments.post(json: data))
                
                entertainmentId = entertainment.id
            }
            
            if let entertainmentId {
                let _: Watchlist = try await client.post(endpoint: Watchlists.post(json: WatchlistData(entertainmentId: entertainmentId, watchStatus: .unwatched)))
                self.inWatchlist = true
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
            if let entertainment = self.entertainment, let watchlist = entertainment.watchStatus {
//                let entertainment: Entertainment = try await client.get(endpoint: Entertainments.get(id: id))
                _ = try await client.delete(endpoint: Watchlists.delete(id: watchlist.id))
                self.inWatchlist = false
            }

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


