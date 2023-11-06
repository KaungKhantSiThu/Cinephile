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
                    CarousalView(title: .discover, movies: movies)
                    CarousalView(title: .recommended, movies: movies)
                    CarousalView(title: .upcomming, movies: movies)

                }
                .navigationDestination(for: Movie.self) {
                    MovieDetailView(movie: $0, addButtonAction: addAction(id:))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("search")
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .tint(.red)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("Tracker")
                        .font(.largeTitle)
                        .font(.system(size: 60))
                        .fontWeight(.bold)
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
        .environmentObject(ViewModel(loader: MovieLoader()))

}
