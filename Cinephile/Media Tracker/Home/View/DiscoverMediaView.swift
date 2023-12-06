//
//  DiscoverMoviesView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 30/10/2023.
//

import SwiftUI
import TMDb

struct DiscoverMediaView: View {
    @StateObject private var model = DiscoverMediaViewModel(loader: MovieLoader())
    @State private var routerPath = RouterPath()
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            ScrollView {
                AsyncContentView(source: model) { movies in
                    CarousalView(title: "Trending Movies", movies: movies)
                    CarousalSeriesView(title: "Trending Series", series: model.series)
                    CarousalView(title: "Upcoming Movies", movies: model.upcomingMovies)
                }
                .withAppRouter()
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
        .environmentObject(routerPath)
    }
}

#Preview {
    DiscoverMediaView()
        .environmentObject(RouterPath())
}


