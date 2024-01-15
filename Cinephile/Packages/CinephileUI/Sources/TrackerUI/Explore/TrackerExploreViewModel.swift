//
//  SearchViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 31/10/2023.


import TMDb
import SwiftUI

@MainActor
@Observable public class TrackerExploreViewModel {
    
    public enum SearchScope: String, CaseIterable, Equatable {
        case all, movie, tvSeries, people
        
        public var localizedString: LocalizedStringKey {
            switch self {
            case .all:
                "all"
            case .movie:
                "movie"
            case .tvSeries:
                "tvSeries"
            case .people:
                "people"
            }
        }
    }
    
    @MainActor
    public enum LoadingState<Value> {
        case idle
        case loading
        case failed(Error)
        case loaded(Value)
    }
    
    public private(set) var medias: [Media] = []
    
    public var searchScope: SearchScope = .all
    
    
    public var searchText = "" {
        didSet {
            isSearching = true
        }
    }
    
    public var isSearching = false
    public var isSearchPresented = false
    
    public private(set) var state: LoadingState<DiscoverMedia> = .idle
    
    private let movieService: MovieService!
    private let seriesService: TVSeriesService!
    private let searchService: SearchService!
    
    public init() {
        movieService = MovieService()
        seriesService = TVSeriesService()
        searchService = SearchService()
    }
    
    public func fetchTrending() {
        self.state = .loading
        Task {
            do {
                let data = try await fetchDiscoverMedia()
                self.state = .loaded(data)
            } catch {
                print(error.localizedDescription)
                self.state = .failed(error)
            }
        }
    }
    
    public struct DiscoverMedia {
        public let popularMovies: [Movie]
        public let popularTVSeries: [TVSeries]
        public let upcomingMovies: [Movie]
    }
    
    
    private func fetchDiscoverMedia() async throws -> DiscoverMedia {
        async let popularMovies: [Movie] = movieService.popular().results
        async let popularTVSeries: [TVSeries] = seriesService.popular().results
        async let upcomingMovies: [Movie] = movieService.upcoming().results

        return try await .init(
            popularMovies: popularMovies,
            popularTVSeries: popularTVSeries,
            upcomingMovies: upcomingMovies
        )
    }
    
    public func search() async {
        guard !self.searchText.isEmpty else { return }
        do {
            try await Task.sleep(for: .milliseconds(250))
            switch searchScope {
            case .all:
                self.medias = try await searchService.searchAll(query: searchText, page: 1).results
            case .movie:
                self.medias = try await searchService.searchMovies(query: searchText, page: 1).results.map { Media.movie($0) }
            case .tvSeries:
                self.medias = try await searchService.searchTVSeries(query: searchText, page: 1).results.map { Media.tvSeries($0) }
            case .people:
                self.medias = try await searchService.searchPeople(query: searchText, page: 1).results.map { Media.person($0) }
            }
            
            isSearching = false
        } catch {
            isSearching = false
        }
    }
}
