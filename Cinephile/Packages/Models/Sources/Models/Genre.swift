//
//  Genre.swift
//
//
//  Created by Kaung Khant Si Thu on 02/03/2024.
//

import Foundation

public struct Genre: Codable, Identifiable, Equatable, Hashable, Sendable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Genre, rhs: Genre) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: Int
    public let genreId: Int
    public let name: String
    public let isFollowed: Bool
    public let participantCount: Int
}

