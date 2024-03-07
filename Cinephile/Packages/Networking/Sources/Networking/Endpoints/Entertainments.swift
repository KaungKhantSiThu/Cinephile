//
//  File.swift
//
//
//  Created by Kaung Khant Si Thu on 20/01/2024.
//

import Foundation
import Models

public enum Entertainments: Endpoint {
    case post(json: EntertainmentData)
    case get(id: Int)
    case search(json: EntertainmentSearchData)
    
    public func path() -> String {
        switch self {
        case .post:
            "cinephile/entertainments"
        case let .get(id):
            "cinephile/entertainments/\(id)"
            
        case .search:
            "cinephile/entertainments/search"
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    public var jsonValue: Encodable? {
        switch self {
        case .post(let json):
            json
        case .search(let json):
            json
        default:
            nil
        }
    }
}

public struct EntertainmentData: Encodable, Sendable {
    public let domain: String
    public let mediaType: MediaType
    public let mediaId: String
    public let genres: [GenreData]
    
    public init(domain: String, mediaType: MediaType, mediaId: String, genres: [GenreData]) {
        self.domain = domain
        self.mediaType = mediaType
        self.mediaId = mediaId
        self.genres = genres
    }
    
    public struct GenreData: Encodable, Sendable {
        public let genreId: Int
        public let name: String
        
        public init(genreId: Int, name: String) {
            self.genreId = genreId
            self.name = name
        }
    }
}

public struct EntertainmentSearchData: Encodable, Sendable {
    public let mediaType: MediaType
    public let mediaId: String
    
    public init(mediaType: MediaType, mediaId: String) {
        self.mediaType = mediaType
        self.mediaId = mediaId
    }
}
