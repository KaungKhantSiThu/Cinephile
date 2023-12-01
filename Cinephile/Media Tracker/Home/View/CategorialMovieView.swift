//
//  CategorialMovieView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 02/11/2023.
//

import SwiftUI
import TMDb

struct CategorialMovieView: View {
    let columns:[GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let movies: [Movie]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(movies) { movie in
                    NavigationLink(value: movie) {
                        MediaCoverView(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

#Preview {
    CategorialMovieView(movies: .preview)
}
