//
//  Genres.swift
//
//
//  Created by Kaung Khant Si Thu on 02/03/2024.
//

import Foundation

public enum Genres: Endpoint {
    case genre(id: Int)
    case follow(id: Int)
    case unfollow(id: Int)
    case followedGenres
    case followGenres(json: GenreIDData)
    case unfollowGenres(json: GenreIDData)
    
    public func path() -> String {
        switch self {
        case let .genre(id):
            "cinephile/genres/\(id)/"
        case let .follow(id):
            "cinephile/genres/\(id)/follow"
        case let .unfollow(id):
            "cinephile/genres/\(id)/unfollow"
        case .followedGenres:
            "cinephile/followed_genres"
        case .followGenres:
            "cinephile/genres/follow_genres"
        case .unfollowGenres:
            "cinephile/genres/unfollow_genres"
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        default:
            nil
        }
    }
    
    public var jsonValue: Encodable? {
        switch self {
        case .followGenres(let json):
            json
        case .unfollowGenres(let json):
            json
        default:
            nil
        }
    }
}

public struct GenreIDData: Encodable, Sendable {
    public let genreIds: [Int]
    
    public init(genreIds: [Int]) {
        self.genreIds = genreIds
    }
}
