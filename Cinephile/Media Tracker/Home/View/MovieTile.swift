//
//  MovieTile.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 07/12/2023.
//

import SwiftUI
import TMDb
import SDWebImageSwiftUI

struct MovieTile: View {
    let movie: Movie
    var body: some View {
        HStack {
            PosterImage(url: movie.posterPath!, height: 90, roundedCorner: false)
        }
    }
}

#Preview {
    MovieTile(movie: .preview)
}
