//
//  CategorialMovieView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 02/11/2023.
//

import SwiftUI
import TMDb
import TrackerUI

struct CategorialMovieView: View {
    let columns:[GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let movies: [Movie]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(movies) { movie in
                    NavigationLink(value: movie) {
                        MediaCover(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationDestination(for: Movie.self) { movie in
            MovieDetailView(id: movie.id)
        }
    }
}

//#Preview {
//    NavigationStack {
//        CategorialMovieView(movies: .preview)
//    }
//}
