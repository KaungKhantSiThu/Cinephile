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
    var isLoaded = false
    var isSearchPresented = false
    var trendingMovies: [Movie] = []
    var trendingSeries: [TVSeries] = []
    
    private let movieService = MovieService()
    private let seriesService = TVSeriesService()
    private let searchService = SearchService()
    
    init() { }
    
    func fetchTrending() async {
        do {
            let data = try await fetchTrendingData()
            trendingMovies = data.trendingMovies
            trendingSeries = data.trendingSeries
            
            withAnimation {
                isLoaded = true
            }
        } catch {
            isLoaded = true
        }
    }
    
    private struct TrendingData {
        let trendingMovies: [Movie]
        let trendingSeries: [TVSeries]
    }
    
    private func fetchTrendingData() async throws -> TrendingData {
        async let trendingMovies: [Movie] = movieService.popular().results
        async let trendingSeries: [TVSeries] = seriesService.popular().results
        
        return try await .init(trendingMovies: trendingMovies, trendingSeries: trendingSeries)
    }
    
    
    func searchMovies(using searchText: String) async {
        do {
            self.medias = try await searchService.searchAll(query: searchText).results
            print(medias.count)
        } catch {
            print("Search failed: \(error.localizedDescription)")
        }
    }
    
    func performSearch(using searchText: String) {
        Task {
            if !searchText.isEmpty {
                await self.searchMovies(using: searchText)
            } else {
                self.remove()
            }
        }
    }

    
    func remove() {
        self.medias.removeAll()
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
