//
//  URL+TMDb.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 23/11/2023.
//

import Foundation

extension URL {

    static var tmdbImageBaseURL: URL {
        URL(string: "http://image.tmdb.org/t/p/")!
    }

    static var tmdbImageSecureBaseURL: URL {
        URL(string: "https://image.tmdb.org/t/p/")!
    }
}
