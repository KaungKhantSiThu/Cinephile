////
////  SearchView.swift
////  TMDB Test
////
////  Created by Kaung Khant Si Thu on 31/10/2023.
////
//
import SwiftUI
import TMDb

struct SearchView: View {
    @StateObject var model = SearchViewModel()
    @State private var searchText = ""
        var body: some View {
            NavigationStack {
                List(model.medias) { media in
                    switch media {
                    case .movie(let movie):
                        MediaRowView(movie: movie, handler: addAction(id:))
                    case .tvSeries(let series):
                        MediaRowView(tvSeries: series, handler: addAction(id:))
                    case .person(let person):
                        MediaRowView(person: person, handler: addAction(id:))
                    }
                }
                .listStyle(.plain)
//                .navigationDestination(for: Movie.self) {
//                    MovieDetailView(id: $0.id, addButtonAction: addAction(id:))
//                }
            }
            .searchable(text: $searchText, prompt: "Search Movies, Series, Cast")
            .onChange(of: searchText) { value in
                Task {
                    if !value.isEmpty && value.count > 1 {
                        await model.searchMovies(using: searchText)
                        print(model.medias.prefix(3))
                    } else {
                        model.remove()
                    }
                }
            }
        }
    
    func addAction(id: Int) {
        print("\(id) is added!")
    }
}

#Preview {
    SearchView()
}
