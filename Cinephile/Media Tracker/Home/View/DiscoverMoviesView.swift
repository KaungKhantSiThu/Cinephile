//
//  DiscoverMoviesView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 30/10/2023.
//

import SwiftUI
import TMDb

struct DiscoverMoviesView: View {
    @StateObject private var model = ViewModel(loader: MovieLoader())
    var body: some View {
        NavigationStack {
            ScrollView {
                AsyncContentView(source: model) { movies in
                    CarousalView(title: "Trending Movies", movies: movies)
                    CarousalSeriesView(title: "Trending Series", series: model.series)
                    CarousalView(title: "Upcoming Movies", movies: model.upcomingMovies)
                }
                .navigationDestination(for: Movie.self) {
                    MovieDetailView(id: $0.id)
                }
            }
            .navigationTitle("Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .tint(.red)
                    }

                }
            }
        }
    }
    
    func addAction(id: Movie.ID) {
        print("\(id) is added!")
    }
}

#Preview {
    DiscoverMoviesView()
        .environmentObject(ViewModel(loader: PreviewMovieLoader()))
}


