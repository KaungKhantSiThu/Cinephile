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
    @State private var showList = false
        var body: some View {
            List(model.medias) { media in
                switch media {
                case .movie(let movie):
                    NavigationLink(value: movie) {
                        MediaRow(movie: movie, handler: addAction(id:))
                    }
                case .tvSeries(let series):
                    MediaRow(tvSeries: series, handler: addAction(id:))
                case .person(let person):
                    MediaRow(person: person, handler: addAction(id:))
                }
            }
            .navigationDestination(for: Movie.self) {
                MovieDetailView(id: $0.id)
            }
            .listStyle(.plain)
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
    NavigationStack {
        SearchView()
    }
}
