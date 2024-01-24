//
//  SearchViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 31/10/2023.


import SwiftUI
import OSLog
import MediaClient

private var logger = Logger(subsystem: "TrackerExploreView", category: "ViewModel")

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
    
    
    public var searchText = "" 
//    {
//        didSet {
//            isSearching = true
//        }
//    }
    
//    public var isSearching = false
    public var isSearchPresented = false
    
    public private(set) var state: LoadingState<DiscoverMedia> = .idle
    
    
    public init() { }
    
    public func fetchTrending() {
        self.state = .loading
        Task {
            do {
                logger.info("Fetching popular and upcoming movies and tv series")
                let data = try await fetchDiscoverMedia()
                logger.info("Fetching complete")
                self.state = .loaded(data)
            } catch {
                logger.error("Fetching failed: \(error.localizedDescription)")
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
        async let popularMovies: MoviePageableList = APIService.shared.get(endpoint: MoviesEndpoint.popular())
        async let popularTVSeries: TVSeriesPageableList = APIService.shared.get(endpoint: TVSeriesEndpoint.popular())
        async let upcomingMovies: MoviePageableList = APIService.shared.get(endpoint: MoviesEndpoint.upcoming())
        

        return try await .init(
            popularMovies: popularMovies.results,
            popularTVSeries: popularTVSeries.results,
            upcomingMovies: upcomingMovies.results
        )
    }
    
    public func search() async throws {
        guard !self.searchText.isEmpty else { return }
        do {
            switch searchScope {
            case .all:
                let mediaPagableList: MediaPageableList = try await APIService.shared.get(endpoint: SearchEndpoint.multi(query: searchText))
                self.medias = mediaPagableList.results
            case .movie:
                let mediaPagableList: MoviePageableList = try await APIService.shared.get(endpoint: SearchEndpoint.movies(query: searchText))
                self.medias = mediaPagableList.results.map { Media.movie($0) }
            case .tvSeries:
                let mediaPagableList: TVSeriesPageableList = try await APIService.shared.get(endpoint: SearchEndpoint.tvSeries(query: searchText))
                self.medias = mediaPagableList.results.map { Media.tvSeries($0) }
            case .people:
                let mediaPagableList: PersonPageableList = try await APIService.shared.get(endpoint: SearchEndpoint.people(query: searchText))
                self.medias = mediaPagableList.results.map { Media.person($0) }
            }
            
//            isSearching = false
        } catch {
//            isSearching = false
            logger.error("Fetching search results failed: \(error.localizedDescription)")
            throw error
        }
    }
}
