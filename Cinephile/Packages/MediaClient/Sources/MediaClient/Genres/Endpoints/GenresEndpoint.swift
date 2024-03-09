//
//  GenresEndpoint.swift
//
//
//  Created by Kaung Khant Si Thu on 08/03/2024.
//

import Foundation

public enum GenresEndpoint {
    
    case movie

}

extension GenresEndpoint: Endpoint {
    private static let basePath = URL(string: "/genre")!
    
    public var path: URL {
        switch self {
        case .movie:
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingPathComponent("list")
        }
    }
}
