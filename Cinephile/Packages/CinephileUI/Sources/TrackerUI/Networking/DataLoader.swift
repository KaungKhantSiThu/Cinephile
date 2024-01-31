//
//  DataLoader.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 24/11/2023.
//

import Foundation
import MediaClient

protocol DataLoader {
    associatedtype Output: Identifiable
    func loadItem(withID id: Output.ID) async throws -> Output
    func loadTrendingItems() async throws -> [Output]
    func loadCastMembers(withID id: Output.ID) async throws -> [CastMember]
    func loadRecommendations(withID id: Output.ID) async throws -> [Output]
    func loadUpcomingItems() async throws -> [Output]
    func loadVideos(withID id: Output.ID) async throws -> [VideoMetadata]
    func loadShowWatchProvider(withID id: Output.ID) async throws -> ShowWatchProvider?
}

struct MovieLoader: DataLoader {

    
    init() {
        
    }
    
    func loadItem(withID id: Movie.ID) async throws -> Movie {
        return try await APIService.shared.get(endpoint: MoviesEndpoint.details(movieID: id))
    }
    
    func loadTrendingItems() async throws -> [Movie] {
        let moviePagebleList: MoviePageableList = try await APIService.shared.get(endpoint: TrendingEndpoint.movies(timeWindow: .week))
        return moviePagebleList.results
    }
    
    func loadCastMembers(withID id: Movie.ID) async throws -> [CastMember] {
        let showCredits: ShowCredits = try await APIService.shared.get(endpoint: MoviesEndpoint.credits(movieID: id))
        return showCredits.cast
    }
    
    func loadRecommendations(withID id: Movie.ID) async throws -> [Movie] {
        let moviePagebleList: MoviePageableList = try await APIService.shared.get(endpoint: MoviesEndpoint.recommendations(movieID: id))
        return moviePagebleList.results
    }
    
    func loadUpcomingItems() async throws -> [Movie] {
        let moviePagebleList: MoviePageableList = try await APIService.shared.get(endpoint: MoviesEndpoint.upcoming())
        return moviePagebleList.results
    }
    
    func loadVideos(withID id: Movie.ID) async throws -> [VideoMetadata] {
        let videoCollection: VideoCollection = try await APIService.shared.get(endpoint: MoviesEndpoint.videos(movieID: id, languageCode: Locale.preferredLanguages[0]))
        return videoCollection.results
    }
    
    func loadShowWatchProvider(withID id: Int) async throws -> ShowWatchProvider? {
        let result: ShowWatchProviderResult = try await APIService.shared.get(endpoint: MoviesEndpoint.watch(movieID: id))
        return result.results[Locale.current.region?.identifier ?? "us"]
    }
    
}

struct TVSeriesLoader: DataLoader {
    
    typealias Output = TVSeries
    
    
    init() { }
    
    func loadItem(withID id: TVSeries.ID) async throws -> TVSeries {
        return try await APIService.shared.get(endpoint: TVSeriesEndpoint.details(tvSeriesID: id))
    }
    
    func loadTrendingItems() async throws -> [TVSeries] {
        let tvSeriesPagebleList: TVSeriesPageableList = try await APIService.shared.get(endpoint: TrendingEndpoint.tvSeries(timeWindow: .week))
        return tvSeriesPagebleList.results
    }
    
    func loadCastMembers(withID id: TVSeries.ID) async throws -> [CastMember] {
        let showCredits: ShowCredits = try await APIService.shared.get(endpoint: TVSeriesEndpoint.credits(tvSeriesID: id))
        return showCredits.cast
    }
    
    func loadRecommendations(withID id: TVSeries.ID) async throws -> [TVSeries] {
        let tvSeriesPagebleList: TVSeriesPageableList = try await APIService.shared.get(endpoint: TVSeriesEndpoint.recommendations(tvSeriesID: id))
        return tvSeriesPagebleList.results
    }
    
    func loadUpcomingItems() async throws -> [TVSeries] {
        let tvSeriesPagebleList: TVSeriesPageableList = try await APIService.shared.get(endpoint: TVSeriesEndpoint.popular())
        return tvSeriesPagebleList.results
    }
    
    func loadVideos(withID id: TVSeries.ID) async throws -> [VideoMetadata] {
        let videoCollection: VideoCollection = try await APIService.shared.get(endpoint: TVSeriesEndpoint.videos(tvSeriesID: id, languageCode: Locale.preferredLanguages[0]))
        return videoCollection.results
    }
    
    func loadShowWatchProvider(withID id: Int) async throws -> ShowWatchProvider? {
        let result: ShowWatchProviderResult = try await APIService.shared.get(endpoint: TVSeriesEndpoint.watch(tvSeriesID: id))
        return result.results[Locale.current.region?.identifier ?? "us"]
    }
}
