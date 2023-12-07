//
//  SearchViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 31/10/2023.


import TMDb
import SwiftUI

@MainActor
@Observable class SearchViewModel {
    var medias: [Media] = []
    var searchText = "" {
        didSet {
            isSearching = true
        }
    }
    
    var isSearching = false
    var isSearchPresented = false
    private(set) var state: LoadingState<TrendingData> = .idle
    
    private let movieService = MovieService()
    private let seriesService = TVSeriesService()
    private let searchService = SearchService()
    
    init() { }
    
    func fetchTrending() async {
        do {
            state = .loading
            let data = try await fetchTrendingData()
            
            withAnimation {
                state = .loaded(data)
            }
        } catch {
            print(error.localizedDescription)
            state = .failed(error)
        }
    }
    
    struct TrendingData {
        let trendingMovies: [Movie]
        let trendingSeries: [TVSeries]
    }
    
    private func fetchTrendingData() async throws -> TrendingData {
        async let trendingMovies: [Movie] = movieService.popular().results
        async let trendingSeries: [TVSeries] = seriesService.popular().results
        
        return try await .init(trendingMovies: trendingMovies, trendingSeries: trendingSeries)
    }
    
    func search() async {
        do {
            try await Task.sleep(for: .milliseconds(250))
            self.medias = try await searchService.searchAll(query: searchText, page: 1).results
            isSearching = false
        } catch {
            isSearching = false
        }
    }
}
