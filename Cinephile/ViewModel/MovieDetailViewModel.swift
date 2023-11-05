//
//  MovieDetailViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 02/11/2023.
//

import SwiftUI
import TMDb

class MovieDetailViewModel: ObservableObject {
    let movieID: Movie.ID
//   @Published private(set) var showProvider: [WatchProvider]
    
    private let tmdb = TMDbAPI.init(apiKey: "a03aa105bd50498abba5719ade062653")
    
    init(movieID: Movie.ID) {
        self.movieID = movieID
    }
    
}
