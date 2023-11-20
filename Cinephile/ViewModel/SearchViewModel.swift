//
//  SearchViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 31/10/2023.
//

import TMDb
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var trendingMovies: [String] = []
    
    private let tmdb = TMDbAPI.init(apiKey: "a03aa105bd50498abba5719ade062653")
    
    func searchMovies(using query: String) async {
        do {
            self.movies = try await tmdb.search.searchMovies(query: query).results
            print(movies.count)
        } catch {
            print("Search failed: \(error.localizedDescription)")
        }
    }
    
    func fetchTrendingMovies() async {
        do {
            self.trendingMovies = try await tmdb.trending.movies(inTimeWindow: .week).results.map(\.title)
        } catch {
            print("Trending movies failed: \(error.localizedDescription)")
        }
    }
    
    func removeMovies() {
        self.movies.removeAll()
    }
}
