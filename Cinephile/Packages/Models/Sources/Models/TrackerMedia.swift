//
//  TrackerMedia.swift
//
//
//  Created by Kaung Khant Si Thu on 09/01/2024.
//

import Foundation

public struct TrackerMedia: Codable, Equatable, Hashable, Identifiable {
    public static func == (lhs: TrackerMedia, rhs: TrackerMedia) -> Bool {
      lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    public enum MediaType: String, Codable, CaseIterable, Hashable, Equatable, Sendable {
        case movie
        case tvSeries
        
        public static func == (lhs: MediaType, rhs: MediaType) -> Bool {
          lhs.rawValue == rhs.rawValue
        }
    }
    
    public let id: Int
    public let title: String
    public let posterURL: URL?
    public let releasedDate: Date?
    public let voteAverage: Double?
    public let mediaType: MediaType
    
    public init(id: Int, title: String, posterURL: URL?, releasedDate: Date?, voteAverage: Double?, mediaType: MediaType) {
        self.id = id
        self.title = title
        self.posterURL = posterURL
        self.releasedDate = releasedDate
        self.voteAverage = voteAverage
        self.mediaType = mediaType
    }
}

extension TrackerMedia: Sendable {}
