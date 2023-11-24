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
    
    func upcomingItems() async throws -> [Movie] {
        return try await movieService.upcoming().results
    }
}

struct TVSeriesLoader: DataLoader {
    
    typealias Output = TVSeries
    
    var tvSeriesService: TVSeriesService!
    var trendingService: TrendingService!
    
    init() {
        tvSeriesService = TVSeriesService()
        trendingService = TrendingService()
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
}
