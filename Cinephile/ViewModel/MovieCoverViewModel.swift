//
//  MovieCoverViewModel.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 01/11/2023.
//

import Foundation
import TMDb

struct MovieCoverViewModel {
    let movie: Movie
    
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        return movie.title
    }
    
    var releasedDate: String {
        if let date = movie.releaseDate {
            return self.dateFormatter.string(from: date)
        } else {
            return "No Date"
        }
    }
    
}
