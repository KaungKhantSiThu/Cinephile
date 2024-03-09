//
//  Entertainment.swift
//
//
//  Created by Kaung Khant Si Thu on 20/01/2024.
//

import Foundation

public struct Entertainment: Codable, Identifiable, Hashable, Equatable, Sendable {
    
    public var id: Int
    public let domain: String
    public let mediaType: MediaType
    public let mediaId: String
    public let watchStatus: Watchlist?
    public let genres: [Genre]
    
    public struct Watchlist: Codable, Identifiable, Hashable, Equatable, Sendable {
        /*
         "account_id": 111855602126810639,
                         "entertainment_id": 12,
                         "watch_status": "unwatched",
                         "created_at": "2024-02-11T07:56:31.168Z",
                         "updated_at": "2024-02-11T07:56:31.168Z",
                         "id": 10
         */
        public var id: Int
        public let entertainmentId: Int
        public let accountId: Int
        public let watchStatus: WatchStatus?
    }
}

public struct WatchlistEntertainment: Codable, Identifiable, Hashable, Equatable, Sendable {
    
    public let id: Int
    public let watchStatus: WatchStatus
    public let entertainment: Entertainment
}

