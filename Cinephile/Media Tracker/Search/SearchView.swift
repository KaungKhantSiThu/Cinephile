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
        var body: some View {
            List(model.medias) { media in
                switch media {
                case .movie(let movie):
                    NavigationLink(value: movie) {
                        MediaRow(movie: movie, handler: addAction(id:))
                    }
                case .tvSeries(let series):
                    NavigationLink(value: series) {
                        MediaRow(tvSeries: series, handler: addAction(id:))
                    }
                case .person(let person):
                    MediaRow(person: person, handler: addAction(id:))
                }
            }
//            .navigationDestination(for: Movie.self) {
//                MovieDetailView(id: $0.id)
//            }
//            .navigationDestination(for: TVSeries.self) {
//                SeriesDetailView(id: $0.id) {
//                    print($0)
//                }
//            }
            .listStyle(.plain)
            .searchable(text: $model.searchText, prompt: "Search Movies, Series, Cast")
            .onChange(of: model.searchText) { value in
                model.performSearch(using: value)
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
