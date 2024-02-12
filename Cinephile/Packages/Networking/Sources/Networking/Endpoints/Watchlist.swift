//
//  File.swift
//  
//
//  Created by Kaung Khant Si Thu on 09/02/2024.
//

import Foundation
import Models

public enum Watchlists: Endpoint {
    case getAll
    case get(id: Int)
    case post(json: WatchlistData)
    case patch(id: Int, watchStatus: WatchStatusWrapper)
    case delete(id: Int)

    public func path() -> String {
        switch self {
        case .getAll, .post:
            "cinephile/watch_lists"
        case let .get(id), let .delete(id), let .patch(id, _):
            "cinephile/watch_lists/\(id)"
        }
    }

    public func queryItems() -> [URLQueryItem]? {
        switch self {
        default: nil
        }
    }

    public var jsonValue: Encodable? {
        switch self {
        case .post(let json):
            json
        case .patch(_, let watchStatus):
            watchStatus
        default: nil
        }
    }
}

public struct WatchlistData: Encodable, Sendable {
    public let entertainmentId: Int
    public let watchStatus: WatchStatus
    
    public init(entertainmentId: Int, watchStatus: WatchStatus) {
        self.entertainmentId = entertainmentId
        self.watchStatus = watchStatus
    }
}
