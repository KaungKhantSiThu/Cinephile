//
//  DataLoader.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 24/11/2023.
//

import Foundation
import TMDb

protocol DataLoader {
    associatedtype Output: Identifiable
    func loadItem(withID id: Output.ID) async throws -> Output
    func loadTrendingItems() async throws -> [Output]
    func loadCastMembers(withID id: Output.ID) async throws -> [CastMember]
    func loadRecommendedItems(withID id: Output.ID) async throws -> [Output]
    func loadUpcomingItems() async throws -> [Output]
    func loadVideos(withID id: Output.ID) async throws -> [VideoMetadata]
    func loadShowWatchProvider(withID id: Output.ID) async throws -> ShowWatchProvider?
}

struct MovieLoader: DataLoader {

    var movieService: MovieService!
    var trendingService: TrendingService!

    
    init() {
        movieService = MovieService()
        trendingService = TrendingService()
    }
    
    func loadItem(withID id: Movie.ID) async throws -> Movie {
        return try await movieService.details(forMovie: id)
    }
    
    func loadTrendingItems() async throws -> [Movie] {
        return try await trendingService.movies(inTimeWindow: .week, page: 1).results
    }
    
    func loadCastMembers(withID id: Movie.ID) async throws -> [CastMember] {
        return try await movieService.credits(forMovie: id).cast
    }
    
    func loadRecommendedItems(withID id: Movie.ID) async throws -> [Movie] {
        return try await movieService.recommendations(forMovie: id).results
    }
    
    func loadUpcomingItems() async throws -> [Movie] {
        return try await movieService.upcoming().results
    }
    
    func loadVideos(withID id: Movie.ID) async throws -> [VideoMetadata] {
        return try await movieService.videos(forMovie: id).results
    }
    
    func loadShowWatchProvider(withID id: Int) async throws -> ShowWatchProvider? {
        return try await movieService.watchProviders(forMovie: id)
    }
    
}

struct TVSeriesLoader: DataLoader {
    
    typealias Output = TVSeries
    
    var tvSeriesService: TVSeriesService!
    var trendingService: TrendingService!
    var episodeService: TVEpisodeService!
    
    init() {
        tvSeriesService = TVSeriesService()
        trendingService = TrendingService()
        episodeService = TVEpisodeService()
    }
    
    func loadItem(withID id: TVSeries.ID) async throws -> TVSeries {
        return try await tvSeriesService.details(forTVSeries: id)
    }
    
    func loadTrendingItems() async throws -> [TVSeries] {
        return try await trendingService.tvSeries(inTimeWindow: .week, page: 1).results
    }
    
    func loadCastMembers(withID id: Int) async throws -> [CastMember] {
        return try await tvSeriesService.credits(forTVSeries: id).cast
    }
    
    func loadRecommendedItems(withID id: TVSeries.ID) async throws -> [TVSeries] {
        return try await tvSeriesService.recommendations(forTVSeries: id).results
    }
    
    //Need to be fixed
    func loadUpcomingItems() async throws -> [TVSeries] {
        return try await tvSeriesService.popular().results
    }
    
    func loadVideos(withID id: TVSeries.ID) async throws -> [VideoMetadata] {
        return try await tvSeriesService.videos(forTVSeries: id).results
    }
    
    func loadShowWatchProvider(withID id: Int) async throws -> ShowWatchProvider? {
        return try await tvSeriesService.watchProviders(forTVSeries: id)
    }
}
