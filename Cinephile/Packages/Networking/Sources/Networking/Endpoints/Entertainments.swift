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
            "cinphile/entertainments"
        case let .get(id):
            "cinphile/entertainments/\(id)"
            
        case .search:
            "cinphile/entertainments/search"
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
    
    public init(domain: String, mediaType: MediaType, mediaId: String) {
        self.domain = domain
        self.mediaType = mediaType
        self.mediaId = mediaId
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
