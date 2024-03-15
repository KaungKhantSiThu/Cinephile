//
//  TrackerMedia.swift
//
//
//  Created by Kaung Khant Si Thu on 09/01/2024.
//

import Foundation

public enum MediaType: String, Codable, CaseIterable, Hashable, Equatable, Sendable {
    case movie
    case tvSeries = "series"
    
    public static func == (lhs: MediaType, rhs: MediaType) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
}

public struct TrackerMedia: Codable, Equatable, Hashable, Identifiable {
    public static func == (lhs: TrackerMedia, rhs: TrackerMedia) -> Bool {
      lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    public struct Genre: Identifiable, Codable, Equatable, Hashable {

        ///
        /// Genre Identifier.
        ///
        public let id: Int

        ///
        /// Genre name.
        ///
        public let name: String

        ///
        /// Creates a genre object.
        ///
        /// - Parameters:
        ///    - id: Genre Identifier.
        ///    - name: Genre name.
        ///
        public init(id: Int, name: String) {
            self.id = id
            self.name = name
        }

    }
    
    public let id: Int
    public let title: String
    public let posterURL: URL?
    public let runtime: Int?
    public let genres: [Genre]?
    public let releasedDate: Date?
    public let voteAverage: Double?
    public let mediaType: MediaType
    public let overview: String?
    
    public init(
        id: Int,
        title: String,
        posterURL: URL? = nil,
        runtime: Int? = nil,
        genres: [Genre]? = nil,
        releasedDate: Date? = nil,
        voteAverage: Double? = nil,
        mediaType: MediaType,
        overview: String? = nil
    ) {
        self.id = id
        self.title = title
        self.posterURL = posterURL
        self.runtime = runtime
        self.genres = genres
        self.releasedDate = releasedDate
        self.voteAverage = voteAverage
        self.mediaType = mediaType
        self.overview = overview
    }
}

extension TrackerMedia: Sendable {}

extension TrackerMedia.Genre: Sendable {}
