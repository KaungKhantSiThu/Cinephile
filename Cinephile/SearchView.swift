//
//  SearchView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 31/10/2023.
//

import SwiftUI
import TMDb

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @State private var searchText = ""
        var body: some View {
            NavigationStack {
                List {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(value: movie) {
                            MovieRow(movie: movie)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationDestination(for: Movie.self) {
                    MovieDetailView(movie: $0, addButtonAction: addAction(id:))
                }
            }
            .searchable(text: $searchText, prompt: "Search Movies, Series, Cast")
            .onChange(of: searchText) { value in
                Task {
                    if !value.isEmpty && value.count > 1 {
                        await viewModel.searchMovies(using: value)
                    } else {
                        viewModel.removeMovies()
                    }
                }
            }
        }
    
    func addAction(id: Movie.ID) {
        print("\(id) is added!")
    }
}

#Preview {
    SearchView()
        .environmentObject(SearchViewModel())
}
